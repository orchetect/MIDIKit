# ``MIDIKitIO``

Core MIDI I/O wrapper layer offering ``MIDIManager`` class to create virtual ports and connect to existing ports in the system in order to send and receive MIDI events.

![MIDIKit](midikit-banner.png)

![Layer Diagram](midikitio-diagram.svg)

MIDIKitIO adds an I/O layer on top of MIDIKitCore's MIDI events, providing the essentials to send and receive MIDI events on Apple platforms.

To add additional functionality, import extension modules or import the MIDIKit umbrella library which imports all of MIDIKit events, I/O, and extensions.

## Topics

### Manager

- ``MIDIManager``
- <doc:MIDIManager-Creating-Ports>
- <doc:MIDIManager-Creating-Connections>
- <doc:MIDIManager-Removing-Ports-and-Connections>
- <doc:MIDIManager-Receiving-Notifications>
- ``ObservableMIDIManager``
- <doc:MIDIKitIO-SwiftUI-and-Combine-Features>

### Devices & Entities

- <doc:MIDIKitIO-Devices>

### Endpoints

- <doc:MIDIKitIO-Endpoints>

### Events

- <doc:MIDIKitIO-Sending-MIDI-Events>
- <doc:MIDIKitIO-Receiving-MIDI-Events>

### Extending Connectivity

- <doc:MIDIKitIO-MIDI-Over-Bluetooth>
- <doc:MIDIKitIO-MIDI-Over-Network>
- <doc:MIDIKitIO-MIDI-Over-USB>

### Additional Guides

- <doc:Send-and-Receive-on-iOS-in-Background>

### Internals

- <doc:MIDIKitIO-Internals>
