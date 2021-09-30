//
//  Manager Notification.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO.Manager {
    
    internal enum InternalNotification {
        
        case setupChanged
        
        case added(parent: MIDIObjectRef, parentType: MIDIObjectType,
                   child: MIDIObjectRef, childType: MIDIObjectType)
        
        case removed(parent: MIDIObjectRef, parentType: MIDIObjectType,
                     child: MIDIObjectRef, childType: MIDIObjectType)
        
        case propertyChanged(forRef: MIDIObjectRef, forRefType: MIDIObjectType,
                             propertyName: String)
        
        case thruConnectionChanged
        
        case serialPortOwnerChanged
        
        case ioError(device: MIDIDeviceRef, error: MIDI.IO.MIDIError)
        
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
                return .added(parent: m.parent, parentType: m.parentType,
                              child: m.child, childType: m.childType)
            }
            
        case .msgObjectRemoved:
            self = message.withMemoryRebound(
                to: MIDIObjectAddRemoveNotification.self,
                capacity: 1)
            { (message) in
                let m = message.pointee
                return .removed(parent: m.parent, parentType: m.parentType,
                                child: m.child, childType: m.childType)
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
                    device: m.driverDevice,
                    error: .osStatus(m.errorCode)
                )
            }
            
        @unknown default:
            self = .other(messageIDRawValue: messageID.rawValue)
            
        }
        
    }
    
}

extension MIDI.IO {
    
    public enum Notification {
        
        case systemEndpointsChanged
        
    }
    
}
