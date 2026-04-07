# CC (Control Change)

Channel Voice Message: Control Change (CC)

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

- ``MIDIFileEvent/cc(controller:value:channel:)-(MIDIEvent.CC.Controller,_,_)``
- ``MIDIFileEvent/cc(controller:value:channel:)-(UInt7,_,_)``

### Switch Case Unwrapping

- ``MIDIFileEvent/cc(_:)``
- ``MIDIFileEvent/CC``
