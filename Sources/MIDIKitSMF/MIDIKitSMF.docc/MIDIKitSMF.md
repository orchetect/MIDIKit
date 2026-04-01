# ``MIDIKitSMF``

Standard MIDI File extension for MIDIKit.

![MIDIKit](midikitsmf-banner.png)

![Layer Diagram](midikitsmf-diagram.svg)

## Overview

This extension adds abstractions for reading and writing Standard MIDI Files.

Standard MIDI File 1.0 is supported, with support for the MIDI 2.0 version coming in a future update.

See <doc:MIDIKitSMF-Getting-Started> for a quick guide on getting the most out of MIDIKitSMF.

Refer to MIDIKit's own package documentation for information on using MIDI I/O and events.

## Topics

### Introduction

- <doc:MIDIKitSMF-Getting-Started>

### MIDI File

- ``MIDIFile``
- ``MusicalMIDIFile``
- ``SMPTEMIDIFile``

### MIDI File Decoding

- ``MIDIFileDecodeOptions``
- ``MIDIFileChunkDecodeOptions``
- ``MIDIFileDecodeError``

### MIDI File Encoding

- ``MIDIFileEncodeError``

### MIDI File Format

- ``MIDIFileFormat``

### MIDI File Timebase

- ``MusicalMIDIFileTimebase``
- ``SMPTEMIDIFileTimebase``

### MIDI File Chunks

- ``MIDIFile/AnyChunk``
- ``MIDIFile/TrackChunk``
- ``MIDIFile/UndefinedChunk``

### MIDI File Track Chunk

- ``MIDIFileTrackEvent``
- ``MIDIFileTrackEventType``
- ``MIDIFile/TrackChunk/DeltaTime``
- ``MusicalMIDIFileTrackDeltaTime``
- ``SMPTEMIDIFileTrackDeltaTime``

### Related Types

- ``MusicalTimeValue``

### Internals

- <doc:MIDIKitSMF-Internals>
