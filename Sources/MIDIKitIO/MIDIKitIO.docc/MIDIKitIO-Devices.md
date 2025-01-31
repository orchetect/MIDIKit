# Working with Devices

Devices represent physical devices that contain entity(ies) which in turn contain endpoint(s).

An example device hierarchy may look like this:

- Device 1
  - Entity 1
    - Input Endpoint 1
    - Input Endpoint 2
    - Output Endpoint 1
    - Output Endpoint 2
  - Entity 2
    - Input Endpoint 1
    - Output Endpoint 1
- Device 2
  - Entity 1
    - Output Endpoint 1
    - Output Endpoint 2

etc.

In most use cases, it is not necessary work with devices and entities. In the vast majority of software that supports MIDI, a flat list of all available endpoints are what are presented to users when selecting inputs or outputs.

Endpoint collections (inputs and outputs) may be accessed directly without requiring device or entity interaction at all. See <doc:MIDIKitIO-Endpoints> for more information.  

## Topics

### Devices (MIDIManager)

- ``MIDIManager/devices``

### Devices (ObservableMIDIManager)

- ``ObservableMIDIManager/devices``

### Devices (ObservableObjectMIDIManager)

- ``ObservableObjectMIDIManager/devices``

### Device and Entity Objects

- ``MIDIDevice``
- ``MIDIEntity``
