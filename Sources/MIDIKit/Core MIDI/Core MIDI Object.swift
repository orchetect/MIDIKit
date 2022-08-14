//
//  Core MIDI Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

/// Internal:
/// Retrieves the object type for the given Core MIDI unique ID.
/// Returns nil if no object exists with the given ID.
internal func getSystemObjectType(
    of uniqueID: CoreMIDI.MIDIUniqueID
) -> CoreMIDI.MIDIObjectType? {
    var obj: CoreMIDI.MIDIObjectRef = .init()
    var objType: CoreMIDI.MIDIObjectType = .other
        
    let result = MIDIObjectFindByUniqueID(
        uniqueID,
        &obj,
        &objType
    )
        
    guard result != kMIDIObjectNotFound else { return nil }
        
    return objType
}

#endif
