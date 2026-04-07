# System Exclusive 7

System Exclusive: Manufacturer-specific (7-bit)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileEvent/sysEx7(manufacturer:data:)-(_,[UInt8])``
- ``MIDIFileEvent/sysEx7(manufacturer:data:)-(_,[UInt7])``

### Switch Case Unwrapping

- ``MIDIFileEvent/sysEx7(_:)``
- ``MIDIFileEvent/SysEx7``
