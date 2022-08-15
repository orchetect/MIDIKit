# ``MIDIKit``

An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.

## Overview

- Modular, user-friendly I/O
- Automatic MIDI endpoint connection management and unique ID persistence
- Strongly-typed MIDI events that seamlessly interoperate between MIDI 1.0 and MIDI 2.0
- Automatically uses appropriate Core MIDI API and defaults to MIDI 2.0 on platforms that support them
- Supports Swift Playgrounds on iPad and macOS

See <doc:Getting-Started> for essential information on getting the most from MIDIKit.

## Extensions

Additional functionality can be added to MIDIKit by way of <doc:MIDIKit-Extensions>.

## Topics

### Introduction

- <doc:Getting-Started>
- <doc:Combine-and-SwiftUI-Features>
- <doc:MIDI-Over-Bluetooth>
- <doc:MIDI-Over-Network>
- <doc:MIDIKit-Extensions>

### Manager

- ``MIDIManager``
- <doc:Creating-Ports>
- <doc:Creating-Managed-Connections>
- <doc:Removing-Ports-and-Managed-Connections>
- ``MIDIIONotification``

### Devices & Entities

- ``MIDIManager/devices``
- ``MIDIDevice``
- ``MIDIEntity``

### Endpoints

- ``MIDIManager/endpoints``
- ``MIDIInputEndpoint``
- ``MIDIOutputEndpoint``
- ``AnyMIDIEndpoint``
- ``MIDIEndpointFilter``
- ``MIDIEndpointIdentity``
- ``MIDIIdentifier``
- ``MIDIIdentifierPersistence``

### Events

- ``MIDIEvent``
- <doc:Sending-MIDI-Events>
- <doc:Receiving-MIDI-Events>
- <doc:Event-Filters>

### Value Types

- <doc:MIDI-Value-Types>
- ``MIDINote``
- ``MIDINoteRange``
- ``MIDINoteNumberRange``

### Internals

- <doc:Internals>
