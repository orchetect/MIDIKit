//
//  MIDIManager ManagedType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension MIDIManager {
    /// Managed port or connection type.
    public enum ManagedType: CaseIterable, Hashable {
        case inputConnection
        case outputConnection
        case input
        case output
        case nonPersistentThruConnection
    }
    
    /// Tag selection for managed input/connection operations.
    public enum TagSelection: Hashable {
        case all
        case withTag(String)
    }
}

#endif
