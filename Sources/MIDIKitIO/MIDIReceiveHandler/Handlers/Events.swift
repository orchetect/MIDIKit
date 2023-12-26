//
//  Events.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    /// Handler for the ``events(options:_:)`` MIDI receiver.
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    public typealias EventsHandler = (
        _ events: [MIDIEvent],
        _ timeStamp: CoreMIDITimeStamp,
        _ source: MIDIOutputEndpoint?
    ) -> Void
}

extension MIDIReceiveHandler {
    /// MIDI Event receive handler including packet timestamp and source endpoint.
    /// Source endpoint is only available when used with ``MIDIInputConnection`` and will always be
    /// `nil` when used with ``MIDIInput``.
    final class Events: MIDIReceiveHandlerProtocol {
        public var handler: MIDIReceiver.EventsHandler
        
        let midi1Parser: MIDI1Parser
        
        var midi2Parser: MIDI2Parser? = nil
        var advancedMIDI2Parser: AdvancedMIDI2Parser? = nil
        
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
            if let parser = midi2Parser {
                for midiPacket in packets {
                    let events = parser.parsedEvents(in: midiPacket)
                    guard !events.isEmpty else { continue }
                    
                    handler(events, midiPacket.timeStamp, midiPacket.source)
                }
            } else if let parser = advancedMIDI2Parser {
                for midiPacket in packets {
                    parser.parseEvents(in: midiPacket)
                }
            }
        }
        
        init(
            options: MIDIReceiverOptions,
            handler: @escaping MIDIReceiver.EventsHandler
        ) {
            if options.contains(.filterActiveSensingAndClock) {
                self.handler = { events, timeStamp, source in
                    let filtered = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
                    guard !filtered.isEmpty else { return }
                    handler(filtered, timeStamp, source)
                }
            } else {
                self.handler = handler
            }
            
            // MIDI 1
            
            midi1Parser = MIDI1Parser()
            
            midi1Parser.translateNoteOnZeroVelocityToNoteOff = options
                .contains(.translateMIDI1NoteOnZeroVelocityToNoteOff)
            
            // MIDI 2
            
            if options.contains(.bundleRPNAndNRPNDataEntryLSB) {
                advancedMIDI2Parser = AdvancedMIDI2Parser { [weak self] events, timeStamp, source in
                    self?.handler(events, timeStamp, source)
                }
            } else {
                midi2Parser = MIDI2Parser()
            }
        }
    }
}

#endif
