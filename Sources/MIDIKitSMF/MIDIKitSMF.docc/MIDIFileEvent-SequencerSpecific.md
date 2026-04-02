# Sequencer Specific

Sequencer-specific data.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.

## Topics

### Constructors

- ``MIDIFileEvent/sequencerSpecific(data:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/sequencerSpecific(_:)``
- ``MIDIFileEvent/SequencerSpecific``
