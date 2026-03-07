//
//  Core MIDI Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

internal import CoreMIDI

// TODO: This method works, but is not currently being used.

/// Internal:
/// Retrieves the object type for the given Core MIDI unique ID.
func getSystemObjectType(
    ofUniqueID uniqueID: CoreMIDI.MIDIUniqueID
) throws(MIDIIOError) -> CoreMIDI.MIDIObjectType {
    let objPtr: UnsafeMutablePointer<MIDIObjectRef>? = nil
    let objTypePtr: UnsafeMutablePointer<MIDIObjectType>? = nil
    
    try MIDIObjectFindByUniqueID(
        uniqueID,
        objPtr,
        objTypePtr
    )
    .throwIfOSStatusErr()
    
    // discard the object ref, as we don't need it - we only care about the object type.
    
    guard let objTypePtr else { throw .osStatus(.objectNotFound) }
    let objType = objTypePtr.pointee
    
    return objType
}

#endif
