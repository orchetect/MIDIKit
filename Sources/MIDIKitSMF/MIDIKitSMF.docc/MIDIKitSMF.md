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

### MIDI File Timebase

- ``MusicalMIDIFileTimebase``
- ``SMPTEMIDIFileTimebase``

### MIDI File Events

- ``MIDIFileTrackEvent``

### MIDI File (SMF1)

- ``MIDI1File``
- ``MusicalMIDI1File``
- ``SMPTEMIDI1File``

### MIDI File Format (SMF1)

- ``MIDI1FileFormat``

### MIDI File Decoding (SMF1)

- ``MIDI1FileDecodeOptions``
- ``MIDI1FileChunkDecodeOptions``

### MIDI File Chunks (SMF1)

- ``MIDI1File/AnyChunk``
- ``MIDI1File/TrackChunk``
- ``MIDI1File/UndefinedChunk``

### MIDI File Track Chunk (SMF1)

- ``MIDI1FileTrackEvent``
- ``MIDI1FileTrackEventType``
- ``MIDI1File/TrackChunk/DeltaTime``
- ``MusicalMIDI1FileTrackDeltaTime``
- ``SMPTEMIDI1FileTrackDeltaTime``

### Errors

- ``MIDIFileDecodeError``
- ``MIDIFileEncodeError``

### Related Types

- ``MusicalTimeValue``

### Internals

- <doc:MIDIKitSMF-Internals>
