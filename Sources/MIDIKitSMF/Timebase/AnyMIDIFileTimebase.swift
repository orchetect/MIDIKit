//
//  AnyMIDIFileTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Type-erased box containing a specialized MIDI file timebase.
public enum AnyMIDIFileTimebase {
    /// Musical timebase.
    case musical(_ timebase: MusicalMIDIFileTimebase)
    
    /// SMPTE timecode timebase.
    case smpte(_ timebase: SMPTEMIDIFileTimebase)
}

extension AnyMIDIFileTimebase: Equatable { }

extension AnyMIDIFileTimebase: Hashable { }

extension AnyMIDIFileTimebase: Identifiable {
    public var id: Self { self }
}

extension AnyMIDIFileTimebase: Sendable { }

extension AnyMIDIFileTimebase: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .musical(timebase): timebase.description
        case let .smpte(timebase): timebase.description
        }
    }
}

extension AnyMIDIFileTimebase: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .musical(timebase): timebase.debugDescription
        case let .smpte(timebase): timebase.debugDescription
        }
    }
}

// MARK: - Properties

extension AnyMIDIFileTimebase {
    /// Unwraps the enum case and returns the timebase contained within, typed as `any` ``MIDIFileTimebase``.
    public var wrapped: any MIDIFileTimebase {
        switch self {
        case let .musical(timebase): timebase
        case let .smpte(timebase): timebase
        }
    }
    
    /// Returns `true` if the timebase is a musical-based.
    public var isMusical: Bool {
        switch self {
        case .musical: true
        default: false
        }
    }
    
    /// Returns `true` if the timebase is a SMPTE timecode-based.
    public var isSMPTE: Bool {
        switch self {
        case .smpte: true
        default: false
        }
    }
}

// MARK: - Static Constructors

extension AnyMIDIFileTimebase {
    /// Returns a default musical timebase best for most use cases.
    public static func `default`() -> Self {
        .musical(.default())
    }
}

// MARK: - Timebase

extension AnyMIDIFileTimebase: MIDIFileTimebase {
    public typealias DeltaTime = AnyMIDIFileTrackDeltaTime
    
    // MARK: - Decoding
    
    /// Initialize from raw data.
    public init?(midi1FileRawBytes: some DataProtocol) {
        guard midi1FileRawBytes.count == 2 else {
            return nil
        }
        
        let byte1 = midi1FileRawBytes[atOffset: 0]
        
        switch (byte1 & 0b10000000) >> 7 {
        case 0b0: // musical
            guard let timebase = MusicalMIDIFileTimebase(midi1FileRawBytes: midi1FileRawBytes) else { return nil }
            self = .musical(timebase)
            return
            
        case 0b1: // timecode
            guard let timebase = SMPTEMIDIFileTimebase(midi1FileRawBytes: midi1FileRawBytes) else { return nil }
            self = .smpte(timebase)
            return
            
        default:
            return nil
        }
    }
    
    // MARK: - Encoding
    
    public func midi1FileRawBytes() -> Data {
        wrapped.midi1FileRawBytes()
    }

    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        wrapped.midi1FileRawBytes(as: dataType)
    }
    
    // MARK: - AnyMIDIFileTimebase
    
    public func asAnyMIDIFileTimebase() -> AnyMIDIFileTimebase {
        self
    }
}
