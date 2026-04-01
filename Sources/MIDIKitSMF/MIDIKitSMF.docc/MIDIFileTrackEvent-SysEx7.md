# System Exclusive 7

System Exclusive: Manufacturer-specific (7-bit)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileTrackEvent/sysEx7(manufacturer:data:)-(_,[UInt8])``
- ``MIDIFileTrackEvent/sysEx7(manufacturer:data:)-(_,[UInt7])``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/sysEx7(_:)``
- ``MIDIFileTrackEvent/SysEx7``
