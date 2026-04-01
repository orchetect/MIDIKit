# Internals

## Topics

### Chunk Identifiers

- ``AnyMIDIFileChunkIdentifier``
- ``HeaderMIDIFileChunkIdentifier``
- ``TrackMIDIFileChunkIdentifier``
- ``UndefinedMIDIFileChunkIdentifier``

### Type-Erasure

- ``AnyMIDIFile``
- ``AnyMIDIFileHeaderChunk``
- ``AnyMIDIFileTimebase``
- ``AnyMIDIFileTrackDeltaTime``
- ``AnyMIDIFileTrackEventDecodeResult``
- ``MIDIFileTrackEvent/AnyTempo``

### MIDI File Decoding

- ``MIDIFileTrackEventDecodeResult``

### Protocols

- ``MIDIFileChunk``
- ``MIDIFileChunkIdentifier``
- ``MIDIFileTimebase``
- ``MIDIFileTrackDeltaTime``
- ``MIDIFileTrackEventPayload``

### Timecode Related

- ``MIDIFileFrameRate``
- ``SwiftTimecodeCore/Timecode/scaledToMIDIFileSMPTEFrameRate``
- ``SwiftTimecodeCore/TimecodeFrameRate/midiFileSMPTEFrameRate``
