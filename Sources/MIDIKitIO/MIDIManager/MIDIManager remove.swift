//
//  MIDIManager remove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=6.0)
internal import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

extension MIDIManager {
    /// Remove a managed MIDI endpoint or connection.
    public func remove(
        _ type: ManagedType,
        _ tagSelection: TagSelection
    ) {
        eventQueue.sync {
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
        // `self.remove(...)` internally uses operationQueue.sync{}
        // so don't need to wrap this with it here
    
        for managedEndpointType in ManagedType.allCases {
            remove(managedEndpointType, .all)
        }
    }
}

#endif
