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
        LazyFilterSequence<LazyMapSequence<Self, MIDIFile<Timebase>.TrackChunk?>>,
        MIDIFile<Timebase>.TrackChunk
    >
    
    /// Lazily returns tracks contained in the sequence.
    public func tracks<Timebase: MIDIFileTimebase>() -> LazyTracksSequence<Timebase>
    where Element == MIDIFile<Timebase>.AnyChunk {
        lazy.compactMap { (anyChunk) -> MIDIFile<Timebase>.TrackChunk? in
            guard case let .track(track) = anyChunk else { return nil }
            return track
        }
    }
}

// MARK: - Collection Methods

extension Collection where Self: RangeReplaceableCollection, Index == Int {
    /// Returns all indices of tracks contained in the sequence.
    public func trackIndices<Timebase: MIDIFileTimebase>() -> IndexSet
    where Element == MIDIFile<Timebase>.AnyChunk {
        let f = indices.filter { self[$0].isTrackChunk }
        return IndexSet(f)
    }
}
