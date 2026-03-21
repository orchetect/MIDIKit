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
let midiFile = try MIDIFile(url: url)
print(midiFile.description) // prints human-readable debug output of the file

// using a file path
let path = "/Users/user/Desktop/midifile.mid"
let midiFile = try MIDIFile(path: path)
print(midiFile.description) // prints human-readable debug output of the file
```

### From Raw Data

```swift
let data = Data( ... ) // raw MIDI file contents
let midiFile = try MIDIFile(data: data)
```

## Write a MIDI File to Disk

This is one way to write the file to disk:

```swift
let url = URL() // replace with destination url on disk for MIDI file
let data = try midiFile.rawData()
try data.write(to: url)
```

## Accessing Metadata, Tracks, and Events on Tracks

MIDI file contents can be read and written by accessing these properties.

```swift
// header chunk metadata
midiFile.format // type 0, 1, or 2 MIDI file
midiFile.timebase // musical or timecode-based
```

Read and write tracks using the `tracks` property:

```swift
for track in midiFile.tracks {
    for event in track.events {
        print(event)
    }
}

// read first event from first track
let event = midiFile.tracks[0].events[0]

// add an event to first track
midiFile.tracks[0].events.append( ... )

// add a track
let newTrack = MIDIFile.TrackChunk()
midiFile.tracks.append(newTrack)

// replace a track
let newTrack = MIDIFile.TrackChunk()
midiFile.tracks[0] = newTrack

// remove a track
midiFile.tracks.remove(at: 0)
```

Alternatively, all chunks can be accessed (including non-track chunks):

```swift
for chunk in midiFile.chunks {
    switch chunk {
    case let .track(track): // `track` is MIDIFile.TrackChunk
        // chunk is a track
    case let .unrecognized(chunk): // `chunk` is MIDIFile.UnrecognizedChunk
        // chunk is a non-track chunk
    }
}
```
