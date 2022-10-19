//
//  MIDIDevice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Device

/// A MIDI device, wrapping a Core MIDI `MIDIDeviceRef`.
///
/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
///
/// Instead, read device arrays and individual device properties from ``MIDIManager/devices`` ad-hoc
/// when they are needed.
public struct MIDIDevice: MIDIIOObject {
    // MARK: MIDIIOObject
    
    public let objectType: MIDIIOObjectType = .device
    
    /// User-visible device name.
    /// (`kMIDIPropertyName`)
    public internal(set) var name: String = ""
    
    /// System-global Unique ID.
    /// (`kMIDIPropertyUniqueID`)
    public internal(set) var uniqueID: MIDIIdentifier = .invalidMIDIIdentifier
    
    public let coreMIDIObjectRef: CoreMIDIDeviceRef
    
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        .device(self)
    }
    
    // MARK: Init
    
    internal init(from ref: CoreMIDIDeviceRef) {
        assert(ref != CoreMIDIDeviceRef())
    
        coreMIDIObjectRef = ref
        update()
    }
    
    // MARK: Update Cached Properties
    
    /// Update the cached properties
    internal mutating func update() {
        if let name = getName() {
            self.name = name
        }
    
        let uniqueID = getUniqueID()
        if uniqueID != .invalidMIDIIdentifier {
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

extension MIDIDevice {
    /// List of entities within the device.
    public var entities: [MIDIEntity] {
        getSystemEntities(for: coreMIDIObjectRef)
    }
}

extension MIDIDevice {
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        getSystemDevices()
            .contains(whereUniqueID: uniqueID)
    }
}

extension MIDIDevice: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MIDIDevice(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists))"
    }
}

#endif
