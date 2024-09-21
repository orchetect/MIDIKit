//
//  Event PortPrefix.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - MIDIPortPrefix

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public struct PortPrefix: Equatable, Hashable {
        /// Port number (`0 ... 127`)
        public var port: UInt7 = 0
        
        // MARK: - Init
        
        public init(port: UInt7) {
            self.port = port
        }
    }
}

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public static func portPrefix(
        delta: DeltaTime = .none,
        port: UInt7
    ) -> Self {
        .portPrefix(
            delta: delta,
            event: .init(port: port)
        )
    }
}

// MARK: - Encoding

extension MIDIFileEvent.PortPrefix: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .portPrefix
    
    public init(midi1SMFRawBytes rawBytes: some DataProtocol) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        try rawBytes.withDataReader { dataReader in
            // 3-byte preamble
            guard try dataReader.read(bytes: 3).elementsEqual(
                MIDIFile.kEventHeaders[Self.smfEventType]!
            ) else {
                throw MIDIFile.DecodeError.malformed(
                    "Event does not start with expected bytes."
                )
            }
        
            let readPortNumber = try dataReader.readByte()
        
            guard (0x0 ... 0x7F).contains(readPortNumber) else {
                throw MIDIFile.DecodeError.malformed(
                    "Port number is out of bounds: \(readPortNumber)"
                )
            }
        
            guard let portNumber = readPortNumber.toUInt7Exactly else {
                throw MIDIFile.DecodeError.malformed(
                    "Value(s) out of bounds."
                )
            }
        
            port = portNumber
        }
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>() -> D {
        // FF 21 01 pp
        // pp is port number (0...127 assumably)
        
        D(MIDIFile.kEventHeaders[.portPrefix]! + [port.uInt8Value])
    }
    
    static let midi1SMFFixedRawBytesLength = 4
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol
    ) throws -> StreamDecodeResult {
        let requiredData = stream.prefix(midi1SMFFixedRawBytesLength)
        
        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Unexpected byte length."
            )
        }
        
        let newInstance = try Self(midi1SMFRawBytes: requiredData)
        
        return (
            newEvent: newInstance,
            bufferLength: midi1SMFFixedRawBytesLength
        )
    }
    
    public var smfDescription: String {
        "port:\(port)"
    }
    
    public var smfDebugDescription: String {
        "PortPrefix(\(port))"
    }
}
