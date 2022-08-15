# ``MIDIKit``

An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.

## Overview

- Modular, user-friendly I/O
- Automatic MIDI endpoint connection management and unique ID persistence
- Strongly-typed MIDI events that seamlessly interoperate between MIDI 1.0 and MIDI 2.0
- Automatically uses appropriate Core MIDI API and defaults to MIDI 2.0 on platforms that support them
- Supports Swift Playgrounds on iPad and macOS

See <doc:MIDIKit-Getting-Started> for essential information on getting the most from MIDIKit.

## Extensions

Additional functionality can be added to MIDIKit by way of <doc:MIDIKit-Extensions>.

## Topics

### Introduction

- <doc:MIDIKit-Getting-Started>
- <doc:MIDIKit-Combine-and-SwiftUI-Features>
- <doc:MIDIKit-MIDI-Over-Bluetooth>
- <doc:MIDIKit-MIDI-Over-Network>
- <doc:MIDIKit-Extensions>

### Manager

- ``MIDIManager``
- <doc:MIDIManager-Creating-Ports>
- <doc:MIDIManager-Creating-Connections>
- <doc:MIDIManager-Removing-Ports-and-Connections>
- <doc:MIDIManager-Receiving-Notifications>

### Devices & Entities

- <doc:Devices>

### Endpoints

- <doc:Endpoints>

### Events

- ``MIDIEvent``
- <doc:Sending-MIDI-Events>
- <doc:Receiving-MIDI-Events>
- <doc:Event-Filters>

### Value Types

- <doc:MIDI-Value-Types>
- <doc:MIDI-Note>

### Internals

- <doc:Internals>
