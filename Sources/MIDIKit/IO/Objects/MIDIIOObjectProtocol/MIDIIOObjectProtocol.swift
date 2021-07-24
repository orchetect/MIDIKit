//
//  MIDIIOObjectProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

public protocol MIDIIOObjectProtocol {
    
    /// Enum describing the abstracted object type.
    static var objectType: MIDI.IO.ObjectType { get }
    
    /// The CoreMIDI object reference (integer)
    var coreMIDIObjectRef: MIDIObjectRef { get }
    
    /// Name of the object
    var name: String { get }
    
    associatedtype UniqueID: MIDIIOUniqueIDProtocol
    
    /// The unique ID for the CoreMIDI object
    var uniqueID: UniqueID { get }
    
}
