//
//  Timebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MIDIFile {
    /// MIDI file timebase as described in the MIDI file header.
    ///
    /// At this time, the Standard MIDI File 1.0 spec defines only two timebase types: musical and SMPTE/timecode.
    ///
    /// All MIDI file tracks use ticks as timing resolution - the smallest, most finite unit of time duration possible.
    /// The timebase determines how those ticks are used to calculate real wall-time duration.
    public protocol Timebase: Equatable, Hashable, Sendable {
        /// Returns the timebase encoded as raw data.
        func rawData() -> Data
        
        /// Returns the timebase encoded as raw data.
        func rawData<D: MutableDataProtocol>(as dataType: D.Type) -> D
        
        /// Initialize from raw data.
        init?(data: some DataProtocol)
    }
}

// MARK: - Static Constructors

extension MIDIFile.Timebase where Self == MIDIFile.MusicalTimebase {
    /// Returns a default musical timebase best for most use cases.
    public static func `default`() -> MIDIFile.MusicalTimebase {
        MIDIFile.MusicalTimebase(ticksPerQuarterNote: 960)
    }
}
