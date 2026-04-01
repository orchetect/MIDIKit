# ``MIDIKitSMF/MIDIFileTrackEvent``

Channel Voice and System Exclusive events are interchangeable between `MIDIEvent` and `MIDIFileTrackEvent`. A convenient API is provided to convert between them when it is appropriate:

Converting `MIDIFileTrackEvent` → <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent>:

- ``midiEvent()``

The remainder of `MIDIFileTrackEvent` event types are only relevant to MIDI files and have no MIDI I/O event equivalent.

For more information on <doc://MIDIKitSMF/MIDIKitCore/MIDIEvent>, refer to its documentation.

## Topics

### Track Head

- <doc:MIDIFileTrackEvent-PortPrefix>
- <doc:MIDIFileTrackEvent-ChannelPrefix>
- <doc:MIDIFileTrackEvent-SMPTEOffset>
- <doc:MIDIFileTrackEvent-SequenceNumber>

### Temporal

- <doc:MIDIFileTrackEvent-KeySignature>
- <doc:MIDIFileTrackEvent-TimeSignature>
- <doc:MIDIFileTrackEvent-Tempo>

### Channel Voice

- <doc:MIDIFileTrackEvent-NoteOn>
- <doc:MIDIFileTrackEvent-NoteOff>
- <doc:MIDIFileTrackEvent-NotePressure>
- <doc:MIDIFileTrackEvent-CC>
- <doc:MIDIFileTrackEvent-PitchBend>
- <doc:MIDIFileTrackEvent-Pressure>
- <doc:MIDIFileTrackEvent-ProgramChange>
- <doc:MIDIFileTrackEvent-RPN>
- <doc:MIDIFileTrackEvent-NRPN>

### System Exclusive

- <doc:MIDIFileTrackEvent-SysEx7>
- <doc:MIDIFileTrackEvent-UniversalSysEx7>

### Text

- <doc:MIDIFileTrackEvent-Text>

### Additional

- <doc:MIDIFileTrackEvent-SequencerSpecific>
- <doc:MIDIFileTrackEvent-XMFPatchTypePrefix>

### Orphan Events

- <doc:MIDIFileTrackEvent-UnrecognizedMeta>

### Wrapping Types

- ``MIDIFileTrackEvent/wrapped(delta:)``
- ``MIDIFileTrackEvent/unwrapped``

### Translation to MIDIEvent

- ``midiEvent()``
