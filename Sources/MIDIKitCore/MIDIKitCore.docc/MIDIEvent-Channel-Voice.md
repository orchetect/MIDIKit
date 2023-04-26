# Channel Voice

Channel Voice events include notes, continuous controllers, pressure (aftertouch), program changes, and registered parameters (RPN/NRPN). Additional per-note controllers are available when communicating with a device that supports MIDI 2.0.

## MIDI 1.0 & 2.0 Events

### Note On

```swift
let event: MIDIEvent = .noteOn(60, velocity: .midi1(64), channel: 0)
```

- See ``MIDIEvent/noteOn(_:velocity:attribute:channel:group:midi1ZeroVelocityAsNoteOff:)-5hwd6`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Note Off

```swift
let event: MIDIEvent = .noteOff(60, velocity: .midi1(64), channel: 0)
```

- See ``MIDIEvent/noteOff(_:velocity:attribute:channel:group:)-9ntbn`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Per-Note Pressure (Polyphonic Aftertouch)

```swift
let event: MIDIEvent = .notePressure(note: 60, amount: .midi1(64), channel: 0)
```

- See ``MIDIEvent/notePressure(note:amount:channel:group:)-8m6c8`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Control Change (CC)

```swift
// using controller number
let event: MIDIEvent = .cc(1, amount: .midi1(64), channel: 0)

// using controller name
let event: MIDIEvent = .cc(.modWheel, amount: .midi1(64), channel: 0)
```

- See ``MIDIEvent/cc(_:value:channel:group:)-1r3oe`` or ``MIDIEvent/cc(_:value:channel:group:)-7k06z`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Pitch Bend (Channel)

```swift
let event: MIDIEvent = .pitchBend(value: .midi1(8192), channel: 0)
```

- See ``MIDIEvent/pitchBend(value:channel:group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Pressure / Aftertouch (Channel)

```swift
let event: MIDIEvent = .pressure(amount: .midi1(64), channel: 0)
```

- See ``MIDIEvent/pressure(amount:channel:group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Program Change

```swift
/// program change without bank select
let event: MIDIEvent = .programChange(program: 0x02, channel: 0)

/// program change with bank select
let event: MIDIEvent = .programChange(
    program: 0x02,
    bank: .bankSelect(msb: 0x01, lsb: 0x00)
    channel: 0
)
```

- See ``MIDIEvent/programChange(program:bank:channel:group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### RPN (Registered Parameter Number)

```swift
// using known registered RPN controller enum
let event: MIDIEvent = .rpn(.pitchBendSensitivity(semitones: 2, cents: 0), channel: 0)

// using raw values
let event: MIDIEvent = .rpn(
    parameter: UInt7Pair(msb: 0x00, lsb: 0x00),
    data: (msb: 0x02, lsb: 0x00),
    channel: 0
)
```

- See ``MIDIEvent/rpn(_:change:channel:group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### NRPN (Non-Registered Parameter Number)

```swift
let event: MIDIEvent = .nrpn(
    parameter: UInt7Pair(msb: 0x20, lsb: 0x01),
    data: (msb: 0x12, lsb: 0x34),
    channel: 0
)
```

- See ``MIDIEvent/nrpn(_:change:channel:group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

## MIDI 2.0 Only Events

### Per-Note Control Change (CC)

```swift
// using controller number
let event: MIDIEvent = .noteCC(
    note: 60,
    controller: .registered(1),
    value: .midi2(0xFFFFFFFF),
    channel: 0
)

// using controller name
let event: MIDIEvent = .noteCC(
    note: 60,
    controller: .registered(.modWheel),
    value: .midi2(0xFFFFFFFF),
    channel: 0
)
```

- See ``MIDIEvent/noteCC(note:controller:value:channel:group:)-91ea3`` for more details.
- Compatibility: MIDI 2.0

### Per-Note Pitch Bend

```swift
let event: MIDIEvent = .notePitchBend(note: 60, value: .midi2(0xFFFFFFFF), channel: 0)
```

- See ``MIDIEvent/notePitchBend(note:value:channel:group:)-5qoa8`` for more details.
- Compatibility: MIDI 2.0

### Per-Note Management

```swift
let event: MIDIEvent = .noteManagement(
    note: 60,
    flags: [.detachPerNoteControllers],
    channel: 0
)
```

- See ``MIDIEvent/noteManagement(note:flags:channel:group:)-9f1cj`` for more details.
- Compatibility: MIDI 2.0

## Event Value Types

For an overview of how event value types work (such as note velocity, CC value, etc.) see <doc:MIDIKitCore-Value-Types>.

## Topics

### Constructors (MIDI 1.0 and 2.0)

- ``MIDIEvent/noteOn(_:velocity:attribute:channel:group:midi1ZeroVelocityAsNoteOff:)-5hwd6``
- ``MIDIEvent/noteOn(_:velocity:attribute:channel:group:midi1ZeroVelocityAsNoteOff:)-3aq0d``

- ``MIDIEvent/noteOff(_:velocity:attribute:channel:group:)-9ntbn``
- ``MIDIEvent/noteOff(_:velocity:attribute:channel:group:)-40eu2``

- ``MIDIEvent/notePressure(note:amount:channel:group:)-8m6c8``
- ``MIDIEvent/notePressure(note:amount:channel:group:)-9knkb``

- ``MIDIEvent/cc(_:value:channel:group:)-1r3oe``
- ``MIDIEvent/cc(_:value:channel:group:)-7k06z``

- ``MIDIEvent/ccRPN(_:channel:group:)``
- ``MIDIEvent/ccNRPN(_:channel:group:)``

- ``MIDIEvent/pitchBend(value:channel:group:)``

- ``MIDIEvent/pressure(amount:channel:group:)``

- ``MIDIEvent/programChange(program:bank:channel:group:)``

- ``MIDIEvent/rpn(_:change:channel:group:)``
- ``MIDIEvent/rpn(parameter:data:change:channel:group:)-9unrb``
- ``MIDIEvent/rpn(parameter:data:change:channel:group:)-7chyn``
- ``MIDIEvent/rpn(parameter:data:change:channel:group:)-9ju8k``
- ``MIDIEvent/midi1RPN(_:change:channel:group:)``

- ``MIDIEvent/nrpn(_:change:channel:group:)``
- ``MIDIEvent/nrpn(parameter:data:change:channel:group:)-tpej``
- ``MIDIEvent/nrpn(parameter:data:change:channel:group:)-nib6``
- ``MIDIEvent/nrpn(parameter:data:change:channel:group:)-u0a``
- ``MIDIEvent/midi1NRPN(_:change:channel:group:)``

### Constructors (MIDI 2.0)

- ``MIDIEvent/noteCC(note:controller:value:channel:group:)-91ea3``
- ``MIDIEvent/noteCC(note:controller:value:channel:group:)-8vd58``

- ``MIDIEvent/notePitchBend(note:value:channel:group:)-5qoa8``
- ``MIDIEvent/notePitchBend(note:value:channel:group:)-5qk4i``

- ``MIDIEvent/noteManagement(note:flags:channel:group:)-9f1cj``
- ``MIDIEvent/noteManagement(note:flags:channel:group:)-3o4c8``

### Switch Case Unwrapping (MIDI 1.0 and 2.0)

- ``MIDIEvent/noteOn(_:)``
- ``MIDIEvent/NoteOn``

- ``MIDIEvent/noteOff(_:)``
- ``MIDIEvent/NoteOff``

- ``MIDIEvent/notePressure(_:)``
- ``MIDIEvent/NotePressure``

- ``MIDIEvent/cc(_:)``
- ``MIDIEvent/CC``

- ``MIDIEvent/pitchBend(_:)``
- ``MIDIEvent/PitchBend``

- ``MIDIEvent/pressure(_:)``
- ``MIDIEvent/Pressure``

- ``MIDIEvent/programChange(_:)``
- ``MIDIEvent/ProgramChange``

- ``MIDIEvent/rpn(_:)``
- ``MIDIEvent/RPN``
- ``MIDIEvent/RegisteredController``

- ``MIDIEvent/nrpn(_:)``
- ``MIDIEvent/NRPN``
- ``MIDIEvent/AssignableController``

### Switch Case Unwrapping (MIDI 2.0)

- ``MIDIEvent/noteCC(_:)``
- ``MIDIEvent/NoteCC``

- ``MIDIEvent/notePitchBend(_:)``
- ``MIDIEvent/NotePitchBend``

- ``MIDIEvent/noteManagement(_:)``
- ``MIDIEvent/NoteManagement``

### Related

- ``MIDIEvent/NoteAttribute``
- ``MIDIEvent/NoteVelocity``
- ``MIDIEvent/NoteVelocityValidated``

- ``MIDIParameterNumberType``
- ``MIDI2ParameterNumberChange``
