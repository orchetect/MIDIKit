//
//  Core MIDI Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

internal import CoreMIDI

/// Internal:
/// Retrieves the object type for the given Core MIDI unique ID.
/// Returns nil if no object exists with the given ID.
func getSystemObjectType( // TODO: convert to throwing method instead of Optional
    of uniqueID: CoreMIDI.MIDIUniqueID
) -> CoreMIDI.MIDIObjectType? {
    var obj: CoreMIDI.MIDIObjectRef = .init()
    var objType: CoreMIDI.MIDIObjectType = .other
    
    do {
        try MIDIObjectFindByUniqueID(
            uniqueID,
            &obj,
            &objType
        )
        .throwIfOSStatusErr()
        
        return objType
    } catch {
        return nil
    }
}

#endif
