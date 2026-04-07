# NRPN (Non-Registered Parameter Number)

Channel Voice Message: Non-Registered Parameter Number, also referred to as Assignable Controller in MIDI 2.0.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileEvent/nrpn(parameter:change:channel:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/nrpn(_:)``
- ``MIDIFileEvent/NRPN``
