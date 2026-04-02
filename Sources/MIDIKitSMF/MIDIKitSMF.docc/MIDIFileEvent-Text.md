# Text

Text event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Includes copyright, marker, cue point, track/sequence name, instrument name, generic text, program name, device name, or lyric.

Text is restricted to ASCII format only. If extended characters or encodings are used, it will be converted to ASCII lossily before encoding into the MIDI file.

## Topics

### Constructors

- ``MIDIFileEvent/text(type:string:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/text(_:)``
- ``MIDIFileEvent/Text``
