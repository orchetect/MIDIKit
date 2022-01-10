//
//  Manager State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Starts the manager and registers itself with the Core MIDI subsystem.
    /// Call this method once after initializing a new instance.
    /// Subsequent calls will not have any effect.
    ///
    /// - Throws: `MIDI.IO.MIDIError.osStatus`
    public func start() throws {
        
        try eventQueue.sync {
            
            // if start() was already called, return
            guard coreMIDIClientRef == MIDIClientRef() else { return }
            
            try MIDIClientCreateWithBlock(clientName as CFString, &coreMIDIClientRef)
            { [weak self] notificationPtr in
                guard let strongSelf = self else { return }
                strongSelf.internalNotificationHandler(notificationPtr)
            }
            .throwIfOSStatusErr()
            
            // initial cache of endpoints
            
            updateObjectsCache()
            
        }
        
    }
    
    internal func internalNotificationHandler(_ pointer: UnsafePointer<MIDINotification>) {
        
        let notification = InternalNotification(pointer)
        
        switch notification {
        case .setupChanged,
             .added,
             .removed,
             .propertyChanged:
            
            updateObjectsCache()
            
        default:
            break
        }
        
        switch notification {
        case .setupChanged, .added, .removed:
            
            // refresh internal states of all outputs and inputs
            // and reconnect any disconnected connections if an endpoint has reappeared
            
            for outputConnection in managedOutputConnections.values {
                _ = try? outputConnection.refreshConnection(in: self)
            }
            
            for inputConnection in managedInputConnections.values {
                _ = try? inputConnection.refreshConnection(in: self)
            }
            
        // thru connections
        
        default:
            break
        }
        
    }
    
}

