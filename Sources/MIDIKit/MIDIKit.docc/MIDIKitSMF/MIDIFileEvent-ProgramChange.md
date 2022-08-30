# Program Change

Channel Voice Message: Program Change

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

> Note: When decoding, bank information is not decoded as part of the Program Change event but will be decoded as individual CC messages. This may be addressed in a future release of MIDIKit.

## Topics

### Constructors

- ``MIDIFileEvent/programChange(delta:program:channel:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/programChange(delta:event:)``
- ``MIDIFileEvent/ProgramChange``
