# Working with Devices

Devices represent physical devices that contain entity(ies) which in turn contain endpoint(s).

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

In most use cases, it is not necessary work with devices and entities. A single pair of endpoint collections (inputs and outputs) may be accessed directly which contains all endpoints that exist in the system. See <doc:MIDIKitIO-Endpoints> for more information.  

## Topics

### Devices in the System

- ``MIDIManager/devices``
- ``ObservableMIDIManager/observableDevices``

### Device and Entity Objects

- ``MIDIDevice``
- ``MIDIEntity``
