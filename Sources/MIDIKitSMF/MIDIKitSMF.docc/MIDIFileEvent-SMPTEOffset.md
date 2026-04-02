# SMPTE Offset

Specify the SMPTE time at which the track is to start.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

This optional event, if present, should occur at the start of a track, at `time == 0`, and prior to any MIDI events.

Defaults to `00:00:00:00 @ 24fps`.

> Standard MIDI File 1.0 Spec:
>
> MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in SMPTE-based tracks which specify a different frame subdivision for delta-times.

## Timecode

For documentation on the `Timecode` type, see swift-timecode documentation.

## Topics

### Constructors

- ``MIDIFileEvent/smpteOffset(hr:min:sec:fr:subFr:rate:)``
- ``MIDIFileEvent/smpteOffset(scaling:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/smpteOffset(_:)``
- ``MIDIFileEvent/SMPTEOffset``
