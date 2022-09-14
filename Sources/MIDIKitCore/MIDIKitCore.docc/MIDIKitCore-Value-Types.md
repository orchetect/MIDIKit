# MIDIKit Value Types

To increase type safety and enforce value validation, novel value types have been implemented in MIDIKit.

## Overview

MIDI events in MIDIKit use a hybrid approach allowing easy interchange of protocol-specific value types by using enum cases. These values may all be used regardless whether the current platform supports MIDI 1.0 or MIDI 2.0, so that it is seamless to users of MIDIKit and you can freely choose which value types to use in all circumstances. Consider it like a form of MIDI protocol value type-erasure.

- MIDI 1.0 values
- MIDI 2.0 values
- Unit Interval (`Double` between `0.0 ... 1.0`)  - automatically converts to appropriate actual MIDI value

Special attention has been made to ensure midpoints line up across all of these value types, so always use the enum cases and properties provided by MIDIKit to convert values from one format to another.

For example, when sending or receiving a MIDI Note On event, consider that all of the following events are identical to each other:

```swift
// MIDI 1.0 value type
MIDIEvent.noteOn(
    60,
    velocity: .midi1(64), // 7-bit, 0 ... 127
    channel: 0
)

// MIDI 2.0 value type
MIDIEvent.noteOn(
    60,
    velocity: .midi2(32768), // 16-bit, 0 ... 65535
    channel: 0
)

// Unit Interval value type (MIDI protocol-agnostic)
MIDIEvent.noteOn(
    60,
    velocity: .unitInterval(0.5), // Double, 0.0 ... 1.0
    channel: 0
)
```

Any of these values can be converted to any of the other value types, and MIDIKit intelligently scales them while maintaining stable midpoint values.

```swift
func received(midiEvent: MIDIEvent) {
    switch midiEvent {
        case .noteOn(payload):
            print(payload.velocity.midi1Value) // "64"
            print(payload.velocity.midi2Value) // "32768"
            print(payload.velocity.unitIntervalValue) // "0.5"
        default: break
        }
    }
}
```

Internal scaling takes this into effect for every value type. Values between min and the midpoint are calculated differently than values between the midpoint and the max.

Consider these examples where MIDIKit helps you transparently:

- even though a 7-bit MIDI 1.0 value of 64 is considered its midpoint, MIDIKit understands that:
  - as a unit interval it smartly equates to 0.5, and not 0.5039370079 (naïvely 64/127)
  - as a MIDI 2.0 value it smartly equates to 32768, and not 33026 (naïvely (64/127) × 0xFFFF rounding up)

The inverse is also true when converting from a unit interval to a MIDI 1.0 or MIDI 2.0 value or anything in between.

## Topics

### Core Value Types

- ``BytePair``
- ``UInt4``
- ``UInt7``
- ``UInt7Pair``
- ``UInt14``

### Additional Value Types

- ``UInt9``
- ``UInt25``
- ``UMPWord``

### Base MIDI Event Value Types

- ``MIDIEvent/ChanVoice7Bit16BitValue``
- ``MIDIEvent/ChanVoice7Bit32BitValue``
- ``MIDIEvent/ChanVoice14Bit32BitValue``
- ``MIDIEvent/ChanVoice32BitValue``
