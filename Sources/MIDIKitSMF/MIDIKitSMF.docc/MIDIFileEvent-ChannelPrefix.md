# Channel Prefix

MIDI Channel Prefix event.

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
> The MIDI channel (`0 ... 15`) contained in this event may be used to associate a MIDI channel with all events which follow, including System Exclusive and meta-events. This channel is "effective" until the next normal MIDI event (which contains a channel) or the next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may help jam several tracks into a format 0 file, keeping their non-MIDI data associated with a track. This capability is also present in Yamaha's ESEQ file format.

## Topics

### Constructors

- ``MIDIFileEvent/channelPrefix(delta:channel:)``

### Switch Case Unwrapping

- ``MIDIFileEvent/channelPrefix(delta:event:)``
- ``MIDIFileEvent/ChannelPrefix``
