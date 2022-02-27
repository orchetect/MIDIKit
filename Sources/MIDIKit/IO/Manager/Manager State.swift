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
        
        // propagate notification to managed objects
        
        for outputConnection in managedOutputConnections.values {
            outputConnection.notification(notification)
        }
        
        for inputConnection in managedInputConnections.values {
            inputConnection.notification(notification)
        }
        
    }
    
}

