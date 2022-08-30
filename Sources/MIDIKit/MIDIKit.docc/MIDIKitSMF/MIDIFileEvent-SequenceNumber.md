# Sequence Number

Sequence Number event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

- For MIDI file type 0/1, this should only be on the first track. This is used to identify each track. If omitted, the sequences are numbered sequentially in the order the tracks appear.

- For MIDI file type 2, each track can contain a sequence number event.

## Topics

### Constructors

- ``MIDIFileEvent/sequenceNumber(delta:sequence:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/sequenceNumber(delta:event:)``
- ``MIDIFileEvent/SequenceNumber``
