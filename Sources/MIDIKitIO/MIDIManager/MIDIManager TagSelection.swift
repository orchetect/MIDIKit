//
//  MIDIManager TagSelection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDIManager {
    /// Tag selection for managed input/connection operations.
    public enum TagSelection {
        case all
        case withTag(String)
    }
}

extension MIDIManager.TagSelection: Equatable { }

extension MIDIManager.TagSelection: Hashable { }

extension MIDIManager.TagSelection: Sendable { }

#endif
