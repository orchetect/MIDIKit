# Note Off

Channel Voice Message: Note Off

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

- ``MIDIFileEvent/noteOff(delta:note:velocity:channel:)-(_,MIDINote,_,_)``
- ``MIDIFileEvent/noteOff(delta:note:velocity:channel:)-(_,UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/noteOff(delta:event:)``
- ``MIDIFileEvent/NoteOff``
