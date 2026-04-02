# Tempo

Tempo event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.

If there are no tempo events in a MIDI file, 120 bpm is assumed.

## Topics

### Constructors

- ``MIDIFileTrackEvent/tempo(bpm:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/tempo(_:)``
- ``MIDIFileTrackEvent/AnyTempo``

### Specialized Concrete Types

- ``MIDIFileTrackEvent/MusicalTempo``
- ``MIDIFileTrackEvent/SMPTETempo``

### Protocol

- ``MIDIFileTrackEvent/Tempo``
