# Key Signature

Key Signature event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Key Signature Meta events should only occur within the first `MTrk` chunk.

If there are no key signature events in a MIDI file, C major is assumed.

## Topics

### Constructors

- ``MIDIFileEvent/keySignature(delta:flatsOrSharps:majorKey:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/keySignature(delta:event:)``
- ``MIDIFileEvent/KeySignature``
