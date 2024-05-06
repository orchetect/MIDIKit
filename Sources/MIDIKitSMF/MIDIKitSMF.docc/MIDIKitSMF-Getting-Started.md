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

## Read a MIDI File

Tracks and events can be accessed once the file is successfully read.

### From Disk

```swift
// using a file URL
let url = URL() // replace with url to a MIDI file on disk
let midiFile = try MIDIFile(midiFile: url)
print(midiFile.description) // prints human-readable debug output of the file

// using a file path
let path = "/Users/user/Desktop/midifile.mid"
let midiFile = try MIDIFile(midiFile: path)
print(midiFile.description) // prints human-readable debug output of the file
```

### From Raw Data

```swift
let data = Data( ... ) // raw MIDI file contents
let midiFile = try MIDIFile(rawData: data)
```

## Write a MIDI File to Disk

This is one way to write the file to disk:

```swift
let url = URL() // replace with destination url on disk for MIDI file
let data = try midiFile.rawData()
try data.write(to: url)
```

## Accessing Meta Data, Tracks, and Events on Tracks

MIDI file contents can be read and written by accessing these properties.

```swift
// metadata
midiFile.format // type 0, 1, or 2 MIDI file
midiFile.timeBase // musical or timecode-based

// chunks, which includes tracks:
midiFile.chunks // [Chunk]

// track 1 events
guard case .track(let track1) = midiFile.chunks.first else { return }
let events = track1.events // [MIDIFileEvent]
```
