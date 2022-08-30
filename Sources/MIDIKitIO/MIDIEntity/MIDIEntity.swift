//
//  MIDIEntity.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Entity

/// A MIDI device, wrapping a Core MIDI `MIDIEntityRef`.
///
/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
public struct MIDIEntity: MIDIIOObject {
    // MARK: MIDIIOObject
    
    public let objectType: MIDIIOObjectType = .entity
    
    /// User-visible endpoint name.
    /// (`kMIDIPropertyName`)
    public internal(set) var name: String = ""
    
    /// System-global Unique ID.
    /// (`kMIDIPropertyUniqueID`)
    public internal(set) var uniqueID: MIDIIdentifier = .invalidMIDIIdentifier
    
    public let coreMIDIObjectRef: CoreMIDIEntityRef
    
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        .entity(self)
    }
    
    // MARK: Init
    
    internal init(from ref: CoreMIDIEntityRef) {
        assert(ref != CoreMIDIEntityRef())
    
        coreMIDIObjectRef = ref
        update()
    }
    
    // MARK: - Cached Properties Update
    
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

extension MIDIEntity: Equatable {
    // default implementation provided in MIDIIOObject
}

extension MIDIEntity: Hashable {
    // default implementation provided in MIDIIOObject
}

extension MIDIEntity: Identifiable {
    public typealias ID = CoreMIDIObjectRef
    
    public var id: ID { coreMIDIObjectRef }
}

extension MIDIEntity {
    public func getDevice() -> MIDIDevice? {
        try? getSystemDevice(for: coreMIDIObjectRef)
    }
    
    /// Returns the inputs for the entity.
    public var inputs: [MIDIInputEndpoint] {
        getSystemDestinations(for: coreMIDIObjectRef)
    }
    
    /// Returns the outputs for the entity.
    public var outputs: [MIDIOutputEndpoint] {
        getSystemSources(for: coreMIDIObjectRef)
    }
}

extension MIDIEntity {
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        getDevice() != nil
    }
}

extension MIDIEntity: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MIDIEntity(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
    }
}

#endif
