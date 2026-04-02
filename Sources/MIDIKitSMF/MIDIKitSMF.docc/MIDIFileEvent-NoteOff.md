# Note Off

Channel Voice Message: Note Off

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

- ``MIDIFileEvent/noteOff(note:velocity:channel:)-(MIDINote,_,_)``
- ``MIDIFileEvent/noteOff(note:velocity:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/noteOff(_:)``
- ``MIDIFileEvent/NoteOff``
