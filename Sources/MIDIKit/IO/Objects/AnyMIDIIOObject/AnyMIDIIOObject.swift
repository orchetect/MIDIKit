//
//  AnyMIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public struct AnyMIDIIOObject: MIDIIOObjectProtocol {
        
        // MARK: MIDIIOObjectProtocol
        
        public let objectType: MIDI.IO.ObjectType
        
        public let name: String
        
        public typealias UniqueID = MIDI.IO.AnyUniqueID
        public let uniqueID: MIDI.IO.AnyUniqueID
        
        public let coreMIDIObjectRef: MIDI.IO.CoreMIDIObjectRef
        
        // MARK: Init
        
        internal init<O: MIDIIOObjectProtocol>(_ base: O) {
            
            self.objectType = base.objectType
            self.name = base.name
            self.uniqueID = base.uniqueID.asAnyUniqueID
            
            self.coreMIDIObjectRef = base.coreMIDIObjectRef
            
        }
        
    }
    
}

extension MIDIIOObjectProtocol {
    
    /// Return as `AnyMIDIIOObject`, a type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObject() -> MIDI.IO.AnyMIDIIOObject {
        
        .init(self)
        
    }
    
}

extension Collection where Element : MIDIIOObjectProtocol {
    
    /// Return as [`AnyMIDIIOObject`], type-erased representations of MIDIKit objects conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObjects() -> [MIDI.IO.AnyMIDIIOObject] {
        
        map { $0.asAnyMIDIIOObject() }
        
    }
    
}
