//
//  AnyChunk+Collection+Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

extension Array {
    /// Updates tracks in-place with new tracks. If the number of tracks differ, outstanding tracks will be
    /// appended or removed as necessary.
    mutating func updateTracks<Timebase: MIDIFileTimebase>(
        with newTracks: [MIDIFile<Timebase>.TrackChunk]
    ) where Element == MIDIFile<Timebase>.AnyChunk {
        let oldTracksIndices = trackIndices()
        let newTracksIndices = newTracks.indices
        
        // determine list of operations
        var operations: [UpdateTrackOperation] = []
        for (oldIndex, newIndex) in optionalZip(oldTracksIndices, newTracksIndices) {
            if let oldIndex {
                if let newIndex {
                    operations.append(.replace(oldIndex: oldIndex, withNewTracksIndex: newIndex))
                } else {
                    operations.append(.remove(oldIndex: oldIndex))
                }
            } else if let newIndex {
                // (we know oldIndex == nil here)
                operations.append(.append(fromNewTracksIndex: newIndex))
            } else {
                // both are nil, which should never happen, but ignore anyways
            }
        }
        
        // sort operations
        operations = operations.sortedForExecution()
        
        // commit operations
        for operation in operations {
            switch operation {
            case let .replace(oldIndex: oldIndex, withNewTracksIndex: newIndex):
                self[oldIndex] = .track(newTracks[newIndex])
            case let .append(fromNewTracksIndex: newIndex):
                self.append(.track(newTracks[newIndex]))
            case let .remove(oldIndex: oldIndex):
                self.remove(at: oldIndex)
            }
        }
    }
}

private enum UpdateTrackOperation {
    case replace(oldIndex: Int, withNewTracksIndex: Int)
    case append(fromNewTracksIndex: Int)
    case remove(oldIndex: Int)
    
    var isReplace: Bool { guard case .replace = self else { return false }; return true }
    var isAppend: Bool { guard case .append = self else { return false }; return true }
    var isRemove: Bool { guard case .remove = self else { return false }; return true }
    
    var sortValue: Int {
        switch self {
        case .replace: 0
        case .append: 2
        case .remove: 1
        }
    }
}

extension Collection<UpdateTrackOperation> {
    func sortedForExecution() -> [Element] {
        sorted { lhs, rhs in
            if case let .remove(lhsIndex) = lhs, case let .remove(rhsIndex) = rhs {
                // ensure indexes are removed from largest to smallest
                lhsIndex > rhsIndex
            } else {
                lhs.sortValue < rhs.sortValue
            }
        }
    }
}
