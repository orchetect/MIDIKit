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
//   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
//   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileTrackEvent {
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

extension MIDIFileTrackEvent.PortPrefix: Equatable { }

extension MIDIFileTrackEvent.PortPrefix: Hashable { }

extension MIDIFileTrackEvent.PortPrefix: Sendable { }

// MARK: - Static Constructors

extension MIDIFileTrackEvent {
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

extension MIDIFile.TrackChunk.Event {
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    public static func portPrefix(
        delta: DeltaTime = .none,
        port: UInt7
    ) -> Self {
        let event: MIDIFileTrackEvent = .portPrefix(
            port: port
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileTrackEvent.PortPrefix {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x21, 0x01] }
}

// MARK: - Encoding

extension MIDIFileTrackEvent.PortPrefix: MIDIFileTrackEventPayload {
    public static var smfEventType: MIDIFileTrackEventType { .portPrefix }
    
    public var wrapped: MIDIFileTrackEvent {
        .portPrefix(self)
    }
    
    public init(
        midi1SMFRawBytes rawBytes: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) {
        if let runningStatus {
            let rsString = runningStatus.hexString(prefix: true)
            throw .malformed("Running status byte \(rsString) was passed to event parser that does not use running status.")
        }
        
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw .malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        try rawBytes.withDataParser { parser throws(MIDIFileDecodeError) in
            // 3-byte preamble
            guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                  headerBytes.elementsEqual(Self.prefixBytes)
            else {
                throw .malformed("Event does not start with expected bytes.")
            }
            
            let readPortNumber = try parser.toMIDIFileDecodeError(
                malformedReason: "Port number byte is missing.",
                try parser.readByte()
            )
            guard (0x0 ... 0x7F).contains(readPortNumber) else {
                throw .malformed(
                    "Port number is out of bounds: \(readPortNumber)"
                )
            }
            
            guard let portNumber = readPortNumber.toUInt7Exactly else {
                throw .malformed(
                    "Value(s) out of bounds."
                )
            }
            
            port = portNumber
        }
    }
    
    public static func initFrom(
        midi1SMFRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) throws(MIDIFileDecodeError) -> StreamDecodeResult {
        let rawBytes = stream.prefix(midi1SMFFixedRawBytesLength)
        
        let newInstance = try Self(midi1SMFRawBytes: rawBytes, runningStatus: runningStatus)
        
        return (
            newEvent: newInstance,
            bufferLength: rawBytes.count
        )
    }
    
    public func midi1SMFRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 21 01 pp
        // pp is port number (0...127 assumably)
        
        D(Self.prefixBytes + [port.uInt8Value])
    }
    
    static var midi1SMFFixedRawBytesLength: Int { 4 }
    
    public var smfDescription: String {
        "port:\(port)"
    }
    
    public var smfDebugDescription: String {
        "PortPrefix(\(port))"
    }
}
