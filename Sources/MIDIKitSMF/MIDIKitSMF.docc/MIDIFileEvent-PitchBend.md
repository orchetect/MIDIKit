# Pitch Bend

Channel Voice Message: Pitch Bend

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileEvent/pitchBend(delta:value:channel:)``
- ``MIDIFileEvent/pitchBend(delta:lsb:msb:channel:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/pitchBend(delta:event:)``
- ``MIDIFileEvent/PitchBend``
