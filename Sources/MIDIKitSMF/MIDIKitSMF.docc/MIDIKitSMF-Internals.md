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
- ``AnyMIDIFileEventDecodeResult``
- ``MIDIFileEvent/AnyTempo``

### MIDI File Decoding

- ``MIDIFileEventDecodeResult``

### Protocols

- ``MIDI1FileChunk``
- ``MIDI1FileChunkIdentifier``
- ``MIDIFileTimebase``
- ``MIDIFileTrackDeltaTime``
- ``MIDIFileEventPayload``

### Timecode Related

- ``MIDI1FileFrameRate``
- ``SwiftTimecodeCore/Timecode/scaledToMIDIFileSMPTEFrameRate``
- ``SwiftTimecodeCore/TimecodeFrameRate/midiFileSMPTEFrameRate``
