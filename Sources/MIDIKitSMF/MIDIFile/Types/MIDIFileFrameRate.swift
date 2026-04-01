//
//  MIDIFileFrameRate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// SMPTE frame rate. Used in MIDI file header for SMPTE timebase, and in SMPTE offset track events.
public enum MIDIFileFrameRate {
    case fps24
    case fps25
    case fps29_97d
    case fps30
}

extension MIDIFileFrameRate: Equatable { }

extension MIDIFileFrameRate: Hashable { }

extension MIDIFileFrameRate: CaseIterable { }

extension MIDIFileFrameRate: Identifiable {
    public var id: Self { self }
}

extension MIDIFileFrameRate: Sendable { }

extension MIDIFileFrameRate: CustomStringConvertible {
    public var description: String {
        switch self {
        case .fps24: "24fps"
        case .fps25: "25fps"
        case .fps29_97d: "29.97dfps"
        case .fps30: "30fps"
        }
    }
}

extension MIDIFileFrameRate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "FrameRate(" + description + ")"
    }
}

// MARK: - MIDI File SMPTE Timebase Header Byte

extension MIDIFileFrameRate {
    /// Initialize from the frame rate encoded in a MIDI file SMPTE timebase header.
    public init?(midi1SMFRawHeaderByte byte: UInt8) {
        guard let match = Self.allCases.first(where: { byte == $0.midi1SMFRawFileHeaderByte })
        else { return nil }
        self = match
    }
    
    /// Returns the frame rate encoded for a MIDI file SMPTE timebase header.
    ///
    /// MIDI file header time division 2-byte value:
    /// Bits 8 - 15 (i.e. the first byte) specifies the number of frames per second (fps), and will
    /// be one of the four SMPTE standards - 24, 25, 29d or 30, though expressed as a negative value
    /// (using 2's complement notation), as follows:
    ///
    /// - 24 fps: `0xE8`
    /// - 25 fps: `0xE7`
    /// - 29.97 drop fps: `0xE3`
    /// - 30 fps: `0xE2`
    public var midi1SMFRawFileHeaderByte: UInt8 {
        switch self {
        case .fps24:     0b1101000 // 0xE8 when adding top bit of 1
        case .fps25:     0b1100111 // 0xE7 when adding top bit of 1
        case .fps29_97d: 0b1100011 // 0xE3 when adding top bit of 1
        case .fps30:     0b1100010 // 0xE2 when adding top bit of 1
        }
    }
}

// MARK: - Track SMPTE Offset Event

extension MIDIFileFrameRate {
    /// Initialize from the frame rate encoded in a MIDI file SMPTE offset track event.
    public init?(midi1SMFRawTrackOffsetByte byte: UInt8) {
        guard let match = Self.allCases.first(where: { byte == $0.midi1SMFRawTrackOffsetEventByte })
        else { return nil }
        self = match
    }
    
    /// Returns the frame rate encoded for a MIDI file SMPTE offset track event.
    public var midi1SMFRawTrackOffsetEventByte: UInt8 {
        switch self {
        case .fps24:     0b00 // 0 decimal
        case .fps25:     0b01 // 1 decimal
        case .fps29_97d: 0b10 // 2 decimal
        case .fps30:     0b11 // 3 decimal
        }
    }
}
