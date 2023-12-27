//
//  EventsBase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiver {
    /// Foundational receiver class which other events receivers subclass.
    class EventsBase: MIDIReceiverProtocol {
        let midi1Parser: MIDI1Parser
        
        var midi2Parser: MIDI2Parser? = nil
        var advancedMIDI2Parser: AdvancedMIDI2Parser? = nil
        
        let options: MIDIReceiverOptions
        
        func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                
                handle(events: events, timeStamp: midiPacket.timeStamp, source: midiPacket.source)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            if let parser = midi2Parser {
                for midiPacket in packets {
                    let events = parser.parsedEvents(in: midiPacket)
                    guard !events.isEmpty else { continue }
                    
                    handle(events: events, timeStamp: midiPacket.timeStamp, source: midiPacket.source)
                }
            } else if let parser = advancedMIDI2Parser {
                for midiPacket in packets {
                    parser.parseEvents(in: midiPacket)
                }
            }
        }
        
        init(options: MIDIReceiverOptions) {
            // store options
            self.options = options
            
            // MIDI 1
            midi1Parser = MIDI1Parser()
            midi1Parser.translateNoteOnZeroVelocityToNoteOff = options
                .contains(.translateMIDI1NoteOnZeroVelocityToNoteOff)
            
            // MIDI 2
            if options.contains(.bundleRPNAndNRPNDataEntryLSB) {
                advancedMIDI2Parser = AdvancedMIDI2Parser { [weak self] events, timeStamp, source in
                    self?.handle(events: events, timeStamp: timeStamp, source: source)
                }
            } else {
                midi2Parser = MIDI2Parser()
            }
        }
        
        func handle(
            events: [MIDIEvent],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
            // method must be overridden by subclasses
            assertionFailure("EventsBase subclasses must implement func handle(events:timeStamp:source:).")
        }
    }
}

#endif
