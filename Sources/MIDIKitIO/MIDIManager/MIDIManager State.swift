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
        
        func block() throws -> MIDIClientRef {
            var newCoreMIDIClientRef = MIDIClientRef()
            try MIDIClientCreateWithBlock(clientName as CFString, &newCoreMIDIClientRef) { [weak self] notificationPtr in
                guard let self else { return }
                let internalNotif = MIDIIOInternalNotification(notificationPtr)
                internalNotificationHandler(internalNotif)
            }
            .throwIfOSStatusErr()
            return newCoreMIDIClientRef
        }
        // `MIDIClientCreateWithBlock` must be called on the main thread,
        // otherwise the notification block will never happen.
        let newCoreMIDIClientRef: MIDIClientRef
        if Thread.current.isMainThread {
            newCoreMIDIClientRef = try block()
        } else {
            newCoreMIDIClientRef = try DispatchQueue.main.sync { try block() }
        }
        assert(newCoreMIDIClientRef != MIDIClientRef())
        self.coreMIDIClientRef = newCoreMIDIClientRef
        
        // initial cache of endpoints
        updateDevicesAndEndpoints()
    }
    
    private func internalNotificationHandler(_ internalNotif: MIDIIOInternalNotification) {
        switch internalNotif {
        case .setupChanged, .added, .removed, .propertyChanged:
            self.updateDevicesAndEndpoints()
        default:
            break
        }
        
        // if needed, fall back on notification cache in case we get more than
        // one `.removed` notification in a row. this way we have metadata on hand.
        let notification = MIDIIONotification(internalNotif, cache: midiObjectCache)
        
        // propagate notification to managed objects
        for outputConnection in self.managedOutputConnections.values {
            outputConnection.notification(internalNotif)
        }
        for inputConnection in self.managedInputConnections.values {
            inputConnection.notification(internalNotif)
        }
        for thruConnection in self.managedThruConnections.values {
            thruConnection.notification(internalNotif)
        }
        
        // send notification to handler after internal cache is updated
        if let notification {
            sendNotificationAsync(notification)
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
