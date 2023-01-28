# MIDIKit Value Types

To increase type safety and enforce value validation, novel value types have been implemented in MIDIKit.

## MIDI Events

MIDIKit contains a unified set of MIDI events which are seamlessly interchangeable in both MIDI 1.0 and MIDI 2.0 contexts.

However, values for events often have different resolutions between the two protocols. For example, a MIDI 1.0 Note On event carries a 7-bit velocity (0 ... 127). However, a MIDI 2.0 Note On event carries a 16-bit velocity (0 ... 65535).

To account for this, MIDIKit introduces unified hybrid value types allowing you to provide the value in the resolution of your choice regardless whether the platform is operating with MIDI 1.0 or 2.0, and MIDIKit will scale the value automatically when appropriate.

## MIDI Event Value Types

Generally there will be three cases for each value type:

- **MIDI 1.0 value**
  
  These values are often 7-bit (like velocity, or CC value), and sometimes 14-bit (like pitch bend).
- **MIDI 2.0 value**
  
  These values are often between 16 and 32-bit.
- **Unit Interval (`Double` between `0.0 ... 1.0`)**
  
  A floating-point unit interval value is provided specifically in MIDIKit as a convenience, and can be used for virtually any MIDI value type. This standardizes values and allows for easier mapping of values to other values.

## Constructing Values

- **Construct** using enum case (`.midi1()`, `.midi2()`, `.unitInterval()`)

For example, when sending or receiving a Note On event, consider that all of the following events are identical to each other:

```swift
// 7-bit velocity 0 ... 127
.noteOn(60, velocity: .midi1(64), channel: 0)

// 16-bit velocity 0 ... 65535
.noteOn(60, velocity: .midi2(32768), channel: 0)

// Double velocity 0.0 ... 1.0
.noteOn(60, velocity: .unitInterval(0.5), channel: 0)
```

## Reading and Converting Values

- **Read** using properties (`.midi1Value`, `.midi2Value`, `.unitIntervalValue`)

Values can be read in the resolution of your choice by accessing the following properties. These take into account any necessary resolution scaling if necessary. (This is important because scaling is not strictly linear. For more information, see the [next section](#scaling).)

```swift
let midiEvent: MIDIEvent = .noteOn(60, velocity: .midi1(64), channel: 0)

switch midiEvent {
    case .noteOn(let payload):
        payload.velocity.midi1Value // 64 (as UInt7)
        payload.velocity.midi2Value // 32768 (as UInt16)
        payload.velocity.unitIntervalValue // 0.5 (as Double)
    default: break
}
```

> Warning:
>
> When reading data from MIDI events, avoid switching over a value (such as `velocity`).
> 
> Instead, use the properties as described above. They are more convenient and implement correct scaling.
> 
>    ```swift
>    // ⚠️ Avoid this!
>    switch payload.velocity {
>        case .midi1(let value):
>        case .midi2(let value):
>        case .unitInterval(let value):
>    }
>    ```

## Automatic Scaling

Special attention has been made to ensure midpoints line up across all of these value types, so be sure to always use the enum cases and properties provided by MIDIKit as described above to convert values from one format to another.

Internally, values between *min ... midpoint* are calculated differently than values between *midpoint ... max*.

Consider these examples where MIDIKit helps you transparently:

- even though a 7-bit MIDI 1.0 value of 64 is considered its midpoint, MIDIKit understands that:
  - as a MIDI 2.0 value it smartly equates to 32768, and not 33026 (naïvely (64/127) × 0xFFFF rounding up)
  - as a unit interval it smartly equates to 0.5, and not 0.5039370079 (naïvely 64/127)

Note that conversions from a higher resolution to a lower resolution are still lossy of course.

## Topics

### Core Value Types

- ``BytePair``
- ``UInt4``
- ``UInt7``
- ``UInt7Pair``
- ``UInt14``

### Additional Value Types

- ``Int7``
- ``UInt9``
- ``UInt25``
- ``UMPWord``

### Base MIDI Event Value Types

- ``MIDIEvent/ChanVoice7Bit16BitValue``
- ``MIDIEvent/ChanVoice7Bit32BitValue``
- ``MIDIEvent/ChanVoice14Bit32BitValue``
- ``MIDIEvent/ChanVoice32BitValue``
