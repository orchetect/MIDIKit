//
//  MIDIIOInternalNotification.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=6.0)
internal import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

/// Internal MIDI subsystem notification with raw values.
///
/// This must be converted to an instance of ``MIDIIONotification`` before sending to the
/// ``MIDIManager``'s public notification handler.
enum MIDIIOInternalNotification {
    case setupChanged
    
    case added(
        parentRef: MIDIObjectRef,
        parentType: MIDIObjectType,
        childRef: MIDIObjectRef,
        childType: MIDIObjectType
    )
    
    case removed(
        parentRef: MIDIObjectRef,
        parentType: MIDIObjectType,
        childRef: MIDIObjectRef,
        childType: MIDIObjectType
    )
    
    case propertyChanged(
        forRef: MIDIObjectRef,
        forRefType: MIDIObjectType,
        propertyName: String
    )
    
    case thruConnectionChanged
    
    case serialPortOwnerChanged
    
    case ioError(
        deviceRef: MIDIDeviceRef,
        error: MIDIIOError
    )
    
    /// Internal start.
    /// (Applies only to iOS, macCatalyst, tvOS, watchOS, visionOS.)
    case internalStart
    
    /// Typically will never happen unless Apple adds additional cases to Core MIDI's
    /// `MIDINotificationMessageID` enum.
    case other(messageIDRawValue: Int32)
}

extension MIDIIOInternalNotification {
    init(_ message: UnsafePointer<MIDINotification>) {
        let messageID = message.pointee.messageID
        
        switch messageID {
        case .msgSetupChanged:
            self = .setupChanged
            
        case .msgObjectAdded:
            self = message.withMemoryRebound(
                to: MIDIObjectAddRemoveNotification.self,
                capacity: 1
            ) { (message) in
                let m = message.pointee
                return .added(
                    parentRef: m.parent,
                    parentType: m.parentType,
                    childRef: m.child,
                    childType: m.childType
                )
            }
            
        case .msgObjectRemoved:
            self = message.withMemoryRebound(
                to: MIDIObjectAddRemoveNotification.self,
                capacity: 1
            ) { (message) in
                let m = message.pointee
                return .removed(
                    parentRef: m.parent,
                    parentType: m.parentType,
                    childRef: m.child,
                    childType: m.childType
                )
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
                capacity: 1
            ) { (message) in
                let m = message.pointee
                return .ioError(
                    deviceRef: m.driverDevice,
                    error: .osStatus(m.errorCode)
                )
            }
            
        // `msgInternalStart` is only available in Xcode 16 for non-macOS platforms.
        #if !os(macOS) && compiler(>=6.0)
        case .msgInternalStart:
            self = .internalStart
        #endif
            
        @unknown default:
            self = .other(messageIDRawValue: messageID.rawValue)
        }
    }
}

#endif
