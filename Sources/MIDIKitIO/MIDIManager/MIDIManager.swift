//
//  MIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

/// Central MIDI Port and Connection Manager and MIDI system data provider.
///
/// One ``MIDIManager`` instance stored in a global lifecycle context can manage multiple MIDI ports
/// and connections, and is usually sufficient for all of an application's MIDI needs.
public final class MIDIManager: NSObject {
    // MARK: - Properties
    
    /// MIDI Client Name.
    public internal(set) var clientName: String
    
    /// Core MIDI Client Reference.
    public internal(set) var coreMIDIClientRef = CoreMIDIClientRef()
    
    /// MIDI Model: The name of your software, which will be visible to the end-user in ports
    /// created by the manager.
    public internal(set) var model: String = ""
    
    /// MIDI Manufacturer: The name of your company, which may be visible to the end-user in ports
    /// created by the manager.
    public internal(set) var manufacturer: String = ""
    
    /// Preferred underlying Core MIDI API to use as default when creating new managed endpoints.
    /// This value defaults to the best API for the current platform.
    ///
    /// The preferred API will be used where possible, unless operating system requirements force
    /// the use of a specific.
    public var preferredAPI: CoreMIDIAPIVersion {
        didSet {
            // prevent setting of an invalid API
            if !preferredAPI.isValidOnCurrentPlatform {
                preferredAPI = .bestForPlatform()
            }
        }
    }
    
    /// Dictionary of MIDI input connections managed by this instance.
    public internal(set) var managedInputConnections: [String: MIDIInputConnection] = [:]
    
    /// Dictionary of MIDI output connections managed by this instance.
    public internal(set) var managedOutputConnections: [String: MIDIOutputConnection] = [:]
    
    /// Dictionary of virtual MIDI inputs managed by this instance.
    public internal(set) var managedInputs: [String: MIDIInput] = [:]
    
    /// Dictionary of virtual MIDI outputs managed by this instance.
    public internal(set) var managedOutputs: [String: MIDIOutput] = [:]
    
    /// Dictionary of non-persistent MIDI thru connections managed by this instance.
    public internal(set) var managedThruConnections: [String: MIDIThruConnection] = [:]
    
    /// Array of persistent MIDI thru connections which persist indefinitely (even after system
    /// reboots) until explicitly removed.
    ///
    /// For every persistent thru connection your app creates, they should be assigned the same
    /// persistent ID (domain) so they can be managed or removed in future.
    ///
    /// - Warning: Be careful when creating persistent thru connections, as they can become stale
    /// and orphaned if the endpoints used to create them cease to be relevant at any point in time.
    ///
    /// - Parameter ownerID: reverse-DNS domain that was used when the connection was first made
    /// - Throws: ``MIDIIOError``
    public func unmanagedPersistentThruConnections(ownerID: String) throws
    -> [CoreMIDIThruConnectionRef] {
        try getSystemThruConnectionsPersistentEntries(matching: ownerID)
    }
    
    /// MIDI devices in the system.
    public internal(set) var devices: MIDIIODevicesProtocol = MIDIDevices()
    
    /// MIDI input and output endpoints in the system.
    public internal(set) var endpoints: MIDIIOEndpointsProtocol = MIDIEndpoints()
    
    /// Handler that is called when state has changed in the manager.
    public var notificationHandler: ((
        _ notification: MIDIIONotification,
        _ manager: MIDIManager
    ) -> Void)?
    
    // MARK: - Internal dispatch queue
    
    /// Thread for MIDI event I/O.
    internal var eventQueue: DispatchQueue
    
    // MARK: - Init
    
    /// Initialize the MIDI manager (and Core MIDI client).
    ///
    /// - Parameters:
    ///   - clientName: Name identifying this instance, used as Core MIDI client ID.
    ///     This is internal and not visible to the end-user.
    ///   - model: The name of your software, which will be visible to the end-user in ports created
    ///     by the manager.
    ///   - manufacturer: The name of your company, which may be visible to the end-user in ports
    ///     created by the manager.
    ///   - notificationHandler: Optionally supply a callback handler for MIDI system notifications.
    public init(
        clientName: String,
        model: String,
        manufacturer: String,
        notificationHandler: ((
            _ notification: MIDIIONotification,
            _ manager: MIDIManager
        ) -> Void)? = nil
    ) {
        // API version
        preferredAPI = .bestForPlatform()
    
        // queue client name
        var clientNameForQueue = clientName.onlyAlphanumerics
        if clientNameForQueue.isEmpty { clientNameForQueue = UUID().uuidString }
    
        // manager event queue
        let eventQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".midiManager." + clientNameForQueue + ".events"
        eventQueue = DispatchQueue(
            label: eventQueueName,
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem,
            target: .global(qos: .userInitiated)
        )
    
        // assign other properties
        self.clientName = clientName
        self.model = model
        self.manufacturer = manufacturer
        self.notificationHandler = notificationHandler
    
        super.init()
    
        endpoints = MIDIEndpoints(manager: self)
    
        addNetworkSessionObservers()
    }
    
    deinit {
        eventQueue.sync {
            // Apple docs:
            // "Don’t explicitly dispose of your client; the system automatically disposes all
            // clients when an app terminates. However, if you call this method to dispose the last
            // or only client owned by an app, the MIDI server may exit if there are no other
            // clients remaining in the system"
            // _ = MIDIClientDispose(coreMIDIClientRef)
    
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    // MARK: - Helper methods
    
    internal func sendNotification(_ notif: MIDIIONotification) {
        if let notificationHandler = notificationHandler {
            DispatchQueue.main.async {
                notificationHandler(notif, self)
            }
        }
    }
    
    /// Internal: updates cached properties for all objects.
    internal dynamic func updateObjectsCache() {
        #if canImport(Combine)
        if #available(
            macOS 10.15,
            macCatalyst 13,
            iOS 13,
            /* tvOS 13, watchOS 6, */ *
        ) {
            // calling this means we don't need to use @Published on local variables in order for
            // Combine/SwiftUI to be notified that ObservableObject class property values have
            // changed
            objectWillChange.send()
        }
        #endif
    
        devices.updateCachedProperties()
        endpoints.updateCachedProperties()
    }
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, /* tvOS 13, watchOS 6, */ *)
extension MIDIManager: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif

#endif
