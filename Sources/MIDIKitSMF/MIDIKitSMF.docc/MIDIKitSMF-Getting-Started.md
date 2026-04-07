# Getting Started

A quick guide on getting started using MIDIKitSMF.

![MIDIKit](midikitsmf-banner.png)

This is a basic guide intended to give the most essential information on getting set up and running with MIDIKitSMF.

There are many more features and aspects to the library that can be discovered through inline documentation.

## Import the Library

Add MIDIKitSMF to your project, and import it.

```swift
import MIDIKitSMF
```

## A Note On Timebase

As a baseline, the Standard MIDI File 1.0 spec defines two timebases for MIDI files: musical, and SMPTE (timecode).

> Note:
>
> Nearly all software manufacturers exclusively implement musical timebase. SMPTE timebase is extremely rare and almost never used. However, since both are defined in the specification, both are supported by MIDIKit.
>
> It is reasonable that you may opt to use the `MusicalMIDI1File` (`MIDI1File<MusicalMIDIFileTimebase>`) type exclusively.

If you are unsure which timebase a MIDI file uses, the type-erased `AnyMIDI1File` is provided which will decode a file into its specialized `MIDIFile` type.

```swift
let anyMIDIFile = try AnyMIDI1File(url: url)

switch midiFile.wrapped {
case let .musical(midiFile):
    // midiFile is `MIDI1File<MusicalMIDIFileTimebase>`, typealiased as `MusicalMIDI1File`
case let .smpte(midiFile):
    // midiFile is `MIDI1File<SMPTEMIDIFileTimebase>`, typealiased as `SMPTEMIDI1File`
}
```

See ``AnyMIDI1File``, ``MusicalMIDI1File`` and ``SMPTEMIDI1File``.

## Read a MIDI File

Tracks and events can be accessed once the file is successfully read.

### From Disk

Using a file URL:

```swift
let url = URL(fileURLWithPath: "/Users/user/Desktop/test.mid")
let midiFile = try MusicalMIDI1File(url: url)
print(midiFile.description) // prints human-readable debug output of the file
```
Using a file path:

```swift
let path = "/Users/user/Desktop/test.mid"
let midiFile = try MusicalMIDI1File(path: path)
print(midiFile.description) // prints human-readable debug output of the file
```

### From Raw Data

Using raw MIDI file contents:

```swift
let data = Data( ... )
let midiFile = try MusicalMIDI1File(data: data)
```

### Async vs non-Async Decoding

MIDI file decoding initializers are offered in two flavors: async and non-async.

> Note:
> 
> Where possible, it is highly recommended to use the `async` variant, as it implements multi-threaded file decoding which can be *significantly* faster than the non-async method.

```swift
let midiFile = try await MusicalMIDI1File(data: data)
```

### Decoding Options

Decoding options may be supplied to the initializer.

The default options allow for the widest compatibility and error recoverability, but you may customize the options as desired.

```swift
let options = MIDI1FileDecodeOptions(
    allowMultiTrackFormat0: true,
    ignoreBytesPastEOF: true,
    chunkDecodeOptions: MIDI1FileChunkDecodeOptions(
        bundleRPNAndNRPNEvents: true,
        maxEventCount: nil,
        errorStrategy: .allowLossyRecovery
    )
)

let midiFile = try MusicalMIDI1File(url: url, options: options)
```

See ``MIDI1FileDecodeOptions`` and ``MIDI1FileChunkDecodeOptions``.

## Write a MIDI File to Disk

This is one way to write the file to disk:

```swift
let url = URL(fileURLWithPath: "/Users/user/Desktop/test.mid")
let data = try midiFile.rawData()
try data.write(to: url)
```

## Accessing Metadata

MIDI file contents can be read and written by accessing these properties.

```swift
// header chunk metadata
midiFile.format // type 0, 1, or 2 MIDI file
midiFile.timebase // musical or timecode-based
```

## Accessing Tracks and Events

Read and write tracks using the `tracks` property:

```swift
for track in midiFile.tracks {
    for event in track.events {
        print(event)
    }
}
```

Read first event from first track:

```swift
let deltaEvent = midiFile.tracks[0].events[0]

let delta = deltaEvent.delta // delta time
let event = deltaEvent.event // event payload

switch event {
case let .noteOn(delta, payload):
    print(payload.note.number.uInt8Value, payload.velocity.midi1Value, payload.channel.uInt8Value)
case let .noteOff(delta, payload):
    print(payload.note.number.uInt8Value, payload.velocity.midi1Value, payload.channel.uInt8Value)
    
// ... handle additional cases as needed ...
}
```

Read all events on a track at their beat positions (elapsed quarter-notes as a floating-point value):

```swift
for (beat, event) in midiFile.tracks[0].eventsAtBeatPositions(using: midiFile.timebase) {
    switch event {
    case let .noteOff(payload):
        print(beat, payload.note.number.uInt8Value, payload.velocity.midi1Value, payload.channel.uInt8Value)
    case let .noteOn(payload):
        print(beat, payload.note.number.uInt8Value, payload.velocity.midi1Value, payload.channel.uInt8Value)
        
    // ... handle additional cases as needed ...
    }
}    
```

Add an event to first track:

```swift
let event: MIDIFileEvent = .noteOn(note: 60, velocity: .midi1(127), channel: 0)
midiFile.tracks[0].events.append(delta: .note8th, event: event)
```

Add a new track:

```swift
let newTrack = MusicalMIDI1File.Track()
midiFile.tracks.append(newTrack)
```

Replace a track:

```swift
let newTrack = MusicalMIDI1File.Track()
midiFile.tracks[0] = newTrack
```

Remove a track:

```swift
midiFile.tracks.remove(at: 0)
```

## Accessing All Chunks

Alternatively, all chunks (including non-track chunks) can be accessed through the `chunks` property:

```swift
for chunk in midiFile.chunks {
    switch chunk {
    case let .track(track): // `track` is `MusicalMIDI1File.Track`
        // chunk is a track
    case let .undefined(chunk): // `chunk` is `MusicalMIDI1File.UndefinedChunk`
        // chunk is a non-track chunk
    }
}
```
