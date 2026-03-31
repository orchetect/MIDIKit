# Pitch Bend

Channel Voice Message: Pitch Bend

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

- ``MIDIFileTrackEvent/pitchBend(value:channel:)``
- ``MIDIFileTrackEvent/pitchBend(lsb:msb:channel:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/pitchBend(_:)``
- ``MIDIFileTrackEvent/PitchBend``
