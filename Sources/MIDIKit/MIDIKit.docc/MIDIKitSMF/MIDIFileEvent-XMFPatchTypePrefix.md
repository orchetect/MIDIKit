# XMF Patch Type Prefix

XMF Patch Type Prefix event.

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

> Standard MIDI File 1.0 Spec:
>
> XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF files may be designated to use either standard General MIDI 1 or General MIDI 2 instruments supplied by the player, or custom DLS instruments supplied via the XMF file. This document defines a new SMF Meta-Event to be used for this purpose.
>
> In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent Program Change and Bank Select messages appearing in the same SMF Track: as General MIDI 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix Meta-Event, General MIDI 1 (instrument set and system behavior) is chosen by default.
>
> In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if it appears as the first message in an SMF Track; if it appears anywhere else in an SMF Track, it must be ignored.
>
> See [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).

## Topics

### Constructors

- ``MIDIFileEvent/xmfPatchTypePrefix(delta:patchSet:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/xmfPatchTypePrefix(delta:event:)``
- ``MIDIFileEvent/XMFPatchTypePrefix``
