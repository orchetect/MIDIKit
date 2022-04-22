//
//  InputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - InputEndpoint

extension MIDI.IO {
    
    /// A MIDI input endpoint in the system, wrapping a Core MIDI `MIDIEndpointRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
    public struct InputEndpoint: _MIDIIOEndpointProtocol {
        
        public var objectType: MIDI.IO.ObjectType { .inputEndpoint }
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDI.IO.CoreMIDIEndpointRef
        
        // MARK: Init
        
        internal init(_ ref: MIDI.IO.CoreMIDIEndpointRef) {
            
            assert(ref != MIDI.IO.CoreMIDIEndpointRef(),
                   "Encountered Core MIDI input endpoint ref value of 0 which is invalid.")
            
            self.coreMIDIObjectRef = ref
            update()
            
        }
        
        // MARK: - Properties (Cached)
        
        public internal(set) var name: String = ""
        
        public internal(set) var displayName: String = ""
        
        public internal(set) var uniqueID: UniqueID = 0
        
        /// Update the cached properties
        internal mutating func update() {
            
            self.name = getName() ?? ""
            self.displayName = getDisplayName() ?? ""
            self.uniqueID = getUniqueID()
            
        }
        
    }
    
}

extension MIDI.IO.InputEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.InputEndpoint: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        "InputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID))"
        
    }
    
}
