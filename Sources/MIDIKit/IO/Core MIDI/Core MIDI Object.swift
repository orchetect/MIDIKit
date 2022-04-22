//
//  Core MIDI Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Internal:
    /// Retrieves the object type for the given Core MIDI unique ID.
    /// Returns nil if no object exists with the given ID.
    internal static func getSystemObjectType(of uniqueID: MIDIUniqueID) -> MIDIObjectType? {
        
        var obj: MIDIObjectRef = .init()
        var objType: MIDIObjectType = .other
        
        let result = MIDIObjectFindByUniqueID(uniqueID,
                                              &obj,
                                              &objType)
        
        guard result != kMIDIObjectNotFound else { return nil }
        
        return objType
        
    }
    
}
