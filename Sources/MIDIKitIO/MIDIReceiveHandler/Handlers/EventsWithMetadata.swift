//
//  EventsWithMetadata.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    public typealias EventsWithMetadataHandler = (
        _ events: [MIDIEvent],
        _ timeStamp: CoreMIDITimeStamp,
        _ source: MIDIOutputEndpoint?
    ) -> Void
}

extension MIDIReceiveHandler {
    /// MIDI Event receive handler including packet timestamp and source endpoint metadata.
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    final class EventsWithMetadata: MIDIReceiveHandlerProtocol {
        public var handler: MIDIReceiver.EventsWithMetadataHandler
        
        let midi1Parser = MIDI1Parser()
        let midi2Parser = MIDI2Parser()
        
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                
                handler(events, midiPacket.timeStamp, midiPacket.source)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                let events = midi2Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handler(events, midiPacket.timeStamp, midiPacket.source)
            }
        }
        
        init(
            translateMIDI1NoteOnZeroVelocityToNoteOff: Bool = true,
            _ handler: @escaping MIDIReceiver.EventsWithMetadataHandler
        ) {
            midi1Parser.translateNoteOnZeroVelocityToNoteOff =
                translateMIDI1NoteOnZeroVelocityToNoteOff
            self.handler = handler
        }
    }
}

#endif
