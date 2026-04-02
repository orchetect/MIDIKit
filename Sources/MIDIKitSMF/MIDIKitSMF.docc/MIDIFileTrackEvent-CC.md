# CC (Control Change)

Channel Voice Message: Control Change (CC)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

## Topics

### Constructors

- ``MIDIFileTrackEvent/cc(controller:value:channel:)-(MIDIEvent.CC.Controller,_,_)``
- ``MIDIFileTrackEvent/cc(controller:value:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/cc(_:)``
- ``MIDIFileTrackEvent/CC``
