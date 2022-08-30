# Unrecognized Meta

Unrecognized Meta Event

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

> Note: This is not designed to be instanced, but is instead a placeholder for unrecognized or malformed data while parsing the contents of a MIDI file. In then allows for manual parsing or introspection of the unrecognized data.

> Standard MIDI File 1.0 Spec:
>
> All meta-events begin with `0xFF`, then have an event type byte (which is always less than 128), and then have the length of the data stored as a variable-length quantity, and then the data itself. If there is no data, the length is `0`. As with chunks, future meta-events may be designed which may not be known to existing programs, so programs must properly ignore meta-events which they do not recognize, and indeed, should expect to see them. Programs must never ignore the length of a meta-event which they do recognize, and they shouldn't be surprised if it's bigger than they expected. If so, they must ignore everything past what they know about. However, they must not add anything of their own to the end of a meta-event.
>
> SysEx events and meta-events cancel any running status which was in effect. Running status does not apply to and may not be used for these messages.

## Topics

### Constructors

- ``MIDIFileEvent/unrecognizedMeta(delta:metaType:data:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/unrecognizedMeta(delta:event:)``
- ``MIDIFileEvent/UnrecognizedMeta``
