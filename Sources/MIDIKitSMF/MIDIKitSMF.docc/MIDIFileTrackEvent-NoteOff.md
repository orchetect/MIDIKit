# Note Off

Channel Voice Message: Note Off

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

- ``MIDIFileTrackEvent/noteOff(note:velocity:channel:)-(MIDINote,_,_)``
- ``MIDIFileTrackEvent/noteOff(note:velocity:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/noteOff(_:)``
- ``MIDIFileTrackEvent/NoteOff``
