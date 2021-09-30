//
//  MIDIIOObjectProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public protocol MIDIIOObjectProtocol {
    
    /// Enum describing the abstracted object type.
    var objectType: MIDI.IO.ObjectType { get }
    
    /// Name of the object
    var name: String { get }
    
    associatedtype UniqueID: MIDIIOUniqueIDProtocol
    
    /// The unique ID for the Core MIDI object
    var uniqueID: UniqueID { get }
    
}

internal protocol _MIDIIOObjectProtocol: MIDIIOObjectProtocol {
    
    /// The Core MIDI object reference
    var coreMIDIObjectRef: MIDI.IO.CoreMIDIObjectRef { get }
    
}
