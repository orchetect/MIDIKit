//
//  MIDIDevice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Device

/// A MIDI device, wrapping a Core MIDI `MIDIDeviceRef`.
/// A device can contain zero or more entities, and an entity can contain zero or more inputs
/// and output endpoints.
///
/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
///
/// Instead, read device arrays and individual device properties from ``MIDIManager/devices`` ad-hoc
/// when they are needed.
public struct MIDIDevice: MIDIIOObject {
    // MARK: MIDIIOObject
    
    public let objectType: MIDIIOObjectType = .device
    
    public internal(set) var name: String = ""
    
    public internal(set) var displayName: String = ""
    
    /// System-global Unique ID.
    /// (`kMIDIPropertyUniqueID`)
    public internal(set) var uniqueID: MIDIIdentifier = .invalidMIDIIdentifier
    
    public let coreMIDIObjectRef: CoreMIDIDeviceRef
    
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        .device(self)
    }
    
    // MARK: Init
    
    init(from ref: CoreMIDIDeviceRef) {
        assert(ref != CoreMIDIDeviceRef())
    
        coreMIDIObjectRef = ref
        updateCachedProperties()
    }
    
    // MARK: Update Cached Properties
    
    /// Update the cached properties
    mutating func updateCachedProperties() {
        if let name = try? MIDIKitIO.getName(of: coreMIDIObjectRef) {
            self.name = name
        }
        
        if let displayName = try? MIDIKitIO.getDisplayName(of: coreMIDIObjectRef) {
            self.displayName = displayName
        }
    
        if let uniqueID = try? MIDIKitIO.getUniqueID(of: coreMIDIObjectRef),
           uniqueID != .invalidMIDIIdentifier
        {
            self.uniqueID = uniqueID
        }
    }
}

extension MIDIDevice: Equatable {
    // default implementation provided in MIDIIOObject
}

extension MIDIDevice: Hashable {
    // default implementation provided in MIDIIOObject
}

extension MIDIDevice: Identifiable {
    public typealias ID = CoreMIDIObjectRef
    public var id: ID { coreMIDIObjectRef }
}

extension MIDIDevice: Sendable { }

extension MIDIDevice: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MIDIDevice(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists))"
    }
}

extension MIDIDevice {
    /// List of entities in the device.
    public var entities: [MIDIEntity] {
        getSystemEntities(for: coreMIDIObjectRef)
    }
    
    /// Returns a combined collection of all the input endpoints for all entities in the device.
    public var inputs: [MIDIInputEndpoint] {
        entities.flatMap(\.inputs)
    }
    
    /// Returns a combined collection of all the input endpoints for all entities in the device.
    public var outputs: [MIDIOutputEndpoint] {
        entities.flatMap(\.outputs)
    }
}

extension MIDIDevice {
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        getSystemDevices()
            .contains(whereUniqueID: uniqueID)
    }
}

#endif
