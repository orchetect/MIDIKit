# Note Pressure (Poly Aftertouch)

Channel Voice Message: Note Pressure (Polyphonic Aftertouch)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Also known as:
- Pro Tools: "Polyphonic Aftertouch"
- Logic Pro: "Polyphonic Aftertouch"
- Cubase: "Poly Pressure"

## Topics

### Constructors

- ``MIDIFileEvent/notePressure(delta:note:amount:channel:)-(_,MIDINote,_,_)``
- ``MIDIFileEvent/notePressure(delta:note:amount:channel:)-(_,UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/notePressure(delta:event:)``
- ``MIDIFileEvent/NotePressure``
