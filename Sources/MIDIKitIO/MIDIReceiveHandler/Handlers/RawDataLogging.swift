//
//  RawDataLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import os.log
@_implementationOnly import SwiftRadix

extension MIDIReceiver {
    public typealias RawDataLoggingHandler = (_ packetBytesString: String) -> Void
}

extension MIDIReceiveHandler {
    /// Raw data logging handler (hex byte strings).
    ///
    /// If `handler` is `nil`, all raw packet data is logged to the console (but only in `DEBUG` preprocessor flag builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not automatically logged.
    class RawDataLogging: MIDIReceiveHandlerProtocol {
        @inline(__always)
        public var handler: MIDIReceiver.RawDataLoggingHandler
    
        @inline(__always)
        public var filterActiveSensingAndClock = false
    
        @inline(__always)
        public func packetListReceived(
            _ packets: [MIDIPacketData]
        ) {
            for midiPacket in packets {
                handleBytes(midiPacket.bytes)
            }
        }
    
        @available(macOS 11, iOS 14, macCatalyst 14, *)
        @inline(__always)
        public func eventListReceived(
            _ packets: [UniversalMIDIPacketData],
            protocol midiProtocol: MIDIProtocolVersion
        ) {
            for midiPacket in packets {
                handleBytes(midiPacket.bytes)
            }
        }
    
        internal init(
            filterActiveSensingAndClock: Bool = false,
            log: OSLog = .default,
            _ handler: MIDIReceiver.RawDataLoggingHandler? = nil
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
    
        internal func handleBytes(_ bytes: [Byte]) {
            if filterActiveSensingAndClock {
                guard bytes.first != 0xF8, // midi clock pulse
                      bytes.first != 0xFE  // active sensing
                else { return }
            }
    
            let stringOutput =
                bytes.hex
                    .stringValues(padTo: 2, prefixes: false)
                    .joined(separator: " ")
    
            handler(stringOutput)
        }
    }
}

#endif
