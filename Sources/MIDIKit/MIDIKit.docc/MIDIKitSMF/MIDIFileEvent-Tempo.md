# Tempo

Tempo event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.

If there are no tempo events in a MIDI file, 120 bpm is assumed.

## Topics

### Constructors

- ``MIDIFileEvent/tempo(delta:bpm:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/tempo(delta:event:)``
- ``MIDIFileEvent/Tempo``
