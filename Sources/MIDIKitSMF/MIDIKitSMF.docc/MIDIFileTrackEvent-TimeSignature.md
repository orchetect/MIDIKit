# Time Signature

Time Signature event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Time Signature meta events should only occur within the first `MTrk` chunk.

If there are no Time Signature events in a MIDI file, 4/4 is assumed.

## Topics

### Constructors

- ``MIDIFileTrackEvent/timeSignature(numerator:denominator:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/timeSignature(_:)``
- ``MIDIFileTrackEvent/TimeSignature``
