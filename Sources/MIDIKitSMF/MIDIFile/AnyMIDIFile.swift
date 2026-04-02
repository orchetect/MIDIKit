//
//  AnyMIDIFile.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Type-erased box to contain a specialized ``MIDIFile``.
public enum AnyMIDIFile {
    /// MIDI file with musical timebase.
    case musical(_ midiFile: MusicalMIDIFile)
    
    /// MIDI file with SMPTE timecode timebase.
    case smpte(_ midiFile: SMPTEMIDIFile)
}

extension AnyMIDIFile: Equatable { }

extension AnyMIDIFile: Hashable { }

extension AnyMIDIFile: Sendable { }

extension AnyMIDIFile: Identifiable {
    public var id: UUID {
        switch self {
        case let .musical(midiFile): midiFile.id
        case let .smpte(midiFile): midiFile.id
        }
    }
}

extension AnyMIDIFile: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .musical(midiFile): midiFile.description
        case let .smpte(midiFile): midiFile.description
        }
    }
    
    /// Generate a description of the track, optionally limiting the number of events from each track in the output.
    public func description(maxTrackEventCount: Int?) -> String {
        switch self {
        case let .musical(midiFile): midiFile.description(maxTrackEventCount: maxTrackEventCount)
        case let .smpte(midiFile): midiFile.description(maxTrackEventCount: maxTrackEventCount)
        }
    }
}

extension AnyMIDIFile: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .musical(midiFile): midiFile.debugDescription
        case let .smpte(midiFile): midiFile.debugDescription
        }
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events from each track in the output.
    public func debugDescription(maxTrackEventCount: Int?) -> String {
        switch self {
        case let .musical(midiFile): midiFile.debugDescription(maxTrackEventCount: maxTrackEventCount)
        case let .smpte(midiFile): midiFile.debugDescription(maxTrackEventCount: maxTrackEventCount)
        }
    }
}

// MARK: - Properties

extension AnyMIDIFile {
    /// MIDI file header chunk.
    public var header: AnyMIDIFileHeaderChunk {
        switch self {
        case let .musical(midiFile): midiFile.header.asAnyMIDIFileHeaderChunk()
        case let .smpte(midiFile): midiFile.header.asAnyMIDIFileHeaderChunk()
        }
    }
    
    /// MIDI file format.
    public var format: MIDIFileFormat {
        switch self {
        case let .musical(midiFile): midiFile.format
        case let .smpte(midiFile): midiFile.format
        }
    }
    
    /// MIDI file timebase (for duration calculations).
    public var timebase: AnyMIDIFileTimebase {
        switch self {
        case let .musical(midiFile): midiFile.timebase.asAnyMIDIFileTimebase
        case let .smpte(midiFile): midiFile.timebase.asAnyMIDIFileTimebase
        }
    }
}
