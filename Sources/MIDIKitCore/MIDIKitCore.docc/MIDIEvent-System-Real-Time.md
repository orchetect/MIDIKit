# System Real-Time

System Real-Time events include global system messages such as sequencer start/stop/continue, timing clock, and system reset.

These events do not carry any data parameters.

## MIDI 1.0 & 2.0 Events

### Sequencer Start

```swift
let event: MIDIEvent = .start()
```

- See ``MIDIEvent/start(group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Sequencer Stop

```swift
let event: MIDIEvent = .stop()
```

- See ``MIDIEvent/stop(group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Sequencer Continue

```swift
let event: MIDIEvent = .continue()
```

- See ``MIDIEvent/continue(group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### Timing Clock

```swift
let event: MIDIEvent = .timingClock()
```

- See ``MIDIEvent/timingClock(group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

### System Reset

```swift
let event: MIDIEvent = .systemReset()
```

- See ``MIDIEvent/systemReset(group:)`` for more details.
- Compatibility: MIDI 1.0 & 2.0

## Event Value Types

For an overview of how event value types work (such as note velocity, CC value, etc.) see <doc:MIDIKitCore-Value-Types>.

## Topics

### Constructors

- ``MIDIEvent/start(group:)``

- ``MIDIEvent/stop(group:)``

- ``MIDIEvent/continue(group:)``

- ``MIDIEvent/timingClock(group:)``

- ``MIDIEvent/systemReset(group:)``

### Switch Case Unwrapping

- ``MIDIEvent/start(_:)``
- ``MIDIEvent/Start``

- ``MIDIEvent/stop(_:)``
- ``MIDIEvent/Stop``

- ``MIDIEvent/continue(_:)``
- ``MIDIEvent/Continue``

- ``MIDIEvent/timingClock(_:)``
- ``MIDIEvent/TimingClock``

- ``MIDIEvent/systemReset(_:)``
- ``MIDIEvent/SystemReset``

### Deprecated in MIDI 2.0

- ``MIDIEvent/activeSensing(group:)``
- ``MIDIEvent/activeSensing(_:)``
- ``MIDIEvent/ActiveSensing``
