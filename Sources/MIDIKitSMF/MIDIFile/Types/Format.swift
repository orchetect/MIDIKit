//
//  Format.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - Format

extension MIDIFile {
    public enum Format: UInt8 {
        /// Type 0:
        /// MIDI file contains one single track containing midi data on possibly all 16 midi
        /// channels.
        case singleTrack = 0

        /// Type 1:
        /// MIDI file contains one or more simultaneous (ie, all start from an assumed time of 0)
        /// tracks, perhaps each on a single midi channel. Together, all of these tracks are
        /// considered one sequence or pattern.
        case multipleTracksSynchronous = 1

        /// Type 2:
        /// MIDI file contains one or more sequentially independent single-track patterns.
        case multipleTracksAsynchronous = 2
    }
}

extension MIDIFile.Format: Equatable { }

extension MIDIFile.Format: Hashable { }

extension MIDIFile.Format: CaseIterable { }

extension MIDIFile.Format: Identifiable {
    public var id: Self { self }
}

extension MIDIFile.Format: Sendable { }

extension MIDIFile.Format: CustomStringConvertible {
    public var description: String {
        switch self {
        case .singleTrack:
            "Type 0 (single track)"
            
        case .multipleTracksSynchronous:
            "Type 1 (multiple tracks synchronous)"
            
        case .multipleTracksAsynchronous:
            "Type 2 (multiple tracks asynchronous)"
        }
    }
}

extension MIDIFile.Format: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Format(" + description + ")"
    }
}
