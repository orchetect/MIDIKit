# MIDIKit: Sync


A module for generating & receiving MIDI sync, such as MTC (MIDI Timecode) and MMC (MIDI Machine Control).

It provides simple, easy-to-use abstraction classes that handle the complexity of the raw MIDI message logic underneath.

## Core Features

- `MTC` (MIDI Timecode)
  - `Receiver`
    - Incoming timecode display (ie: `00:00:00:00` string)
    - Sync abstraction (`idle/stopped`, `preSync`, `sync`, `freewheeling`, `incompatibleFrameRate`)
  - `Generator`
    - Sync abstraction (`locate(to: Timecode)`, `start(at: Timecode)`, `stop()`)
- `MMC` (MIDI Machine Control) - planned (not implemented yet)

## MTC

The MTC spec, by definition, only defines four base SMPTE frame rates: 24, 25, 29.97d or 30 fps for transmission.

Modern DAWs get around this limitation by scaling these rates to related frame rates. For example: a DAW running at 48 fps will select the 24 fps MTC rate and scale down its frames from 48 to 24 in order to transmit MTC. As long as the receiving DAW is also set to 48 fps, it will know to scale back up from 24 to 48 fps. This happens transparently to the end-user.

When MIDIKitSync's MTC objects contain a non-`nil` `localFrameRate` (which can be set to one of 20+ frame rates) then this process will happen in the same manner, and timecodes will be transparently scaled to/from these extended frame rates on your behalf.

MTC can trasmit full-frame messages and quarter-frame sync messages. Not all DAW software or hardware implements full-frame messages (including Pro Tools). It means, for example, that Pro Tools only transmits and received quarter-frame continuous sync messages and does not respond to full-frame timecode position messages.

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

When MIDI messages are received on your MTC listener MIDI port, pass them into the `MTC.Decoder`.

```swift
mtcDec.midiIn(midiMessageBytes)
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

When MIDI messages are received on your MTC listener MIDI port, pass them into the `MTC.Receiver`.

```swift
mtcRec.midiIn(midiMessageBytes)
```

Remember to always update the `localFrameRate` property when your local software's operating frame rate changes. This ensures the object scales MTC timecode property and returns correct timecodes to the handlers.

```swift
mtcRec.localFrameRate = ._29_97
```

### MTC.Generator

#### Init

```swift
// yourMIDIPort == your MIDI I/O library of choice, not included in this library

let mtcGen = MTC.Generator(localFrameRate: ._30) { (midiMessageBytes) in
    // pass MIDI messages generated to the MIDI output port
    yourMIDIPort.send(midiMessageBytes)
}
```

**Important:** Remember to always update the `localFrameRate` property when your local software's operating frame rate changes. This ensures the object scales MTC timecode property and returns correct timecodes to the handlers.

```swift
mtcGen.localFrameRate = ._29_97
```

#### Full-Frame Position

```swift
// send MTC full-frame position message
let tc = Timecode("01:02:17:05", at: ._24) // form a timecode @ 24fps
mtcGen.locate(to: tc)
```

#### Sync

```swift
// start MTC sync generation
let tc = Timecode("01:05:20:15", at: ._24)
// transport starts playback at 1:05:20:15 @ 24fps
mtcGen.start(at: tc)
// ...
// transport stopped
mtcGen.stop()
```

## MMC

Not implemented yet.

## Roadmap

- [ ] Add unit tests (in-progress)
- [ ] Add MMC capability

### Possible Future Additions

- [ ] MIDI Beat Clock

## Dependencies

- [TimecodeKit](https://github.com/orchetect/TimecodeKit) - a robust SMPTE timecode and frame rate library written in Swift
