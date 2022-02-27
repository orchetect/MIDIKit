//
//  OutputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - OutputEndpoint

extension MIDI.IO {
    
    /// A MIDI output endpoint in the system, wrapping a Core MIDI `MIDIEndpointRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
    public struct OutputEndpoint: _MIDIIOEndpointProtocol {
        
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
            self.uniqueID = .init(MIDI.IO.getUniqueID(of: coreMIDIObjectRef))
            
        }
        
    }
    
}

extension MIDI.IO.OutputEndpoint: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.OutputEndpoint {
    
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        
        MIDI.IO.getSystemSourceEndpoint(matching: uniqueID.coreMIDIUniqueID) != nil
        
    }
    
}

extension MIDI.IO.OutputEndpoint: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        "OutputEndpoint(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
        
    }
    
}

// MARK: - Static conveniences

extension Set where Element == MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint> {
    
    /// Returns the current output endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemSourceEndpoints.map { .uniqueID($0.uniqueID) })
        
    }
    
}

extension Array where Element == MIDI.IO.EndpointIDCriteria<MIDI.IO.OutputEndpoint> {
    
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemSourceEndpoints.map { .uniqueID($0.uniqueID) }
        
    }
    
}

extension Set where Element == MIDI.IO.OutputEndpoint {
    
    /// Returns the current output endpoints in the system.
    public static func current() -> Self {
        
        Set(MIDI.IO.getSystemSourceEndpoints)
        
    }
    
}

extension Array where Element == MIDI.IO.OutputEndpoint {
    
    /// Returns the current output endpoints in the system.
    @_disfavoredOverload
    public static func current() -> Self {
        
        MIDI.IO.getSystemSourceEndpoints
        
    }
    
}
