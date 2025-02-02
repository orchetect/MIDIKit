//
//  MIDIThruConnection Lifecycle.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDIThruConnection {
    /// ThruConnection lifecycle type.
    public enum Lifecycle {
        /// The play-through connection exists as long as the ``MIDIManager`` exists.
        case nonPersistent
    
        /// The play-through connection is stored in the system and persists indefinitely (even
        /// after system reboots) until explicitly removed.
        ///
        /// - parameter ownerID: Reverse-DNS domain string; usually the application's bundle ID.
        case persistent(ownerID: String)
    }
}

extension MIDIThruConnection.Lifecycle: Equatable { }

extension MIDIThruConnection.Lifecycle: Hashable { }

extension MIDIThruConnection.Lifecycle: Sendable { }

extension MIDIThruConnection.Lifecycle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nonPersistent:
            "nonPersistent"
    
        case let .persistent(ownerID):
            "persistent(\(ownerID)"
        }
    }
}

extension MIDIThruConnection.Lifecycle {
    /// Returns true if the instance is case ``nonPersistent``.
    public var isPersistent: Bool {
        switch self {
        case .nonPersistent:
            false
        case .persistent:
            true
        }
    }
}

#endif
