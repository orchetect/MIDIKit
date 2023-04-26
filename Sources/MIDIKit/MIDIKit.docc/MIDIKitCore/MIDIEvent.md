# ``MIDIKit/MIDIEvent``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Constructing Events

It is recommended to use the parameterized static methods to construct these events:

```swift
// both the following methods are valid and identical:
let event = MIDIEvent.noteOn(60, velocity: .midi1(64), channel: 0)
let event: MIDIEvent = .noteOn(60, velocity: .midi1(64), channel: 0)
```

## Parsing Received Events

It is recommended to use the payload struct and access its properties.

```swift
switch midiEvent {
case .noteOn(let payload):
    print("Note On:", payload.note, payload.velocity, payload.channel)
case .noteOff(let payload):
    print("Note Off:", payload.note, payload.velocity, payload.channel)
// ... add additional cases for other event types if needed ...
default:
    break
}
```

## MIDI 2.0 Considerations

MIDI 2.0 incorporates nearly all of the pre-existing MIDI 1.0 events while increasing the value resolution for many. Additionally, MIDI 2.0 introduces several new event types which are not backwards-compatible with MIDI 1.0.

UMP (Universal MIDI Packet) introduces a **group** parameter included in each packet. MIDI 2.0 adds the ability to select a group (0-15) which effectively multiplexes the MIDI port into 16 addressable sub-ports (termed "UMP groups"). This should be set to 0 under most circumstances to maintain compatibility. It defaults to 0 if the parameter is omitted from `MIDIEvent` constructors. MIDI 1.0 is not capable of transmitting this parameter and therefore has no effect and will be stripped when sent to or received from a MIDI 1.0 device.

For more details, see the official MIDI 2.0 Spec.

## Event Value Types

For an overview of how event value types work (such as note velocity, CC value, etc.) see <doc:MIDIKitCore-Value-Types>.

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

### Raw Data Encoding

- ``midi1RawBytes()``
- ``umpRawWords(protocol:)``

### Errors

- ``ParseError``