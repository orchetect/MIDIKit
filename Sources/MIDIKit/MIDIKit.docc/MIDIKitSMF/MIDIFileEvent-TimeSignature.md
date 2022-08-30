# Time Signature

Time Signature event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Time Signature meta events should only occur within the first `MTrk` chunk.

If there are no Time Signature events in a MIDI file, 4/4 is assumed.

## Topics

### Constructors

- ``MIDIFileEvent/timeSignature(delta:numerator:denominator:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/timeSignature(delta:event:)``
- ``MIDIFileEvent/TimeSignature``
