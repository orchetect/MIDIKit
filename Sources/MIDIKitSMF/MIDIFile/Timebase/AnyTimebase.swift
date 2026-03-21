//
//  AnyTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    /// Type-erased box for a specialized MIDI file timebase.
    public enum AnyTimebase {
        case musical(_ timebase: MIDIFile.MusicalTimebase)
        case smpte(_ timebase: MIDIFile.SMPTETimebase)
    }
}

extension MIDIFile.AnyTimebase: Equatable { }

extension MIDIFile.AnyTimebase: Hashable { }

extension MIDIFile.AnyTimebase: Identifiable {
    public var id: Self { self }
}

extension MIDIFile.AnyTimebase: Sendable { }

extension MIDIFile.AnyTimebase: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .musical(timebase): timebase.description
        case let .smpte(timebase): timebase.description
        }
    }
}

extension MIDIFile.AnyTimebase: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .musical(timebase): timebase.debugDescription
        case let .smpte(timebase): timebase.debugDescription
        }
    }
}

// MARK: - Properties

extension MIDIFile.AnyTimebase {
    /// Unwraps the enum case and returns the chunk contained within, typed as ``MIDIFile/Chunk`` protocol.
    public var unwrapped: any MIDIFile.Timebase {
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

extension MIDIFile.AnyTimebase {
    /// Returns a default musical timebase best for most use cases.
    public static func `default`() -> Self {
        .musical(.default())
    }
}

// MARK: - Timebase

extension MIDIFile.AnyTimebase: MIDIFile.Timebase {
    // MARK: - Decoding
    
    /// Initialize from raw data.
    public init?(data: some DataProtocol) {
        guard data.count == 2 else {
            return nil
        }

        if let timebase = MIDIFile.MusicalTimebase(data: data) {
            self = .musical(timebase)
        } else if let timebase = MIDIFile.SMPTETimebase(data: data) {
            self = .smpte(timebase)
        } else {
            return nil
        }
    }
    
    // MARK: - Encoding
    
    public func rawData() -> Data {
        unwrapped.rawData()
    }

    public func rawData<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        unwrapped.rawData(as: dataType)
    }
}
