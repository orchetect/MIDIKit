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

### Working with MIDI Files

- ``MIDIFile``
- ``MIDIFileEvent``
- ``MIDIFileEvent/DeltaTime``
- ``MIDINote``

### Protocols

- ``MIDIFileChunk``

### MIDIKit Protocol Conformances

- ``SendsMIDIEvents``
- ``ReceivesMIDIEvents``

### Internals

- <doc:Internals>
- <doc:Internals-From-MIDIKitCore>
