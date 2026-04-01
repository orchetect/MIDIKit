# Port Prefix

MIDI Port Prefix event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileTrackEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.

The data byte is the port number, where 0 would be the first MIDI buss in the system.

## Topics

### Constructors

- ``MIDIFileTrackEvent/portPrefix(port:)``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/portPrefix(_:)``
- ``MIDIFileTrackEvent/PortPrefix``
