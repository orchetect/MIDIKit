//
//  MIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
public class MIDIManager: @unchecked Sendable { // forced to use @unchecked since class is not final
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
    @ThreadSafeAccess
    public var preferredAPI: CoreMIDIAPIVersion {
        didSet {
            // prevent setting of an invalid API
            if !preferredAPI.isValidOnCurrentPlatform {
                preferredAPI = .bestForPlatform()
            }
        }
    }
    
    /// Dictionary of MIDI input connections managed by this instance.
    @ThreadSafeAccess
    public internal(set) var managedInputConnections: [String: MIDIInputConnection] = [:]
    
    /// Dictionary of MIDI output connections managed by this instance.
    @ThreadSafeAccess
    public internal(set) var managedOutputConnections: [String: MIDIOutputConnection] = [:]
    
    /// Dictionary of virtual MIDI inputs managed by this instance.
    @ThreadSafeAccess
    public internal(set) var managedInputs: [String: MIDIInput] = [:]
    
    /// Dictionary of virtual MIDI outputs managed by this instance.
    @ThreadSafeAccess
    public internal(set) var managedOutputs: [String: MIDIOutput] = [:]
    
    /// Dictionary of non-persistent MIDI thru connections managed by this instance.
    @ThreadSafeAccess
    public internal(set) var managedThruConnections: [String: MIDIThruConnection] = [:]
    
    /// Array of persistent MIDI thru connections which persist indefinitely (even after system
    /// reboots) until explicitly removed.
    ///
    /// For every persistent thru connection your app creates, they should be assigned the same
    /// persistent ID (domain) so they can be managed or removed in future.
    ///
    /// - Warning: Be careful when creating persistent thru connections, as they can become stale
    ///   and orphaned if the endpoints used to create them cease to be relevant at any point in time.
    ///
    /// - Parameter ownerID: reverse-DNS domain that was used when the connection was first made
    /// - Throws: ``MIDIIOError``
    public func unmanagedPersistentThruConnections(
        ownerID: String
    ) throws -> [CoreMIDIThruConnectionRef] {
        try getSystemThruConnectionsPersistentEntries(matching: ownerID)
    }
    
    /// MIDI devices in the system.
    @ThreadSafeAccess
    public internal(set) var devices: MIDIDevices = .init()
    
    /// MIDI input and output endpoints in the system.
    @ThreadSafeAccess
    public internal(set) var endpoints: MIDIEndpoints = .init()
    
    /// Handler that is called when state has changed in the manager.
    public typealias NotificationHandler = @Sendable (
        _ notification: MIDIIONotification
    ) -> Void
    
    /// Handler that is called when state has changed in the manager.
    @ThreadSafeAccess
    public var notificationHandler: NotificationHandler?
    
    /// Internal: Ephemeral MIDI object metadata cache for MIDI object removal notifications.
    @ThreadSafeAccess
    var midiObjectCache = MIDIObjectCache()
    
    // MARK: - Internal dispatch queue
    
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
        preferredAPI = .bestForPlatform()
        
        // management queue
        let managementQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".midiManager." + clientNameForQueue + ".management"
        managementQueue = DispatchQueue(
            label: managementQueueName,
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
    func updateDevicesAndEndpoints() {
        self.devices.updateCachedProperties()
        self.endpoints.updateCachedProperties(manager: self)
    }
}

#endif
