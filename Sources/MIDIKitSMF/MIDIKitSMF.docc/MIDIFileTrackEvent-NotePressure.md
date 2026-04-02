# Note Pressure (Poly Aftertouch)

Channel Voice Message: Note Pressure (Polyphonic Aftertouch)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

Also known as:
- Pro Tools: "Polyphonic Aftertouch"
- Logic Pro: "Polyphonic Aftertouch"
- Cubase: "Poly Pressure"

## Topics

### Constructors

- ``MIDIFileTrackEvent/notePressure(note:amount:channel:)-(MIDINote,_,_)``
- ``MIDIFileTrackEvent/notePressure(note:amount:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/notePressure(_:)``
- ``MIDIFileTrackEvent/NotePressure``
