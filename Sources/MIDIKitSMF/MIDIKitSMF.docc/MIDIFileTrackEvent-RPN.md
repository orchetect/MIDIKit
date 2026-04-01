# RPN (Registered Parameter Number)

Channel Voice Message: Registered Parameter Number, also referred to as Registered Controller in MIDI 2.0.

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

- ``MIDIFileTrackEvent/rpn(parameter:change:channel:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/rpn(_:)``
- ``MIDIFileTrackEvent/RPN``
