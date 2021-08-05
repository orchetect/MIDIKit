//
//  OutputEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - OutputEndpoint

extension MIDI.IO {
    
    /// A MIDI output endpoint in the system, wrapping a CoreMIDI `MIDIEndpointRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read endpoint arrays and individual endpoint properties from `MIDI.IO.Manager.endpoints` ad-hoc when they are needed.
    public struct OutputEndpoint: MIDIIOEndpointProtocol {
        
        // MARK: CoreMIDI ref
        
        public let coreMIDIObjectRef: MIDIEndpointRef
        
        // MARK: Init
        
        internal init(_ ref: MIDIEndpointRef) {
            
            assert(ref != MIDIEndpointRef())
            
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
    
    /// Returns `true` if the object exists in the system by querying CoreMIDI.
    public var exists: Bool {
        
        MIDI.IO.getSystemSourceEndpoint(matching: uniqueID.coreMIDIUniqueID) != nil
        
    }
    
}

extension MIDI.IO.OutputEndpoint {
    
    /// Returns the endpoint as a type-erased `AnyEndpoint`.
    public var asAnyEndpoint: MIDI.IO.AnyEndpoint {
        .init(self)
    }
    
}

extension MIDI.IO.OutputEndpoint: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "OutputEndpoint(name: \(name.otcQuoted), uniqueID: \(uniqueID), exists: \(exists)"
    }
    
}
