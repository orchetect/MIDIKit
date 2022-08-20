# ``MIDIKitIO``

Core MIDI I/O wrapper layer offering ``MIDIManager`` class to create virtual ports and connect to existing ports in the system in order to send and receive MIDI events.

![MIDIKit](midikit-banner.png)

MIDIKitIO adds an I/O layer on top of MIDIKitCore's MIDI events, providing the essentials to send and receive MIDI events on Apple platforms.

To add additional functionality, import extension modules or import the MIDIKit umbrella library which imports all of MIDIKit events, I/O, and extensions.

## Topics

### Introduction

- <doc:Getting-Started>

### Manager

- ``MIDIManager``
- <doc:MIDIManager-Creating-Ports>
- <doc:MIDIManager-Creating-Connections>
- <doc:MIDIManager-Removing-Ports-and-Connections>
- <doc:MIDIManager-Receiving-Notifications>
- <doc:MIDIKit-Combine-and-SwiftUI-Features>

### Devices & Entities

- <doc:Devices>

### Endpoints

- <doc:Endpoints>

### Events

- <doc:Sending-MIDI-Events>
- <doc:Receiving-MIDI-Events>

### Extending Connectivity

- <doc:MIDI-Over-Bluetooth>
- <doc:MIDI-Over-Network>

### Internals

- <doc:Internals>
- <doc:Internals-From-MIDIKitCore>
