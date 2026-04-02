//
//  AnyChunk+Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Sequence Methods

extension Sequence {
    public typealias LazyTracksSequence<Timebase: MIDIFileTimebase> = LazyMapSequence<
        LazyFilterSequence<LazyMapSequence<Self, MIDI1File<Timebase>.TrackChunk?>>,
        MIDI1File<Timebase>.TrackChunk
    >
    
    /// Lazily returns tracks contained in the sequence.
    public func tracks<Timebase: MIDIFileTimebase>() -> LazyTracksSequence<Timebase>
    where Element == MIDI1File<Timebase>.AnyChunk {
        lazy.compactMap { (anyChunk) -> MIDI1File<Timebase>.TrackChunk? in
            guard case let .track(track) = anyChunk else { return nil }
            return track
        }
    }
}

// MARK: - Collection Methods

extension Collection where Self: RangeReplaceableCollection, Index == Int {
    /// Returns all indices of tracks contained in the sequence.
    public func trackIndices<Timebase: MIDIFileTimebase>() -> IndexSet
    where Element == MIDI1File<Timebase>.AnyChunk {
        let f = indices.filter { self[$0].isTrackChunk }
        return IndexSet(f)
    }
}
