# ``MIDIKitSMF/MIDIFileEvent``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

Channel Voice and System Exclusive events are interchangeable between ``MIDIEvent`` and ``MIDIFileEvent``. A convenient API is provided to convert between them when it is appropriate:

- term ``MIDIEvent`` → ``MIDIFileEvent``: ``MIDIEvent/smfEvent(delta:)``
- term ``MIDIFileEvent`` → ``MIDIEvent``: ``MIDIFileEvent/event()``

The remainder of ``MIDIFileEvent`` event types are only relevante to MIDI files and have no MIDI I/O event equivalent.

For more information on ``MIDIEvent``, refer to MIDIKit's own documentation.

## Topics

### MIDI Track Leading

- <doc:MIDIFileEvent-PortPrefix>
- <doc:MIDIFileEvent-ChannelPrefix>
- <doc:MIDIFileEvent-SMPTEOffset>
- <doc:MIDIFileEvent-SequenceNumber>

### Temporal

- <doc:MIDIFileEvent-KeySignature>
- <doc:MIDIFileEvent-TimeSignature>
- <doc:MIDIFileEvent-Tempo>

### Channel Voice

- <doc:MIDIFileEvent-NoteOn>
- <doc:MIDIFileEvent-NoteOff>
- <doc:MIDIFileEvent-NotePressure>
- <doc:MIDIFileEvent-CC>
- <doc:MIDIFileEvent-PitchBend>
- <doc:MIDIFileEvent-Pressure>
- <doc:MIDIFileEvent-ProgramChange>

### System Exclusive

- <doc:MIDIFileEvent-SysEx>
- <doc:MIDIFileEvent-UniversalSysEx>

### Text

- <doc:MIDIFileEvent-Text>

### Additional

- <doc:MIDIFileEvent-SequencerSpecific>
- <doc:MIDIFileEvent-XMFPatchTypePrefix>

### Orphan Events

- <doc:MIDIFileEvent-UnrecognizedMeta>

### Translation between MIDIKit.MIDIEvent

- ``event()``
- ``MIDIEvent/smfEvent(delta:)``
