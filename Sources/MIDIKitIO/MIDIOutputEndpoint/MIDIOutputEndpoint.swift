//
//  MIDIOutputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

// MARK: - OutputEndpoint

/// A MIDI output endpoint in the system, wrapping a Core MIDI `MIDIEndpointRef`.
///
/// Although this is a value-type struct, do not store or cache it as it will not remain updated.
///
/// Instead, read endpoint arrays and individual endpoint properties from ``MIDIManager/endpoints``
/// ad-hoc when they are needed.
public struct MIDIOutputEndpoint: _MIDIEndpoint {
    // MARK: MIDIIOObject
    
    public let objectType: MIDIIOObjectType = .outputEndpoint
    
    public internal(set) var name: String = ""
    
    public internal(set) var uniqueID: MIDIIdentifier = .invalidMIDIIdentifier
    
    public let coreMIDIObjectRef: CoreMIDIEndpointRef
    
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        .outputEndpoint(self)
    }
    
    // MARK: MIDIEndpoint
    
    public internal(set) var displayName: String = ""
    
    public func asAnyEndpoint() -> AnyMIDIEndpoint {
        .init(self)
    }
    
    // MARK: Init
    
    init(from ref: CoreMIDIEndpointRef) {
        assert(
            ref != CoreMIDIEndpointRef(),
            "Encountered Core MIDI output endpoint ref value of 0 which is invalid."
        )
    
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

extension MIDIOutputEndpoint: Equatable {
    // default implementation provided in MIDIIOObject
}

extension MIDIOutputEndpoint: Hashable {
    // default implementation provided in MIDIIOObject
}

extension MIDIOutputEndpoint: Identifiable {
    // default implementation provided by MIDIIOObject
}

extension MIDIOutputEndpoint: Sendable { }

extension MIDIOutputEndpoint: CustomDebugStringConvertible {
    public var debugDescription: String {
        "MIDIOutputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
    }
}

#endif
