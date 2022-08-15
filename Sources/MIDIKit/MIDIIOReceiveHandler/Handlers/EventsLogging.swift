//
//  EventsLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import os.log

extension MIDIIOReceiveHandler {
    /// MIDI Event logging handler (event description strings).
    /// If `handler` is nil, all events are logged to the console (but only in `DEBUG` preprocessor flag builds).
    /// If `handler` is provided, the event description string is supplied as a parameter and not automatically logged.
    public final class EventsLogging: MIDIIOReceiveHandlerProtocol {
        public typealias Handler = (_ eventString: String) -> Void
        
        @inline(__always)
        public var handler: Handler
        
        internal let midi1Parser = MIDI1Parser()
        internal let midi2Parser = MIDI2Parser()
        
        @inline(__always)
        public var filterActiveSensingAndClock = false
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                let events = midi1Parser.parsedEvents(in: midiPacket)
                guard !events.isEmpty else { continue }
                logEvents(events)
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
                logEvents(events)
            }
        }
        
        internal init(
            filterActiveSensingAndClock: Bool = false,
            log: OSLog = .default,
            _ handler: Handler? = nil
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
        
        internal func logEvents(_ events: [MIDIEvent]) {
            var events = events
            
            if filterActiveSensingAndClock {
                events = events.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
            }
            
            let stringOutput: String = events
                .map { "\($0)" }
                .joined(separator: ", ")
            
            handler(stringOutput)
        }
    }
}

#endif
