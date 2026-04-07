# Note Pressure (Poly Aftertouch)

Channel Voice Message: Note Pressure (Polyphonic Aftertouch)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
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

- ``MIDIFileEvent/notePressure(note:amount:channel:)-(MIDINote,_,_)``
- ``MIDIFileEvent/notePressure(note:amount:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/notePressure(_:)``
- ``MIDIFileEvent/NotePressure``
