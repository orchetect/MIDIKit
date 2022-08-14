//
//  Events.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIIOReceiveHandler {
    /// MIDI Event receive handler.
    public class Events: MIDIIOReceiveHandlerProtocol {
        public typealias Handler = (_ events: [MIDIEvent]) -> Void
        
        @inline(__always)
        public var handler: Handler
        
        internal let midi1Parser = MIDI1Parser()
        internal let midi2Parser = MIDI2Parser()
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handler(events)
            }
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                let events = midi2Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handler(events)
            }
        }
        
        internal init(
            translateMIDI1NoteOnZeroVelocityToNoteOff: Bool = true,
            _ handler: @escaping Handler
        ) {
            midi1Parser.translateNoteOnZeroVelocityToNoteOff =
                translateMIDI1NoteOnZeroVelocityToNoteOff
            self.handler = handler
        }
    }
}

#endif
