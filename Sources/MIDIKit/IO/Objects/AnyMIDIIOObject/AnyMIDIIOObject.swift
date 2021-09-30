//
//  AnyMIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public struct AnyMIDIIOObject: _MIDIIOObjectProtocol {
        
        // MIDIIOObjectProtocol
        public let objectType: MIDI.IO.ObjectType
        public let name: String
        public typealias UniqueID = MIDI.IO.AnyUniqueID
        public let uniqueID: MIDI.IO.AnyUniqueID
        
        // _MIDIIOObjectProtocol
        var coreMIDIObjectRef: MIDI.IO.CoreMIDIObjectRef
        
        internal init<T: _MIDIIOObjectProtocol>(_ base: T) {
            
            self.objectType = base.objectType
            self.name = base.name
            self.uniqueID = base.uniqueID.asAnyUniqueID
            
            self.coreMIDIObjectRef = base.coreMIDIObjectRef
            
        }
        
    }
    
}

extension _MIDIIOObjectProtocol {
    
    /// Return as `AnyMIDIIOObject`, a type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObject() -> MIDI.IO.AnyMIDIIOObject {
        
        .init(self)
        
    }
    
}
