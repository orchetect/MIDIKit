# Pressure (Channel Aftertouch)

Channel Voice Message: Channel Pressure (Aftertouch)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Also known as:
- Pro Tools: "Mono Aftertouch"
- Logic Pro: "Aftertouch"
- Cubase: "Aftertouch"

## Topics

### Constructors

- ``MIDIFileEvent/pressure(delta:amount:channel:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/pressure(delta:event:)``
- ``MIDIFileEvent/Pressure``
