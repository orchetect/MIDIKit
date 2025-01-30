//
//  MIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI
internal import MIDIKitInternals

/// Central MIDI Port and Connection Manager and MIDI system data provider.
///
/// One ``MIDIManager`` instance stored in a global lifecycle context can manage multiple MIDI ports
/// and connections, and is usually sufficient for all of an application's MIDI needs.
///
/// > Tip:
/// >
/// > For SwiftUI environments, see the ``ObservableMIDIManager`` or ``ObservableObjectMIDIManager``
/// > subclass which makes ``devices`` and ``endpoints`` properties observable.
public class MIDIManager: @unchecked Sendable {
    // MARK: - Properties
    
    /// MIDI Client Name.
    public nonisolated let clientName: String
    
    /// Core MIDI Client Reference.
    public internal(set) nonisolated(unsafe) var coreMIDIClientRef = CoreMIDIClientRef()
    
    /// MIDI Model: The name of your software, which will be visible to the end-user in ports
    /// created by the manager.
    public nonisolated let model: String
    
    /// MIDI Manufacturer: The name of your company, which may be visible to the end-user in ports
    /// created by the manager.
    public nonisolated let manufacturer: String
    
    /// Preferred underlying Core MIDI API to use as default when creating new managed endpoints.
    /// This value defaults to the best API for the current platform.
    ///
    /// The preferred API will be used where possible, unless operating system requirements force
    /// the use of a specific.
    public var preferredAPI: CoreMIDIAPIVersion {
        get { accessQueue.sync { _preferredAPI } }
        set {
            accessQueue.sync {
                // prevent setting of an invalid API
                _preferredAPI = newValue.isValidOnCurrentPlatform ? newValue : .bestForPlatform()
            }
        }
    }
    private nonisolated(unsafe) var _preferredAPI: CoreMIDIAPIVersion
    
    /// Dictionary of MIDI input connections managed by this instance.
    public internal(set) var managedInputConnections: [String: MIDIInputConnection] {
        get { return accessQueue.sync { _managedInputConnections } }
        _modify {
            var valueCopy = accessQueue.sync { _managedInputConnections }
            yield &valueCopy
            accessQueue.sync { _managedInputConnections = valueCopy }
        }
        set { accessQueue.sync { _managedInputConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedInputConnections: [String: MIDIInputConnection] = [:]
    
    /// Dictionary of MIDI output connections managed by this instance.
    public internal(set) var managedOutputConnections: [String: MIDIOutputConnection] {
        get { return accessQueue.sync { _managedOutputConnections } }
        _modify {
            var valueCopy = accessQueue.sync { _managedOutputConnections }
            yield &valueCopy
            accessQueue.sync { _managedOutputConnections = valueCopy }
        }
        set { accessQueue.sync { _managedOutputConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedOutputConnections: [String: MIDIOutputConnection] = [:]
    
    /// Dictionary of virtual MIDI inputs managed by this instance.
    public internal(set) var managedInputs: [String: MIDIInput] {
        get { return accessQueue.sync { _managedInputs } }
        _modify {
            var valueCopy = accessQueue.sync { _managedInputs }
            yield &valueCopy
            accessQueue.sync { _managedInputs = valueCopy }
        }
        set { accessQueue.sync { _managedInputs = newValue } }
    }
    private nonisolated(unsafe) var _managedInputs: [String: MIDIInput] = [:]
    
    /// Dictionary of virtual MIDI outputs managed by this instance.
    public internal(set) var managedOutputs: [String: MIDIOutput] {
        get { return accessQueue.sync { _managedOutputs } }
        _modify {
            var valueCopy = accessQueue.sync { _managedOutputs }
            yield &valueCopy
            accessQueue.sync { _managedOutputs = valueCopy }
        }
        set { accessQueue.sync { _managedOutputs = newValue } }
    }
    private nonisolated(unsafe) var _managedOutputs: [String: MIDIOutput] = [:]
    
    /// Dictionary of non-persistent MIDI thru connections managed by this instance.
    public internal(set) var managedThruConnections: [String: MIDIThruConnection] {
        get { return accessQueue.sync { _managedThruConnections } }
        _modify {
            var valueCopy = accessQueue.sync { _managedThruConnections }
            yield &valueCopy
            accessQueue.sync { _managedThruConnections = valueCopy }
        }
        set { accessQueue.sync { _managedThruConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedThruConnections: [String: MIDIThruConnection] = [:]
    
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
    public func unmanagedPersistentThruConnections(
        ownerID: String
    ) throws -> [CoreMIDIThruConnectionRef] {
        try getSystemThruConnectionsPersistentEntries(matching: ownerID)
    }
    
    /// MIDI devices in the system.
    public internal(set) var devices: MIDIDevices {
        get { return accessQueue.sync { _devices } }
        _modify {
            var valueCopy = accessQueue.sync { _devices }
            yield &valueCopy
            accessQueue.sync { _devices = valueCopy }
        }
        set { accessQueue.sync { _devices = newValue } }
    }
    private nonisolated(unsafe) var _devices = MIDIDevices()
    
    /// MIDI input and output endpoints in the system.
    public internal(set) var endpoints: MIDIEndpoints {
        get { return accessQueue.sync { _endpoints } }
        _modify {
            var valueCopy = accessQueue.sync { _endpoints }
            yield &valueCopy
            accessQueue.sync { _endpoints = valueCopy }
        }
        set { accessQueue.sync { _endpoints = newValue } }
    }
    private nonisolated(unsafe) var _endpoints = MIDIEndpoints()
    
    /// Handler that is called when state has changed in the manager.
    public typealias NotificationHandler = @Sendable (
        _ notification: MIDIIONotification,
        _ manager: MIDIManager
    ) -> Void
    
    /// Handler that is called when state has changed in the manager.
    public nonisolated(unsafe) var notificationHandler: NotificationHandler?
    
    /// Internal: system state cache for notification handling.
    var notificationCache: MIDIIOObjectCache? {
        get { return accessQueue.sync { _notificationCache } }
        _modify {
            var valueCopy = accessQueue.sync { _notificationCache }
            yield &valueCopy
            accessQueue.sync { _notificationCache = valueCopy }
        }
        set { accessQueue.sync { _notificationCache = newValue } }
    }
    private nonisolated(unsafe) var _notificationCache: MIDIIOObjectCache?
    
    // MARK: - Internal dispatch queue
    
    let accessQueue: DispatchQueue
    let managementQueue: DispatchQueue
    
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
        notificationHandler: NotificationHandler? = nil
    ) {
        // queue client name
        var clientNameForQueue = clientName.onlyAlphanumerics
        if clientNameForQueue.isEmpty { clientNameForQueue = UUID().uuidString }
        
        // API version
        _preferredAPI = .bestForPlatform()
        
        // access queue
        let accessQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".midiManager." + clientNameForQueue + ".access"
        accessQueue = DispatchQueue(
            label: accessQueueName,
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .workItem,
            target: .global(qos: .userInitiated)
        )
        
        // management queue
        let managementQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".midiManager." + clientNameForQueue + ".management"
        managementQueue = DispatchQueue(
            label: managementQueueName,
            qos: .default,
            attributes: [],
            autoreleaseFrequency: .workItem,
            target: .global(qos: .default)
        )
        
        // assign other properties
        self.clientName = clientName
        self.model = model
        self.manufacturer = manufacturer
        self.notificationHandler = notificationHandler
        
        // we aren't using network session observation for anything yet, so no need to add observers
        // addNetworkSessionObservers()
    }
    
    deinit {
        // Apple docs:
        // "Don’t explicitly dispose of your client; the system automatically disposes all
        // clients when an app terminates. However, if you call this method to dispose the last
        // or only client owned by an app, the MIDI server may exit if there are no other
        // clients remaining in the system"
        //
        // _ = MIDIClientDispose(coreMIDIClientRef)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helper methods
    
    /// Internal: updates cached properties for all objects.
    func updateObjectsCache() {
        devices.updateCachedProperties()
        endpoints.updateCachedProperties(manager: self)
    }
}

#endif
