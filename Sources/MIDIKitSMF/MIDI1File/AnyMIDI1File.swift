//
//  AnyMIDI1File.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box to contain a specialized ``MIDI1File``.
public enum AnyMIDI1File {
    /// MIDI file with musical timebase.
    case musical(_ midiFile: MusicalMIDI1File)
    
    /// MIDI file with SMPTE timecode timebase.
    case smpte(_ midiFile: SMPTEMIDI1File)
}

extension AnyMIDI1File: Equatable { }

extension AnyMIDI1File: Hashable { }

extension AnyMIDI1File: Sendable { }

extension AnyMIDI1File: Identifiable {
    public var id: UUID {
        switch self {
        case let .musical(midiFile): midiFile.id
        case let .smpte(midiFile): midiFile.id
        }
    }
}

extension AnyMIDI1File: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .musical(midiFile): midiFile.description
        case let .smpte(midiFile): midiFile.description
        }
    }
    
    /// Generate a description of the track, optionally limiting the number of events from each track in the output.
    public func description(maxEventCount: Int?) -> String {
        switch self {
        case let .musical(midiFile): midiFile.description(maxEventCount: maxEventCount)
        case let .smpte(midiFile): midiFile.description(maxEventCount: maxEventCount)
        }
    }
}

extension AnyMIDI1File: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .musical(midiFile): midiFile.debugDescription
        case let .smpte(midiFile): midiFile.debugDescription
        }
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events from each track in the output.
    public func debugDescription(maxEventCount: Int?) -> String {
        switch self {
        case let .musical(midiFile): midiFile.debugDescription(maxEventCount: maxEventCount)
        case let .smpte(midiFile): midiFile.debugDescription(maxEventCount: maxEventCount)
        }
    }
}

// MARK: - Properties

extension AnyMIDI1File {
    /// MIDI file header chunk.
    public var header: MIDI1File<AnyMIDIFileTimebase>.Header {
        switch self {
        case let .musical(midiFile): midiFile.header.asAnyMIDI1FileHeader()
        case let .smpte(midiFile): midiFile.header.asAnyMIDI1FileHeader()
        }
    }
    
    /// MIDI file format.
    public var format: MIDI1FileFormat {
        switch self {
        case let .musical(midiFile): midiFile.format
        case let .smpte(midiFile): midiFile.format
        }
    }
    
    /// MIDI file timebase (for duration calculations).
    public var timebase: AnyMIDIFileTimebase {
        switch self {
        case let .musical(midiFile): midiFile.timebase.asAnyMIDIFileTimebase()
        case let .smpte(midiFile): midiFile.timebase.asAnyMIDIFileTimebase()
        }
    }
}
