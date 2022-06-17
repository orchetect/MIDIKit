//
//  Manager remove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Remove a managed MIDI endpoint or connection.
    public func remove(_ type: ManagedType,
                       _ tagSelection: TagSelection) {
        
        eventQueue.sync {
            
            switch type {
            case .inputConnection:
                switch tagSelection {
                case .all:
                    managedInputConnections.removeAll()
                case .withTag(let tag):
                    managedInputConnections[tag] = nil
                }
                
            case .outputConnection:
                switch tagSelection {
                case .all:
                    managedOutputConnections.removeAll()
                case .withTag(let tag):
                    managedOutputConnections[tag] = nil
                }
                
            case .input:
                switch tagSelection {
                case .all:
                    managedInputs.removeAll()
                case .withTag(let tag):
                    managedInputs[tag] = nil
                }
                
            case .output:
                switch tagSelection {
                case .all:
                    managedOutputs.removeAll()
                case .withTag(let tag):
                    managedOutputs[tag] = nil
                }
                
            case .nonPersistentThruConnection:
                switch tagSelection {
                case .all:
                    managedThruConnections.removeAll()
                case .withTag(let tag):
                    managedThruConnections[tag] = nil
                }
            }
            
        }
        
    }
    
    /// Remove all managed MIDI endpoints and connections.
    ///
    /// What is unaffected, and not reset:
    /// - Persistent thru connections stored in the system.
    /// - Notification handler attached to the `Manager`.
    /// - `clientName` property
    /// - `model` property
    /// - `manufacturer` property
    public func removeAll() {
        
        // `self.remove(...)` internally uses operationQueue.sync{}
        // so don't need to wrap this with it here
        
        for managedEndpointType in ManagedType.allCases {
            remove(managedEndpointType, .all)
        }
        
    }
    
}
