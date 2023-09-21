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
    
        let midi1Parser = MIDI1Parser()
        let midi2Parser = MIDI2Parser()
    
        public var filterActiveSensingAndClock = false
    
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                logEvents(
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
            for midiPacket in packets {
                let events = midi2Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                logEvents(
                    events: events,
                    timeStamp: midiPacket.timeStamp,
                    source: midiPacket.source
                )
            }
        }
    
        init(
            filterActiveSensingAndClock: Bool = false,
            log: OSLog = .default,
            _ handler: MIDIReceiver.EventsLoggingHandler? = nil
        ) {
            self.filterActiveSensingAndClock = filterActiveSensingAndClock
    
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
        }
    
        func logEvents(
            events: [MIDIEvent],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
            var events = events
            
            if filterActiveSensingAndClock {
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
