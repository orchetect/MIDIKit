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
- ``AnyMIDIFileDeltaTime``
- ``AnyMIDIFileEventDecodeResult``
- ``MIDIFileEvent/AnyTempo``

### MIDI File Decoding

- ``MIDIFileEventDecodeResult``

### Protocols

- ``MIDI1FileChunk``
- ``MIDI1FileChunkIdentifier``
- ``MIDIFileTimebase``
- ``MIDIFileDeltaTime``
- ``MIDIFileEventPayload``

### Timecode Related

- ``MIDI1FileFrameRate``
- ``SwiftTimecodeCore/Timecode/scaledToMIDIFileSMPTEFrameRate``
- ``SwiftTimecodeCore/TimecodeFrameRate/midiFileSMPTEFrameRate``
