//
//  Entity.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Entity

extension MIDI.IO {
    
    /// A MIDI device, wrapping a CoreMIDI `MIDIEntityRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    public struct Entity: MIDIIOObjectProtocol {
        
        public static let objectType: MIDI.IO.ObjectType = .entity
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDIEntityRef
        
        // MARK: Init
        
        internal init(_ ref: MIDIEntityRef) {
            
            assert(ref != MIDIEntityRef())
            
            self.coreMIDIObjectRef = ref
            update()
            
        }
        
        // MARK: - Properties (Cached)
        
        /// User-visible endpoint name.
        /// (`kMIDIPropertyName`)
        public internal(set) var name: String = ""
        
        /// System-global Unique ID.
        /// (`kMIDIPropertyUniqueID`)
        public internal(set) var uniqueID: UniqueID = 0
        
        /// Update the cached properties
        internal mutating func update() {
            
            self.name = (try? MIDI.IO.getName(of: coreMIDIObjectRef)) ?? ""
            self.uniqueID = .init(MIDI.IO.getUniqueID(of: coreMIDIObjectRef))
            
        }
        
    }
    
}

extension MIDI.IO.Entity: Equatable {
    // default implementation is provided in MIDIIOObjectProtocol
}

extension MIDI.IO.Entity: Hashable {
    // default implementation is provided in MIDIIOObjectProtocol
}

extension MIDI.IO.Entity {
    
    public var device: MIDI.IO.Device? {
        
        try? MIDI.IO.getSystemDevice(for: coreMIDIObjectRef)
        
    }
    
    /// Returns the inputs for the entity.
    public var inputs: [MIDI.IO.InputEndpoint] {
        
        MIDI.IO.getSystemDestinations(for: coreMIDIObjectRef)
        
    }
    
    /// Returns the outputs for the entity.
    public var outputs: [MIDI.IO.OutputEndpoint] {
        
        MIDI.IO.getSystemSources(for: coreMIDIObjectRef)
        
    }
    
}

extension MIDI.IO.Entity {
    
    /// Returns `true` if the object exists in the system by querying CoreMIDI.
    public var exists: Bool {
        
        device != nil
        
    }
    
}

extension MIDI.IO.Entity: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "Entity(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
    }
    
}
