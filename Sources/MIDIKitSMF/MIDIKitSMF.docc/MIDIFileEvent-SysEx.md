# System Exclusive

System Exclusive: Manufacturer-specific (7-bit)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileEvent/sysEx(delta:manufacturer:data:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/sysEx(delta:event:)``
- ``MIDIFileEvent/SysEx``
