# ``MIDIKitSMF/MIDIFileEvent``

Channel Voice and System Exclusive events are interchangeable between `MIDIEvent` and `MIDIFileEvent`. A convenient API is provided to convert between them when it is appropriate:

Converting <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent> → `MIDIFileEvent`:

- ``MIDIKitSMF/MIDIKitCore/MIDIEvent/smfEvent(delta:)``

Converting `MIDIFileEvent` → <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent>:

- ``event()``

The remainder of `MIDIFileEvent` event types are only relevant to MIDI files and have no MIDI I/O event equivalent.

For more information on <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent>, refer to its documentation.

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

- <doc:MIDIFileEvent-SysEx7>
- <doc:MIDIFileEvent-UniversalSysEx7>

### Text

- <doc:MIDIFileEvent-Text>

### Additional

- <doc:MIDIFileEvent-SequencerSpecific>
- <doc:MIDIFileEvent-XMFPatchTypePrefix>

### Orphan Events

- <doc:MIDIFileEvent-UnrecognizedMeta>

### Translation between MIDIEvent

- ``event()``
- ``MIDIKitSMF/MIDIKitCore/MIDIEvent/smfEvent(delta:)``
