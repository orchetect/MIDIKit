//
//  MIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=6.0)
internal import CoreMIDI
internal import MIDIKitInternals
#else
@_implementationOnly import CoreMIDI
@_implementationOnly import MIDIKitInternals
#endif

/// Central MIDI Port and Connection Manager and MIDI system data provider.
///
/// One ``MIDIManager`` instance stored in a global lifecycle context can manage multiple MIDI ports
/// and connections, and is usually sufficient for all of an application's MIDI needs.
///
/// > Tip:
/// >
/// > For SwiftUI and Combine environments, see the ``ObservableMIDIManager`` subclass which adds
/// > published devices and endpoints properties.
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
        get { _preferredAPILock.withLock { _preferredAPI } }
        set {
            _preferredAPILock.withLock {
                // prevent setting of an invalid API
                if !newValue.isValidOnCurrentPlatform {
                    _preferredAPI = .bestForPlatform()
                } else {
                    _preferredAPI = newValue
                }
            }
        }
    }
    private nonisolated(unsafe) var _preferredAPI: CoreMIDIAPIVersion
    private let _preferredAPILock = NSLock()
    
    /// Dictionary of MIDI input connections managed by this instance.
    public internal(set) var managedInputConnections: [String: MIDIInputConnection] {
        get { return _managedInputConnectionsLock.withLock { _managedInputConnections } }
        _modify {
            var valueCopy = _managedInputConnectionsLock.withLock { _managedInputConnections }
            yield &valueCopy
            _managedInputConnectionsLock.withLock { _managedInputConnections = valueCopy }
        }
        set { _managedInputConnectionsLock.withLock { _managedInputConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedInputConnections: [String: MIDIInputConnection] = [:]
    private let _managedInputConnectionsLock = NSLock()
    
    /// Dictionary of MIDI output connections managed by this instance.
    public internal(set) var managedOutputConnections: [String: MIDIOutputConnection] {
        get { return _managedOutputConnectionsLock.withLock { _managedOutputConnections } }
        _modify {
            var valueCopy = _managedOutputConnectionsLock.withLock { _managedOutputConnections }
            yield &valueCopy
            _managedOutputConnectionsLock.withLock { _managedOutputConnections = valueCopy }
        }
        set { _managedOutputConnectionsLock.withLock { _managedOutputConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedOutputConnections: [String: MIDIOutputConnection] = [:]
    private let _managedOutputConnectionsLock = NSLock()
    
    /// Dictionary of virtual MIDI inputs managed by this instance.
    public internal(set) var managedInputs: [String: MIDIInput] {
        get { return _managedInputsLock.withLock { _managedInputs } }
        _modify {
            var valueCopy = _managedInputsLock.withLock { _managedInputs }
            yield &valueCopy
            _managedInputsLock.withLock { _managedInputs = valueCopy }
        }
        set { _managedInputsLock.withLock { _managedInputs = newValue } }
    }
    private nonisolated(unsafe) var _managedInputs: [String: MIDIInput] = [:]
    private let _managedInputsLock = NSLock()
    
    /// Dictionary of virtual MIDI outputs managed by this instance.
    public internal(set) var managedOutputs: [String: MIDIOutput] {
        get { return _managedOutputsLock.withLock { _managedOutputs } }
        _modify {
            var valueCopy = _managedOutputsLock.withLock { _managedOutputs }
            yield &valueCopy
            _managedOutputsLock.withLock { _managedOutputs = valueCopy }
        }
        set { _managedOutputsLock.withLock { _managedOutputs = newValue } }
    }
    private nonisolated(unsafe) var _managedOutputs: [String: MIDIOutput] = [:]
    private let _managedOutputsLock = NSLock()
    
    /// Dictionary of non-persistent MIDI thru connections managed by this instance.
    public internal(set) var managedThruConnections: [String: MIDIThruConnection] {
        get { return _managedThruConnectionsLock.withLock { _managedThruConnections } }
        _modify {
            var valueCopy = _managedThruConnectionsLock.withLock { _managedThruConnections }
            yield &valueCopy
            _managedThruConnectionsLock.withLock { _managedThruConnections = valueCopy }
        }
        set { _managedThruConnectionsLock.withLock { _managedThruConnections = newValue } }
    }
    private nonisolated(unsafe) var _managedThruConnections: [String: MIDIThruConnection] = [:]
    private let _managedThruConnectionsLock = NSLock()
    
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
        get { return _devicesLock.withLock { _devices } }
        _modify {
            var valueCopy = _devicesLock.withLock { _devices }
            yield &valueCopy
            _devicesLock.withLock { _devices = valueCopy }
        }
        set { _devicesLock.withLock { _devices = newValue } }
    }
    private nonisolated(unsafe) var _devices = MIDIDevices()
    private let _devicesLock = NSLock()
    
    /// MIDI input and output endpoints in the system.
    public internal(set) var endpoints: MIDIEndpoints {
        get { return _endpointsLock.withLock { _endpoints } }
        _modify {
            var valueCopy = _endpointsLock.withLock { _endpoints }
            yield &valueCopy
            _endpointsLock.withLock { _endpoints = valueCopy }
        }
        set { _endpointsLock.withLock { _endpoints = newValue } }
    }
    private nonisolated(unsafe) var _endpoints = MIDIEndpoints()
    private let _endpointsLock = NSLock()
    
    /// Handler that is called when state has changed in the manager.
    public typealias NotificationHandler = @Sendable (
        _ notification: MIDIIONotification,
        _ manager: MIDIManager
    ) -> Void
    
    /// Handler that is called when state has changed in the manager.
    public nonisolated(unsafe) var notificationHandler: NotificationHandler?
    
    /// Internal: system state cache for notification handling.
    var notificationCache: MIDIIOObjectCache? {
        get { return _notificationCacheLock.withLock { _notificationCache } }
        _modify {
            var valueCopy = _notificationCacheLock.withLock { _notificationCache }
            yield &valueCopy
            _notificationCacheLock.withLock { _notificationCache = valueCopy }
        }
        set { _notificationCacheLock.withLock { _notificationCache = newValue } }
    }
    private nonisolated(unsafe) var _notificationCache: MIDIIOObjectCache?
    private let _notificationCacheLock = NSLock()
    
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
        // API version
        _preferredAPI = .bestForPlatform()
        
        // queue client name
        var clientNameForQueue = clientName.onlyAlphanumerics
        if clientNameForQueue.isEmpty { clientNameForQueue = UUID().uuidString }
        
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
