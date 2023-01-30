# System Exclusive 7

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

- ``MIDIFileEvent/sysEx7(delta:manufacturer:data:)-6xiv7``
- ``MIDIFileEvent/sysEx7(delta:manufacturer:data:)-oc22``

### Switch Case Unwrapping

- ``MIDIFileEvent/sysEx7(delta:event:)``
- ``MIDIFileEvent/SysEx7``
