//
//  WeakEventsReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDIReceiveHandler {
    /// MIDI Event receive handler that holds a weak reference to a receiver object.
    final class WeakEventsReceiver: MIDIReceiveHandlerProtocol {
        public weak var receiver: ReceivesMIDIEvents?
        
        let midi1Parser: MIDI1Parser
        
        var midi2Parser: MIDI2Parser? = nil
        var advancedMIDI2Parser: AdvancedMIDI2Parser? = nil
        
        let options: MIDIReceiverOptions
        
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                handle(events: events)
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
                    handle(events: events)
                }
            } else if let parser = advancedMIDI2Parser {
                for midiPacket in packets {
                    parser.parseEvents(in: midiPacket)
                }
            }
        }
        
        init(
            options: MIDIReceiverOptions,
            receiver: ReceivesMIDIEvents
        ) {
            self.options = options
            self.receiver = receiver
            
            // MIDI 1
            
            midi1Parser = MIDI1Parser()
            
            midi1Parser.translateNoteOnZeroVelocityToNoteOff = options
                .contains(.translateMIDI1NoteOnZeroVelocityToNoteOff)
            
            // MIDI 2
            
            if options.contains(.bundleRPNAndNRPNDataEntryLSB) {
                advancedMIDI2Parser = AdvancedMIDI2Parser { [weak self] events, _, _ in
                    self?.handle(events: events)
                }
            } else {
                midi2Parser = MIDI2Parser()
            }
        }
        
        func handle(events: [MIDIEvent]) {
            if options.contains(.filterActiveSensingAndClock) {
                let filtered = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
                guard !filtered.isEmpty else { return }
                receiver?.midiIn(events: filtered)
            } else {
                receiver?.midiIn(events: events)
            }
        }
    }
}

#endif
