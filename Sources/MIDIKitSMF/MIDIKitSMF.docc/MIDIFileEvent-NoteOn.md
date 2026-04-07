# Note On

Channel Voice Message: Note On

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

- ``MIDIFileEvent/noteOn(note:velocity:channel:)-(MIDINote,_,_)``
- ``MIDIFileEvent/noteOn(note:velocity:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/noteOn(_:)``
- ``MIDIFileEvent/NoteOn``
