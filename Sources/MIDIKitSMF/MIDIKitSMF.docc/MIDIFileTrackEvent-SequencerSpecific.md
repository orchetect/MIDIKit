# Sequencer Specific

Sequencer-specific data.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.

## Topics

### Constructors

- ``MIDIFileTrackEvent/sequencerSpecific(data:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/sequencerSpecific(_:)``
- ``MIDIFileTrackEvent/SequencerSpecific``
