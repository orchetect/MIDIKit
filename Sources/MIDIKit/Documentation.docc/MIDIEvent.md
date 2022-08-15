# ``MIDIKit/MIDIEvent``

MIDI events are constructed as enum cases containing event payload data. Various static constructors are available for each event type.

## Topics

### Categories

- <doc:MIDIEvent-Channel-Voice>
- <doc:MIDIEvent-System-Common>
- <doc:MIDIEvent-System-Exclusive>
- <doc:MIDIEvent-System-Real-Time>
- <doc:MIDIEvent-Utility>

### General Properties

- <doc:MIDIEvent-General-Properties>

### Event Filtering

- <doc:MIDIEvent-Event-Filtering>

### Underlying Value Types

- ``ChanVoice7Bit16BitValue``
- ``ChanVoice7Bit32BitValue``
- ``ChanVoice14Bit32BitValue``
- ``ChanVoice32BitValue``

### Raw Data Encoding

- ``midi1RawBytes()``
- ``umpRawWords(protocol:)``

### Errors

- ``ParseError``
