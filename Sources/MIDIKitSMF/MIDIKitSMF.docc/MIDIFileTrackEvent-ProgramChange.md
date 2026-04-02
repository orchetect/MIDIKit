# Program Change

Channel Voice Message: Program Change

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

> Note: When decoding, bank information is not decoded as part of the Program Change event but will be decoded as individual CC messages. This may be addressed in a future release of MIDIKit.

## Topics

### Constructors

- ``MIDIFileTrackEvent/programChange(program:channel:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/programChange(_:)``
- ``MIDIFileTrackEvent/ProgramChange``
