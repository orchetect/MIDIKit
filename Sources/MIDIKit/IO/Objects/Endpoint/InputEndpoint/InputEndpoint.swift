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
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDI.IO.CoreMIDIEndpointRef
        
        // MARK: Init
        
        internal init(_ ref: MIDI.IO.CoreMIDIEndpointRef) {
            
            assert(ref != MIDI.IO.CoreMIDIEndpointRef())
            
            self.coreMIDIObjectRef = ref
            update()
            
        }
        
        // MARK: - Properties (Cached)
        
        public internal(set) var name: String = ""
        
        public internal(set) var uniqueID: UniqueID = 0
        
        /// Update the cached properties
        internal mutating func update() {
            
            self.name = (try? MIDI.IO.getName(of: coreMIDIObjectRef)) ?? ""
            self.uniqueID = UniqueID(MIDI.IO.getUniqueID(of: coreMIDIObjectRef))
            
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

extension MIDI.IO.InputEndpoint {
    
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        
        MIDI.IO.getSystemDestinationEndpoint(matching: uniqueID.coreMIDIUniqueID) != nil
        
    }
    
}

extension MIDI.IO.InputEndpoint: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        "InputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
        
    }
    
}

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.InputEndpointIDCriteria {
    
    /// Returns the current input endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemDestinationEndpoints.map { .uniqueID($0.uniqueID) })
        
    }
    
}

extension Array where Element == MIDI.IO.InputEndpointIDCriteria {
    
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemDestinationEndpoints.map { .uniqueID($0.uniqueID) }
        
    }
    
}

extension Set where Element == MIDI.IO.InputEndpoint {
    
    /// Returns the current input endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemDestinationEndpoints)
        
    }
    
}

extension Array where Element == MIDI.IO.InputEndpoint {
    
    /// Returns the current input endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemDestinationEndpoints
        
    }
    
}
