# Tempo

Tempo event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.

If there are no tempo events in a MIDI file, 120 bpm is assumed.

## Topics

### Constructors

- ``MIDIFileEvent/tempo(bpm:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/tempo(_:)``
- ``MIDIFileEvent/AnyTempo``

### Specialized Concrete Types

- ``MIDIFileEvent/MusicalTempo``
- ``MIDIFileEvent/SMPTETempo``

### Protocol

- ``MIDIFileEvent/Tempo``
