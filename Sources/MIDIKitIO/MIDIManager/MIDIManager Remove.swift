//
//  MIDIManager Remove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

extension MIDIManager {
    /// Remove a managed MIDI endpoint or connection.
    public func remove(
        _ type: ManagedType,
        _ tagSelection: TagSelection
    ) {
        managementQueue.sync {
            switch type {
            case .inputConnection:
                switch tagSelection {
                case .all:
                    managedInputConnections.removeAll()
                case let .withTag(tag):
                    managedInputConnections[tag] = nil
                }
                
            case .outputConnection:
                switch tagSelection {
                case .all:
                    managedOutputConnections.removeAll()
                case let .withTag(tag):
                    managedOutputConnections[tag] = nil
                }
                
            case .input:
                switch tagSelection {
                case .all:
                    managedInputs.removeAll()
                case let .withTag(tag):
                    managedInputs[tag] = nil
                }
                
            case .output:
                switch tagSelection {
                case .all:
                    managedOutputs.removeAll()
                case let .withTag(tag):
                    managedOutputs[tag] = nil
                }
                
            case .nonPersistentThruConnection:
                switch tagSelection {
                case .all:
                    managedThruConnections.removeAll()
                case let .withTag(tag):
                    managedThruConnections[tag] = nil
                }
            }
        }
    }
    
    /// Removes all unmanaged persistent MIDI thru connections stored in the system matching the
    /// given owner ID.
    ///
    /// - Parameter ownerID: Reverse-DNS domain that was used when the connection was first made
    ///
    /// - Returns: Number of deleted matching connections.
    @discardableResult
    public func removeAllUnmanagedPersistentThruConnections(ownerID: String) -> Int {
        (try? removeAllSystemThruConnectionsPersistentEntries(matching: ownerID)) ?? 0
    }
    
    /// Remove all managed MIDI endpoints and connections.
    ///
    /// What is unaffected, and not reset:
    /// - Persistent thru connections stored in the system.
    /// - Notification handler attached to the ``MIDIManager``.
    /// - ``clientName`` property
    /// - ``model`` property
    /// - ``manufacturer`` property
    public func removeAll() {
        for managedEndpointType in ManagedType.allCases {
            remove(managedEndpointType, .all)
        }
    }
}

#endif
