//
//  Event PortPrefix.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - MIDIPortPrefix

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public struct PortPrefix {
        /// Port number (`0 ... 127`)
        public var port: UInt7 = 0
        
        // MARK: - Init
        
        public init(port: UInt7) {
            self.port = port
        }
    }
}

extension MIDIFileEvent.PortPrefix: Equatable { }

extension MIDIFileEvent.PortPrefix: Hashable { }

extension MIDIFileEvent.PortPrefix: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public static func portPrefix(
        port: UInt7
    ) -> Self {
        .portPrefix(
            .init(port: port)
        )
    }
}

extension MIDI1File.Track.Event {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public static func portPrefix(
        delta: DeltaTime = .none,
        port: UInt7
    ) -> Self {
        let event: MIDIFileEvent = .portPrefix(
            port: port
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.PortPrefix {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x21, 0x01] }
}

// MARK: - Encoding

extension MIDIFileEvent.PortPrefix: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .portPrefix }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .portPrefix(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // Step 1: Check required byte count
        let requiredStreamByteCount: Int
        do throws(MIDIFileDecodeError) {
            requiredStreamByteCount = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let readPortNumber: UInt8
        do throws(MIDIFileDecodeError) {
            readPortNumber = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Port Prefix does not start with expected bytes.")
                }
                
                let readPortNumber = try parser.toMIDIFileDecodeError(
                    malformedReason: "Port Prefix port number byte is missing.",
                    try parser.readByte()
                )
                
                return readPortNumber
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        do throws(MIDIFileDecodeError) {
            guard (0x0 ... 0x7F).contains(readPortNumber) else {
                throw .malformed(
                    "Port Prefix port number is out of bounds: \(readPortNumber)"
                )
            }
            
            guard let portNumber = readPortNumber.toUInt7Exactly else {
                throw .malformed(
                    "Port Prefix value(s) are out of bounds."
                )
            }
            
            let newEvent = Self(port: portNumber)
            
            return .event(
                payload: newEvent,
                byteLength: requiredStreamByteCount
            )
        } catch {
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 21 01 pp
        // pp is port number (0...127 assumably)
        
        D(Self.prefixBytes + [port.uInt8Value])
    }
    
    public var midiFileDescription: String {
        "port:\(port)"
    }
    
    public var midiFileDebugDescription: String {
        "PortPrefix(\(port))"
    }
}
