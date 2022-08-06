//
//  EventsLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import os.log

extension MIDI.IO.ReceiveHandler {
    /// MIDI Event logging handler (event description strings).
    /// If `handler` is nil, all events are logged to the console (but only in DEBUG builds, not in RELEASE builds).
    /// If `handler` is provided, the event description string is supplied as a parameter and not automatically logged.
    public class EventsLogging: MIDIIOReceiveHandlerProtocol {
        public typealias Handler = (_ eventString: String) -> Void
        
        @inline(__always)
        public var handler: Handler
        
        internal let midi1Parser = MIDI.IO.MIDI1Parser()
        internal let midi2Parser = MIDI.IO.MIDI2Parser()
        
        @inline(__always)
        public var filterActiveSensingAndClock = false
        
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDI.IO.Packet.PacketData]
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
            _ packets: [MIDI.IO.Packet.UniversalPacketData],
            protocol midiProtocol: MIDI.IO.ProtocolVersion
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
        
        internal func logEvents(_ events: [MIDI.Event]) {
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
