//
//  MIDIManager State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore

#if compiler(>=6.0)
internal import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

extension MIDIManager {
    /// Starts the manager and registers itself with the Core MIDI subsystem.
    /// Call this method once after initializing a new instance.
    /// Subsequent calls will not have any effect.
    ///
    /// - Throws: `MIDIIOError.osStatus`
    public func start() throws {
        // if start() was already called, return
        guard coreMIDIClientRef == MIDIClientRef() else { return }
        
        try MIDIClientCreateWithBlock(clientName as CFString, &coreMIDIClientRef) { [weak self] notificationPtr in
            guard let self else { return }
            let internalNotif = MIDIIOInternalNotification(notificationPtr)
            self.internalNotificationHandler(internalNotif)
        }
        .throwIfOSStatusErr()
        
        // initial cache of endpoints
        
        updateObjectsCache()
    }
    
    private func internalNotificationHandler(_ internalNotif: MIDIIOInternalNotification) {
        let cache = MIDIIOObjectCache(from: self)
        
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
                notificationCache = cache
                return MIDIIONotification(internalNotif, cache: cache)
            }
        }()
        
        // send notification to handler after internal cache is updated
        if let notification {
            sendNotificationAsync(notification)
        }
        
        // propagate notification to managed objects
        
        for outputConnection in managedOutputConnections.values {
            outputConnection.notification(internalNotif)
        }
        
        for inputConnection in managedInputConnections.values {
            inputConnection.notification(internalNotif)
        }
        
        for thruConnection in managedThruConnections.values {
            thruConnection.notification(internalNotif)
        }
    }
    
    private func sendNotificationAsync(_ notif: MIDIIONotification) {
        guard let notificationHandler else { return }
        DispatchQueue.main.async {
            notificationHandler(notif, self)
        }
    }
}

#endif
