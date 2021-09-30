//
//  Manager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Connection Manager wrapper for Core MIDI.
    ///
    /// One `Manager` instance stored in a global lifecycle context can manage multiple MIDI ports and connections, and is usually sufficient for all of an application's MIDI needs.
    public class Manager: NSObject {
        
        // MARK: - Properties
        
        /// MIDI Client Name.
        public internal(set) var clientName: String
        
        /// MIDI Client Reference.
        internal var clientRef = MIDI.IO.CoreMIDIClientRef()
        
        /// MIDI Model: The name of your software, which will be visible to the end-user in ports created by the manager.
        public internal(set) var model: String = ""
        
        /// MIDI Manufacturer: The name of your company, which may be visible to the end-user in ports created by the manager.
        public internal(set) var manufacturer: String = ""
        
        /// Preferred underlying Core MIDI API to use as default when creating new managed endpoints.
        ///
        /// The preferred API will be used where possible, unless operating system requirements force the use of a specific.
        ///
        /// - Note: Currently, legacy API is recommended as it is more stable. (New API is experimental due to bugs in Core MIDI itself, until workarounds or resolutions can be found.)
        public var preferredAPI: MIDI.IO.APIVersion {
            didSet {
                // prevent setting of an invalid API
                if !preferredAPI.isValidOnCurrentPlatform {
                    preferredAPI = .bestForPlatform()
                }
            }
        }
        
        /// Dictionary of MIDI input connections managed by this instance.
        public internal(set) var managedInputConnections: [String : InputConnection] = [:]
        
        /// Dictionary of MIDI output connections managed by this instance.
        public internal(set) var managedOutputConnections: [String : OutputConnection] = [:]
        
        /// Dictionary of virtual MIDI inputs managed by this instance.
        public internal(set) var managedInputs: [String : Input] = [:]
        
        /// Dictionary of virtual MIDI outputs managed by this instance.
        public internal(set) var managedOutputs: [String : Output] = [:]
        
        /// Dictionary of non-persistent MIDI thru connections managed by this instance.
        public internal(set) var managedThruConnections: [String : ThruConnection] = [:]
        
        /// Array of persistent MIDI thru connections which persist indefinitely (even after system reboots) until explicitly removed.
        ///
        /// For every persistent thru connection your app creates, they should be assigned the same persistent ID (domain) so they can be managed or removed in future.
        ///
        /// - Warning: Be careful when creating persistent thru connections, as they can become stale and orphaned if the endpoints used to create them cease to be relevant at any point in time.
        ///
        /// - Parameter ownerID: reverse-DNS domain that was used when the connection was first made
        /// - Throws: `MIDI.IO.MIDIError`
        public func unmanagedPersistentThruConnections(ownerID: String) throws -> [MIDI.IO.CoreMIDIThruConnectionRef] {
            
            try MIDI.IO.getSystemThruConnectionsPersistentEntries(matching: ownerID)
            
        }
        
        /// MIDI devices in the system.
        public internal(set) var devices: MIDIIODevicesProtocol = Devices()
        
        /// MIDI input and output endpoints in the system.
        public internal(set) var endpoints: MIDIIOEndpointsProtocol = Endpoints()
        
        /// Handler that is called when state has changed in the manager.
        public var notificationHandler: ((_ notification: Notification,
                                          _ manager: Manager) -> Void)? = nil
        
        // MARK: - Internal dispatch queue
        
        /// Thread for MIDI event I/O.
        internal var eventQueue: DispatchQueue
        
        // MARK: - Init
        
        /// Initialize the MIDI manager (and Core MIDI client).
        ///
        /// - Parameters:
        ///   - clientName: Name identifying this instance, used as Core MIDI client ID. This is internal and not visible to the end-user.
        ///   - model: The name of your software, which will be visible to the end-user in ports created by the manager.
        ///   - manufacturer: The name of your company, which may be visible to the end-user in ports created by the manager.
        ///   - notificationHandler: Optionally supply a callback handler for MIDI system notifications.
        public init(
            clientName: String,
            model: String,
            manufacturer: String,
            notificationHandler: ((_ notification: Notification,
                                   _ manager: Manager) -> Void)? = nil
        ) {
            
            // API version
            // Currently, legacy API is recommended as it is more stable. (New API is experimental due to bugs in Core MIDI itself, until workarounds or resolutions can be found.)
            // So we will default to legacy here if possible.
            preferredAPI = APIVersion.legacyCoreMIDI.isValidOnCurrentPlatform
            ? .legacyCoreMIDI : .bestForPlatform()
            
            // queue client name
            var clientNameForQueue = clientName.onlyAlphanumerics
            if clientNameForQueue.isEmpty { clientNameForQueue = UUID().uuidString }
            
            // manager event queue
            let eventQueueName = (Bundle.main.bundleIdentifier ?? "unknown") + ".midiManager." + clientNameForQueue + ".events"
            eventQueue = DispatchQueue(label: eventQueueName,
                                       qos: .userInteractive,
                                       attributes: [],
                                       autoreleaseFrequency: .workItem,
                                       target: .global(qos: .userInteractive))
            
            // assign other properties
            self.clientName = clientName
            self.model = model
            self.manufacturer = manufacturer
            self.notificationHandler = notificationHandler
            
        }
        
        deinit {
            eventQueue.sync {
                let result = MIDIClientDispose(clientRef)
                
                if result != noErr {
                    // not important to log this, we can omit it for now
                    //let osStatusMessage = MIDIOSStatus(rawValue: result).description
                    //Log.debug("Error disposing of MIDI client: \(osStatusMessage)")
                }
            }
        }
        
        // MARK: - Helper methods
        
        /// Internal: calls `update()` on all objects caches.
        internal dynamic func updateObjectsCache() {
            
            #if canImport(Combine)
            if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *) {
                // calling this means we don't need to use @Published on local variables in order for Combine/SwiftUI to be notified that ObservableObject class property values have changed
                objectWillChange.send()
            }
            #endif
            
            devices.update()
            endpoints.update()
            DispatchQueue.main.async {
                self.notificationHandler?(.systemEndpointsChanged, self)
            }
            
        }
        
    }
    
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
extension MIDI.IO.Manager: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
