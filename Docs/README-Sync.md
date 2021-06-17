# MIDIKit: Sync


A module for generating & receiving MIDI sync, such as MTC (MIDI Timecode).

It provides simple, easy-to-use abstraction classes that handle the complexity of the raw MIDI message logic and timing underneath.

## Core Features

- [`MTC`](#MTC) (MIDI Timecode)
  - Encoding
    - [`Encoder`](#MTC.Encoder)
    - [`Decoder`](#MTC.Decoder)
      - Incoming timecode display handler (ie: "`01:00:00:00`")
  - Sync abstraction classes
    - [`Generator`](#MTC.Generator) (wraps `Encoder`)
      - Sync abstraction (`locate(to:)`, `start()`, `stop()`)
    - [`Receiver`](#MTC.Receiver) (wraps `Decoder`)
      - Incoming timecode display handler (ie: "`01:00:00:00`")
      - Sync abstraction handler (`idle/stopped`, `preSync`, `sync`, `freewheeling`, `incompatibleFrameRate`)
- [`MMC`](#MMC) (MIDI Machine Control) - planned (not implemented yet)

## MTC

The MTC spec, by definition, only defines four base SMPTE frame rates: 24, 25, 29.97d or 30 fps for transmission.

Modern DAWs get around this limitation by scaling these rates to related frame rates. For example: a DAW running at 48 fps will internally select the 24 fps MTC rate and scale down its frames from 48 to 24 in order to transmit MTC. As long as the receiving DAW is also set to 48 fps, it will know to scale back up from 24 to 48 fps. This happens transparently to the end-user.

The MTC classes in MIDIKit will also transparently scale frames up or down in the same manner, abstracting the nuts and bolts away and leaving simple API that deals in user timecode and user frame rate.

MTC can trasmit full-frame messages and quarter-frame sync messages. Not all DAW software or hardware implements full-frame messages (including Pro Tools). It means, for example, that Pro Tools only transmits and received quarter-frame continuous sync messages and does not respond to full-frame timecode position messages.

### MTC.Encoder

The `MTC.Encoder` class encodes outgoing MTC MIDI messages.

It can be used when you are only interested in generating events and want to provide your own timing mechanism, and do not require the additional sync abstraction that the `MTC.Generator` adds.

The `Encoder` is capable of forwards and backwards quarter-frame spooling.

#### Init

```swift
let mtcEnc = MTC.Encoder() { (midiMessage) in
    // pass MIDI messages generated to a MIDI output endpoint
    yourMIDIEndpoint.send(midiMessage)
}
```

No `localFrameRate` parameter is needed to be set, as it will be set at the time `locate(to:)` is called.

#### Full-Frame Position

```swift
// send MTC full-frame position message
let tc = Timecode("01:02:17:05", at: ._24) // form a timecode @ 24fps
mtcEnc.locate(to: tc)
```

#### Quarter-Frame Events

Call `increment()` to advance in time by one quarter-frame, or `decrement()` to rewind by one quarter-frame.

No timing mechanism is provided in the `Encoder`. The `Generator` class provides timing mechanisms tailored to each frame rate. To understand how to manually manage timing and context of these events while exclusively using the `Encoder`, consult the [MIDI Timecode extension to the MIDI 1.0 spec](https://www.midi.org/specifications/midi1-specifications/midi-time-code).

### MTC.Generator

The `MTC.Generator` class is a wrapper for `MTC.Encoder` that adds MTC sync abstraction by way of methods and handler closures.

#### Init

```swift
let mtcGen = MTC.Generator() { (midiMessage) in
    // pass MIDI messages generated to a MIDI output endpoint
    yourMIDIEndpoint.send(midiMessage)
}
```

No `localFrameRate` parameter is needed to be set, as it will be set at the time `locate(to:)` is called.

#### Full-Frame Position

```swift
// send MTC full-frame position message
let tc = Timecode("01:02:17:05", at: ._24) // form a timecode @ 24fps
mtcGen.locate(to: tc)
```

#### Sync

While your software's transport is stopped (not playing back), send location change messages by calling `locate(to:)` whenever the playhead position changes (user locates to a new position in the timeline or actively while scrubbing the playhead). This informs the generator of the current timeline position, and also triggers a MTC full-frame message to be transmit.

```swift
// inform the generator you have located to a new timecode
// this will also trigger the handler to transmit a MTC full-frame position message
let tc = Timecode("01:02:17:05", at: ._24) // form a timecode @ 24fps
mtcGen.locate(to: tc)
```

To start and stop transmission of continuous quarter-frame messages, first ensure that the generator has located to an origin timecode position from which to start generating. Then call `start()` when playback starts at the start of the frame of that timecode, and `stop()` when playback stops.

```swift
// start MTC sync generation
let tc = Timecode("01:05:20:15", at: ._24)
// transport starts playback at exactly 1:05:20:15 (start of the frame)
mtcGen.start(at: tc)
// ...
// transport stopped
mtcGen.stop()
```

### MTC.Decoder

The `MTC.Decoder` class decodes incoming MTC MIDI messages.

It can be used when you are only interested in displaying timecode and do not require the additional sync abstraction that the `MTC.Receiver` adds.

#### Init

All of the callback handler closures are optional and can each be independently implemented or omitted.

```swift
let mtcDec = MTC.Decoder { timecode, _, _, displayNeedsUpdate in
    if displayNeedsUpdate {
        print(timecode.stringValue) // "00:00:00:00"
        print(timecode.components)  // (h: 0, m: 0, s: 0, f: 0)
        print(timecode.frameRate)   // ._30
    }
}
```

When MIDI messages are received on your MTC listener MIDI endpoint, pass them into the `MTC.Decoder`.

```swift
mtcDec.midiIn(midiMessage)
```

If a local frame rate is not specified, timecode and frame fate is derived from the MTC stream by default.

```swift
mtcDec.localFrameRate = nil

// timecode object in handler provides values as-is, with frame rate matching incoming MTC

// raw MTC received          timecode.stringValue  timecode.frameRate
// ------------------------  --------------------  ------------------
// 01 00 00 12 @ 24 fps      "01:00:00:12"         ._24
// 01 00 00 12 @ 25 fps      "01:00:00:12"         ._25
// 01 00 00 12 @ 29.97d fps  "01:00:00;12"         ._29_97_drop
// 01 00 00 12 @ 30 fps      "01:00:00:12"         ._30
```

If you are using a local frame rate, remember to always update the `localFrameRate` property when your local software's operating frame rate changes. (This ensures the object scales MTC timecode property and returns correctly scaled timecodes to the handlers.) If incoming MTC frame rate is incompatible, the `timecode` value returned by the handler will be at the raw MTC frame rate.

```swift
mtcDec.localFrameRate = ._30 // tells decoder your software is operating with this frame rate

// timecode object in handler provides values scaled to match the desired frame rate, since they are sync compatible

// raw MTC received          result  timecode.stringValue  timecode.frameRate
// ------------------------  ------  --------------------  ------------------
// 01 00 00 12 @ 24 fps      scaled  "01:00:00:15"         ._30
// 01 00 00 12 @ 25 fps      scaled  "01:00:00:14"         ._30
// 01 00 00 12 @ 29.97d fps  as-is   "01:00:00;12"         ._29_97_drop
// 01 00 00 12 @ 30 fps      as-is   "01:00:00:12"         ._30
```

### MTC.Receiver

The `MTC.Receiver` class is a wrapper for `MTC.Decoder` that adds MTC sync abstraction by way of additional properties and handler closures.

#### Init

All of the callback handler closures are optional and can each be independently implemented or omitted.

```swift
let mtcRec = MTC.Receiver(name: "main",
                          localFrameRate: ._30,
                          syncPolicy: .init(lockFrames: 16,
                                            dropOutFrames: 10))
{ timecode, messageType, direction, displayNeedsUpdate in
    if messageType == .fullFrame {
        // add logic to locate your software to a jump in timecode
    }
    if displayNeedsUpdate {
        // update incoming timecode display somewhere in your app
        print(timecode.stringValue)
    }
	
} stateChanged: { state in
    // called when the sync state has changed
    switch state {
    case .idle:
        // receiever has transitioned to being stopped
        // local playback should now stop, or if the previous state
        // was a preSync state, the scheduled future playback start should be cancelled here
    case .preSync(let predictedLockTime, let lockTimecode):
        // continuous quarter-frame messages are being received
        // and the receiver is predicting a .sync lock;
        // this is where your software can buffer what it needs to and schedule
        // the start of playback for the:
        // - future predictedLockTime mach time
        // - future timecode
        // this preSync period is determined by the receiver's syncPolicy
    case .sync:
        // state transitions from .preSync to .sync after the preSync period has elapsed
        // optional, can typically be ignored if your software's playback
        // was triggered from scheduling playback during the .preSync(_,_) state
    case .freewheeling:
        // optional, can typically be ignored
    case .incompatibleFrameRate:
        // the MTC frame rate being received is incompatible with the local frame rate
        // which means sync is not possible and of course frame number scaling is not possible
    }
}
```

When MIDI messages are received on your MTC listener MIDI endpoint, pass them into the `MTC.Receiver`.

```swift
mtcRec.midiIn(midiMessage)
```

Remember to always update the `localFrameRate` property when your local software's operating frame rate changes. This ensures the object scales MTC timecode property and returns correct timecodes to the handlers.

```swift
mtcRec.localFrameRate = ._29_97
```

## MMC

Not implemented yet. Possible future addition to the library.

### Possible Future Additions

- [ ] MIDI Beat Clock abstraction
- [ ] MIDI Machine Control (MMC) abstraction

## Dependencies

- [TimecodeKit](https://github.com/orchetect/TimecodeKit) - a robust SMPTE timecode and frame rate library written in Swift

## Links

- [MIDI Timecode extension to the MIDI 1.0 spec](https://www.midi.org/specifications/midi1-specifications/midi-time-code)
