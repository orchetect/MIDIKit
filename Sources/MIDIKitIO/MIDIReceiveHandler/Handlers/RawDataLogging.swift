//
//  RawDataLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import os.log

extension MIDIReceiver {
    /// Handler for the ``rawDataLogging(_:)`` MIDI receiver.
    public typealias RawDataLoggingHandler = @Sendable (_ packetBytesString: String) -> Void
    
    /// Raw data logging handler (hex byte strings).
    /// On systems that use legacy MIDI 1.0 packets, their raw bytes will be logged.
    /// On systems that support UMP and MIDI 2.0, the raw UMP packet data is logged.
    ///
    /// If `handler` is `nil`, all raw packet data is logged to the console (but only in `DEBUG`
    /// preprocessor flag builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not
    /// automatically logged.
    static func _rawDataLogging(
        log: OSLog = .default,
        handler: RawDataLoggingHandler?
    ) -> RawData {
        let stringLogHandler: RawDataLoggingHandler = handler ?? { packetBytesString in
            #if DEBUG
            os_log(
                "%{public}@",
                log: log,
                type: .debug,
                packetBytesString
            )
            #endif
        }
        
        return RawData { packet in
            let logString = generateLogString(
                bytes: packet.bytes,
                timeStamp: packet.timeStamp,
                source: packet.source
            )
            stringLogHandler(logString)
        }
    }
    
    fileprivate static func generateLogString(
        bytes: [UInt8],
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?
    ) -> String {
        var stringOutput = bytes
            .hexString(padEachTo: 2, prefixes: false)
            + " timeStamp:\(timeStamp)"
        
        // not all packets will contain source refs
        if let source {
            stringOutput += " source:\(source.displayName.quoted)"
        }
        
        return stringOutput
    }
}

#endif
