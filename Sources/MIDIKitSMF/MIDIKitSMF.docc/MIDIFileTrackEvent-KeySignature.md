# Key Signature

Key Signature event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Key Signature Meta events should only occur within the first `MTrk` chunk.

If there are no key signature events in a MIDI file, C major is assumed.

## Topics

### Constructors

- ``MIDIFileTrackEvent/keySignature(flatsOrSharps:isMajor:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/keySignature(_:)``
- ``MIDIFileTrackEvent/KeySignature``
