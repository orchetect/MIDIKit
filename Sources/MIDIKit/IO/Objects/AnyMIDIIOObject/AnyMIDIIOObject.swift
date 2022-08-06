//
//  AnyMIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

extension MIDI.IO {
    /// Type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public struct AnyMIDIIOObject: MIDIIOObjectProtocol {
        // MARK: MIDIIOObjectProtocol
        
        public let objectType: MIDI.IO.ObjectType
        
        public let name: String
        
        public let uniqueID: MIDI.IO.UniqueID
        
        public let coreMIDIObjectRef: MIDI.IO.ObjectRef
        
        // MARK: Init
        
        internal init<O: MIDIIOObjectProtocol>(_ base: O) {
            objectType = base.objectType
            name = base.name
            uniqueID = base.uniqueID
            
            coreMIDIObjectRef = base.coreMIDIObjectRef
        }
    }
}

extension MIDI.IO.AnyMIDIIOObject: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.AnyMIDIIOObject: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.AnyMIDIIOObject: Identifiable {
    public typealias ID = MIDI.IO.ObjectRef
    
    public var id: ID { coreMIDIObjectRef }
}

extension MIDIIOObjectProtocol {
    /// Return as `AnyMIDIIOObject`, a type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObject() -> MIDI.IO.AnyMIDIIOObject {
        .init(self)
    }
}

extension Collection where Element: MIDIIOObjectProtocol {
    /// Return as [`AnyMIDIIOObject`], type-erased representations of MIDIKit objects conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObjects() -> [MIDI.IO.AnyMIDIIOObject] {
        map { $0.asAnyMIDIIOObject() }
    }
}

#endif
