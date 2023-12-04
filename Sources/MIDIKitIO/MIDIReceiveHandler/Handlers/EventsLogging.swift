//
//  EventsLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import os.log

extension MIDIReceiver {
    public typealias EventsLoggingHandler = (_ eventString: String) -> Void
}

extension MIDIReceiveHandler {
    /// MIDI Event logging handler (event description strings).
    /// If `handler` is nil, all events are logged to the console (but only in `DEBUG` preprocessor
    /// flag builds).
    /// If `handler` is provided, the event description string is supplied as a parameter and not
    /// automatically logged.
    final class EventsLogging: MIDIReceiveHandlerProtocol {
        public var handler: MIDIReceiver.EventsLoggingHandler
    
        let midi1Parser: MIDI1Parser
        
        var midi2Parser: MIDI2Parser? = nil
        var advancedMIDI2Parser: AdvancedMIDI2Parser? = nil
    
        public let options: MIDIReceiverOptions
    
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                prepLogMessage(
                    events: events,
                    timeStamp: midiPacket.timeStamp,
                    source: midiPacket.source
                )
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
                    handle(events: events, timeStamp: midiPacket.timeStamp, source: midiPacket.source)
                }
            } else if let parser = advancedMIDI2Parser {
                for midiPacket in packets {
                    parser.parseEvents(in: midiPacket)
                }
            }
        }
    
        init(
            options: MIDIReceiverOptions,
            log: OSLog = .default,
            handler: MIDIReceiver.EventsLoggingHandler?
        ) {
            self.options = options
            
            self.handler = handler ?? { packetBytesString in
                #if DEBUG
                os_log(
                    "%{public}@",
                    log: log,
                    type: .debug,
                    packetBytesString
                )
                #endif
            }
            
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
            guard !events.isEmpty else { return }
            prepLogMessage(
                events: events,
                timeStamp: timeStamp,
                source: source
            )
        }
        
        func prepLogMessage(
            events: [MIDIEvent],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
            var events = events
            
            if options.contains(.filterActiveSensingAndClock) {
                events = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
            }
            
            var stringOutput: String = events
                .map { "\($0)" }
                .joined(separator: ", ")
                + " timeStamp:\(timeStamp)"
            
            // not all packets will contain source refs
            if let source {
                stringOutput += " source:\(source.displayName.quoted)"
            }
            
            handler(stringOutput)
        }
    }
}

#endif
