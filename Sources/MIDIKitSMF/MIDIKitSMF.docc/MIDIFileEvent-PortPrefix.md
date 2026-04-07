# Port Prefix

MIDI Port Prefix event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.

The data byte is the port number, where 0 would be the first MIDI buss in the system.

## Topics

### Constructors

- ``MIDIFileEvent/portPrefix(port:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/portPrefix(_:)``
- ``MIDIFileEvent/PortPrefix``
