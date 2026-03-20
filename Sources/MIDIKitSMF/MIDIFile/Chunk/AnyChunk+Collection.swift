//
//  AnyChunk+Collection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Sequence Methods

extension Sequence<MIDIFile.AnyChunk> {
    /// Lazily returns tracks contained in the sequence.
    public var tracks: LazyMapSequence<LazyFilterSequence<LazyMapSequence<LazySequence<Self>.Elements, MIDIFile.TrackChunk?>>, MIDIFile.TrackChunk> {
        lazy.compactMap { (anyChunk) -> MIDIFile.TrackChunk? in
            guard case let .track(track) = anyChunk else { return nil }
            return track
        }
    }
}

// MARK: - Collection Methods

extension Collection<MIDIFile.AnyChunk> where Self: RangeReplaceableCollection, Index == Int {
    /// Returns all indices of tracks contained in the sequence.
    public var trackIndices: IndexSet {
        let f = indices.filter { self[$0].isTrackChunk }
        return IndexSet(f)
    }
}
