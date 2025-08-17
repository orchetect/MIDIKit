//
//  MIDIManager State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore
internal import CoreMIDI

extension MIDIManager {
    /// Starts the manager and registers itself with the Core MIDI subsystem.
    /// Call this method once after initializing a new instance.
    /// Subsequent calls will not have any effect.
    ///
    /// - Throws: `MIDIIOError.osStatus`
    public func start() throws {
        // if start() was already called, return
        guard coreMIDIClientRef == MIDIClientRef() else { return }
        
        try managementQueue.sync {
            var newCoreMIDIClientRef = MIDIClientRef()
            
            let block = { [self] in
                try MIDIClientCreateWithBlock(clientName as CFString, &newCoreMIDIClientRef) { [weak self] notificationPtr in
                    guard let self else { return }
                    let internalNotif = MIDIIOInternalNotification(notificationPtr)
                    internalNotificationHandler(internalNotif)
                }
                .throwIfOSStatusErr()
            }
            // even though we're on managementQueue, check for main as a safety measure any way before running sync on main
            if Thread.current.isMainThread {
                try block()
            } else {
                try DispatchQueue.main.sync {
                    try block()
                }
            }
            assert(newCoreMIDIClientRef != MIDIClientRef())
            self.coreMIDIClientRef = newCoreMIDIClientRef
        }
        
        // initial cache of endpoints
        updateObjectsCache()
    }
    
    private func internalNotificationHandler(_ internalNotif: MIDIIOInternalNotification) {
        switch internalNotif {
        case .setupChanged, .added, .removed, .propertyChanged:
            updateObjectsCache()
        default:
            break
        }
        
        let notification: MIDIIONotification? = {
            switch internalNotif {
            case .removed:
                // fall back on notificationCache in case we get more than
                // one .removed notification in a row so we have metadata on hand
                return MIDIIONotification(internalNotif, cache: notificationCache)
            default:
                let cache = MIDIIOObjectCache(from: self)
                notificationCache = cache
                return MIDIIONotification(internalNotif, cache: cache)
            }
        }()
        
        // send notification to handler after internal cache is updated
        if let notification {
            sendNotificationAsync(notification)
        }
        
        // propagate notification to managed objects
        
        managementQueue.async {
            for outputConnection in self.managedOutputConnections.values {
                outputConnection.notification(internalNotif)
            }
            
            for inputConnection in self.managedInputConnections.values {
                inputConnection.notification(internalNotif)
            }
            
            for thruConnection in self.managedThruConnections.values {
                thruConnection.notification(internalNotif)
            }
        }
    }
    
    private func sendNotificationAsync(_ notif: MIDIIONotification) {
        guard let notificationHandler else { return }
        DispatchQueue.main.async {
            notificationHandler(notif)
        }
    }
}

#endif
