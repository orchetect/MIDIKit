//
//  Manager Notification.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    /// Internal MIDI subsystem notification with raw values.
    ///
    /// This must be converted to an instance of `SystemNotification` before sending to the `Manager`'s public notification handler.
    internal enum InternalNotification {
        
        case setupChanged
        
        case added(parentRef: MIDIObjectRef,
                   parentType: MIDIObjectType,
                   childRef: MIDIObjectRef,
                   childType: MIDIObjectType)
        
        case removed(parentRef: MIDIObjectRef,
                     parentType: MIDIObjectType,
                     childRef: MIDIObjectRef,
                     childType: MIDIObjectType)
        
        case propertyChanged(forRef: MIDIObjectRef,
                             forRefType: MIDIObjectType,
                             propertyName: String)
        
        case thruConnectionChanged
        
        case serialPortOwnerChanged
        
        case ioError(deviceRef: MIDIDeviceRef,
                     error: MIDI.IO.MIDIError)
        
        /// Typically will never happen unless Apple adds additional cases to Core MIDI's `MIDINotificationMessageID` enum.
        case other(messageIDRawValue: Int32)
        
    }
    
}

extension MIDI.IO.Manager.InternalNotification {
    
    internal init(_ message: UnsafePointer<MIDINotification>) {
        
        let messageID = message.pointee.messageID
        
        switch messageID {
        case .msgSetupChanged:
            self = .setupChanged
            
        case .msgObjectAdded:
            self = message.withMemoryRebound(
                to: MIDIObjectAddRemoveNotification.self,
                capacity: 1)
            { (message) in
                let m = message.pointee
                return .added(parentRef: m.parent,
                              parentType: m.parentType,
                              childRef: m.child,
                              childType: m.childType)
            }
            
        case .msgObjectRemoved:
            self = message.withMemoryRebound(
                to: MIDIObjectAddRemoveNotification.self,
                capacity: 1)
            { (message) in
                let m = message.pointee
                return .removed(parentRef: m.parent,
                                parentType: m.parentType,
                                childRef: m.child,
                                childType: m.childType)
            }
            
        case .msgPropertyChanged:
            self = message.withMemoryRebound(
                to: MIDIObjectPropertyChangeNotification.self,
                capacity: 1
            ) { (message) in
                
                let m = message.pointee
                
                return .propertyChanged(
                    forRef: m.object,
                    forRefType: m.objectType,
                    propertyName: m.propertyName.takeUnretainedValue() as String
                )
                
            }
            
        case .msgThruConnectionsChanged:
            self = .thruConnectionChanged
            
        case .msgSerialPortOwnerChanged:
            self = .serialPortOwnerChanged
            
        case .msgIOError:
            self = message.withMemoryRebound(
                to: MIDIIOErrorNotification.self,
                capacity: 1)
            { (message) in
                let m = message.pointee
                return .ioError(
                    deviceRef: m.driverDevice,
                    error: .osStatus(m.errorCode)
                )
            }
            
        @unknown default:
            self = .other(messageIDRawValue: messageID.rawValue)
            
        }
        
    }
    
}

extension MIDI.IO.Manager {
    
    /// Core MIDI subsystem notification.
    public enum SystemNotification: Equatable, Hashable {
        
        /// Some aspect of the current MIDI setup changed.
        ///
        /// This notification carries no data. This message is redundant if you’re explicitly handling other notifications.
        case setupChanged
        
        /// MIDI endpoints in the system have changed. Either endpoint(s) were added, removed, or changed (renamed or properties changed).
        ///
        /// This notification carries no data. This message is redundant if you’re explicitly handling `added`/`removed`/`propertyChanged` notifications.
        case systemEndpointsChanged
        
        /// The system added a device, entity, or endpoint.
        case systemAdded(parent: MIDI.IO.Object?,
                         child: MIDI.IO.Object)
        
        /// The system removed a device, entity, or endpoint.
        case systemRemoved(parent: MIDI.IO.Object?,
                           child: MIDI.IO.Object)
        
        /// An object’s property value changed.
        case propertyChanged(object: MIDI.IO.Object,
                             property: MIDI.IO.Object.Property)
        
        /// The system created or disposed of a persistent MIDI Thru connection.
        ///
        /// This notification carries no data.
        case thruConnectionChanged
        
        /// The system changed a serial port owner.
        ///
        /// This notification carries no data.
        case serialPortOwnerChanged
        
        /// A driver I/O error occurred.
        case ioError(device: MIDI.IO.Device,
                     error: MIDI.IO.MIDIError)
        
        /// Other/unknown notification.
        ///
        /// Typically will never happen unless Apple adds additional cases to Core MIDI's `MIDINotificationMessageID` enum.
        case other(messageIDRawValue: Int32)
        
    }
    
}

extension MIDI.IO.Manager.SystemNotification {
    
    internal struct MIDIObjectCache {
        
        var devices: [MIDI.IO.Device]
        var inputEndpoints: [MIDI.IO.InputEndpoint]
        var outputEndpoints: [MIDI.IO.OutputEndpoint]
        
        init(from manager: MIDI.IO.Manager) {
            devices = manager.devices.devices
            inputEndpoints = manager.endpoints.inputs
            outputEndpoints = manager.endpoints.outputs
        }
        
    }
    
    /// Converts an `InternalNotification` to `SystemNotification`.
    /// 
    /// Cache must be supplied if there is a possibility of a `removed` notification, otherwise metadata will be missing.
    internal init?(
        _ internalNotification: MIDI.IO.Manager.InternalNotification,
        cache: MIDIObjectCache?
    ) {
        
        switch internalNotification {
        case .setupChanged:
            self = .setupChanged
            
        case .added(let parentRef,
                    let parentType,
                    let childRef,
                    let childType):
            
            let parent = MIDI.IO.Object(coreMIDIObjectRef: parentRef,
                                        coreMIDIObjectType: parentType)
            guard let child = MIDI.IO.Object(coreMIDIObjectRef: childRef,
                                             coreMIDIObjectType: childType)
            else { return nil }
            
            self = .systemAdded(parent: parent,
                                child: child)
            
        case .removed(let parentRef,
                      let parentType,
                      let childRef,
                      let childType):
            
            // we need to rely on data cache to get more information
            // since a Core MIDI 'removed' notification happens after the object is gone
            
            let parent = MIDI.IO.Object(coreMIDIObjectRef: parentRef,
                                        coreMIDIObjectType: parentType,
                                        using: cache)
            guard let child = MIDI.IO.Object(coreMIDIObjectRef: childRef,
                                             coreMIDIObjectType: childType,
                                             using: cache)
            else { return nil }
            
            self = .systemRemoved(parent: parent,
                                  child: child)
            
        case .propertyChanged(let forRef,
                              let forRefType,
                              let propertyName):
            
            // specific notification
            guard let obj = MIDI.IO.Object(coreMIDIObjectRef: forRef,
                                           coreMIDIObjectType: forRefType),
                  let property = MIDI.IO.Object.Property(propertyName as CFString)
            else { return nil }
            
            self = .propertyChanged(object: obj,
                                    property: property)
            
        case .thruConnectionChanged:
            self = .thruConnectionChanged
            
        case .serialPortOwnerChanged:
            self = .serialPortOwnerChanged
            
        case .ioError(let deviceRef,
                      let error):
            let device = MIDI.IO.Device(deviceRef)
            self = .ioError(device: device,
                            error: error)
            
        case .other(let messageIDRawValue):
            self = .other(messageIDRawValue: messageIDRawValue)
            
        }
        
    }
    
}

extension MIDI.IO.Manager.SystemNotification: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .setupChanged:
            return "setupChanged"
            
        case .systemEndpointsChanged:
            return "systemEndpointsChanged"
            
        case .systemAdded(let parent,
                          let child):
            if let parent = parent {
                return "systemAdded(parent: \(parent), child: \(child))"
            } else {
                return "systemAdded(\(child))"
            }
            
        case .systemRemoved(let parent,
                            let child):
            if let parent = parent {
                return "systemRemoved(parent: \(parent), child: \(child))"
            } else {
                return "systemRemoved(\(child))"
            }
            
        case .propertyChanged(let object,
                              let property):
            return "propertyChanged(for: \(object), property: \(property))"
            
        case .thruConnectionChanged:
            return "thruConnectionChanged"
            
        case .serialPortOwnerChanged:
            return "serialPortOwnerChanged"
            
        case .ioError(let device,
                      let error):
            return "ioError(device: \(device), error: \(error))"
            
        case .other(let messageIDRawValue):
            return "other(ID: \(messageIDRawValue))"
            
        }
        
    }
    
}
