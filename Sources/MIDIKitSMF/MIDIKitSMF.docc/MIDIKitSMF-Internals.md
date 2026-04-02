# Internals

## Topics

### Chunk Identifiers

- ``AnyMIDI1FileChunkIdentifier``
- ``HeaderMIDI1FileChunkIdentifier``
- ``TrackMIDI1FileChunkIdentifier``
- ``UndefinedMIDI1FileChunkIdentifier``

### Type-Erasure

- ``AnyMIDI1File``
- ``AnyMIDI1FileHeaderChunk``
- ``AnyMIDIFileTimebase``
- ``AnyMIDIFileTrackDeltaTime``
- ``AnyMIDIFileTrackEventDecodeResult``
- ``MIDIFileTrackEvent/AnyTempo``

### MIDI File Decoding

- ``MIDIFileTrackEventDecodeResult``

### Protocols

- ``MIDI1FileChunk``
- ``MIDI1FileChunkIdentifier``
- ``MIDIFileTimebase``
- ``MIDIFileTrackDeltaTime``
- ``MIDIFileTrackEventPayload``

### Timecode Related

- ``MIDI1FileFrameRate``
- ``SwiftTimecodeCore/Timecode/scaledToMIDIFileSMPTEFrameRate``
- ``SwiftTimecodeCore/TimecodeFrameRate/midiFileSMPTEFrameRate``
