//
//  MIDIManager ManagedType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

extension MIDIManager {
    /// Managed port or connection type.
    public enum ManagedType: CaseIterable, Hashable, Sendable {
        case inputConnection
        case outputConnection
        case input
        case output
        case nonPersistentThruConnection
    }
    
    /// Tag selection for managed input/connection operations.
    public enum TagSelection: Hashable, Sendable {
        case all
        case withTag(String)
    }
}

#endif
