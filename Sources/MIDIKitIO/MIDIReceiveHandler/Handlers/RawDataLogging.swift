//
//  RawDataLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import os.log

extension MIDIReceiver {
    public typealias RawDataLoggingHandler = (_ packetBytesString: String) -> Void
}

extension MIDIReceiveHandler {
    /// Raw data logging handler (hex byte strings).
    /// On systems that use legacy MIDI 1.0 packets, their raw bytes will be logged.
    /// On systems that support UMP and MIDI 2.0, the raw UMP packet data is logged.
    ///
    /// If `handler` is `nil`, all raw packet data is logged to the console (but only in `DEBUG`
    /// preprocessor flag builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not
    /// automatically logged.
    final class RawDataLogging: MIDIReceiveHandlerProtocol {
        public var handler: MIDIReceiver.RawDataLoggingHandler
    
        public var filterActiveSensingAndClock = false
    
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                log(
                    bytes: midiPacket.bytes,
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
                log(
                    bytes: midiPacket.bytes,
                    timeStamp: midiPacket.timeStamp,
                    source: midiPacket.source
                )
            }
        }
    
        init(
            log: OSLog = .default,
            handler: MIDIReceiver.RawDataLoggingHandler? = nil
        ) {
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
    
        func log(
            bytes: [UInt8],
            timeStamp: CoreMIDITimeStamp,
            source: MIDIOutputEndpoint?
        ) {
            var stringOutput = bytes
                .hexString(padEachTo: 2, prefixes: false)
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
