//
//  Entity.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Entity

extension MIDI.IO {
    
    /// A MIDI device, wrapping `MIDIEntityRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    public struct Entity: Object {
        
        public static let objectType: MIDI.IO.ObjectType = .entity
        
        // MARK: CoreMIDI ref
        
        public let ref: MIDIEntityRef
        
        // MARK: Identifiable
        
        public var id = UUID()
        
        // MARK: Init
        
        internal init(_ ref: MIDIEntityRef) {
            
            assert(ref != MIDIEntityRef())
            
            self.ref = ref
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
            
            self.name = (try? MIDI.IO.getName(of: ref)) ?? ""
            self.uniqueID = MIDI.IO.getUniqueID(of: ref)
            
        }
        
    }
    
}

extension MIDI.IO.Entity {
    
    public var device: MIDI.IO.Device? {
        
        try? MIDI.IO.getSystemDevice(for: ref)
        
    }
    
    /// Returns the inputs for the entity.
    public var inputs: [MIDI.IO.InputEndpoint] {
        
        MIDI.IO.getSystemDestinations(for: ref)
        
    }
    
    /// Returns the outputs for the entity.
    public var outputs: [MIDI.IO.OutputEndpoint] {
        
        MIDI.IO.getSystemSources(for: ref)
        
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
