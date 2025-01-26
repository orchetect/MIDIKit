//
//  MIDIIONotification.swift
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

/// Core MIDI subsystem notification.
public enum MIDIIONotification {
    /// Some aspect of the current MIDI setup changed.
    ///
    /// This notification carries no data. This message is redundant if you’re explicitly handling
    /// other notifications.
    case setupChanged
    
    /// The system added a device, entity, or endpoint.
    case added(
        object: AnyMIDIIOObject,
        parent: AnyMIDIIOObject?
    )
    
    /// The system removed a device, entity, or endpoint.
    case removed(
        object: AnyMIDIIOObject,
        parent: AnyMIDIIOObject?
    )
    
    /// An object’s property value changed.
    case propertyChanged(
        property: AnyMIDIIOObject.Property,
        forObject: AnyMIDIIOObject
    )
    
    /// The system created or disposed of a persistent MIDI Thru connection.
    ///
    /// This notification carries no data.
    case thruConnectionChanged
    
    /// The system changed a serial port owner.
    ///
    /// This notification carries no data.
    case serialPortOwnerChanged
    
    /// A driver I/O error occurred.
    case ioError(
        device: MIDIDevice,
        error: MIDIIOError
    )
    
    /// Internal start.
    ///
    /// Applies only to iOS, macCatalyst, tvOS, watchOS, visionOS.
    case internalStart
    
    /// Other/unknown notification.
    ///
    /// Typically will never happen unless Apple adds additional cases to Core MIDI's
    /// `MIDINotificationMessageID` enum.
    case other(messageIDRawValue: Int32)
}

extension MIDIIONotification: Equatable { }

extension MIDIIONotification: Hashable { }

extension MIDIIONotification: Sendable { }

extension MIDIIONotification {
    /// Converts a ``MIDIIOInternalNotification`` to ``MIDIIONotification``.
    ///
    /// Cache must be supplied if there is a possibility of a ``removed(parent:child:)``
    /// notification, otherwise metadata will be missing.
    init?(
        _ internalNotification: MIDIIOInternalNotification,
        cache: MIDIIOObjectCache?
    ) {
        switch internalNotification {
        case .setupChanged:
            self = .setupChanged
    
        case let .added(parentRef, parentType, childRef, childType):
            let parent = AnyMIDIIOObject(
                coreMIDIObjectRef: parentRef,
                coreMIDIObjectType: parentType
            )
            guard let child = AnyMIDIIOObject(
                coreMIDIObjectRef: childRef,
                coreMIDIObjectType: childType
            )
            else { return nil }
    
            self = .added(object: child, parent: parent)
    
        case let .removed(parentRef, parentType, childRef, childType):
            // we need to rely on data cache to get more information
            // since a Core MIDI 'removed' notification happens after the object is gone
    
            let parent = AnyMIDIIOObject(
                coreMIDIObjectRef: parentRef,
                coreMIDIObjectType: parentType,
                using: cache
            )
            guard let child = AnyMIDIIOObject(
                coreMIDIObjectRef: childRef,
                coreMIDIObjectType: childType,
                using: cache
            )
            else { return nil }
    
            self = .removed(object: child, parent: parent)
    
        case let .propertyChanged(forRef, forRefType, propertyName):
    
            // specific notification
            guard let obj = AnyMIDIIOObject(
                coreMIDIObjectRef: forRef,
                coreMIDIObjectType: forRefType
            ),
                let property = AnyMIDIIOObject.Property(propertyName as CFString)
            else { return nil }
    
            self = .propertyChanged(property: property, forObject: obj)
    
        case .thruConnectionChanged:
            self = .thruConnectionChanged
    
        case .serialPortOwnerChanged:
            self = .serialPortOwnerChanged
    
        case let .ioError(deviceRef, error):
            let device = MIDIDevice(from: deviceRef)
            self = .ioError(
                device: device,
                error: error
            )
            
        case .internalStart:
            self = .internalStart
    
        case let .other(messageIDRawValue):
            self = .other(messageIDRawValue: messageIDRawValue)
        }
    }
}

extension MIDIIONotification: CustomStringConvertible {
    public var description: String {
        switch self {
        case .setupChanged:
            return "setupChanged"
    
        case let .added(object: object, parent: parent):
            if let parent {
                return "added(\(object), parent: \(parent))"
            } else {
                return "added(\(object))"
            }
    
        case let .removed(object: object, parent: parent):
            if let parent {
                return "removed(\(object), parent: \(parent))"
            } else {
                return "removed(\(object))"
            }
    
        case let .propertyChanged(object, property):
            return "propertyChanged(\(property), for: \(object))"
    
        case .thruConnectionChanged:
            return "thruConnectionChanged"
    
        case .serialPortOwnerChanged:
            return "serialPortOwnerChanged"
    
        case let .ioError(device, error):
            return "ioError(device: \(device), error: \(error))"
    
        case .internalStart:
            return "internalStart"
            
        case let .other(messageIDRawValue):
            return "other(ID: \(messageIDRawValue))"
        }
    }
}

#endif
