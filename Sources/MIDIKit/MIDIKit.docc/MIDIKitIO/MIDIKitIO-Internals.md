# Internals

## Topics

### MIDIManager Managed Objects

- ``MIDIInput``
- ``MIDIOutput``
- ``MIDIInputConnection``
- ``MIDIOutputConnection``
- ``MIDIThruConnection``

### Provider Classes and Types

- ``MIDIDevices``
- ``MIDIEndpoints``

### Supporting Types

- ``MIDIInputConnectionMode``
- ``MIDIOutputConnectionMode``
- ``MIDIConnectionMode``
- ``MIDIEndpointType``

### MIDI Packets and Parsing

- ``MIDIPacketData``
- ``UniversalMIDIPacketData``
- ``MIDIUMPMessageType``
- ``MIDIUMPSysExStatusField``
- ``MIDIUMPUtilityStatusField``
- ``MIDIUMPMixedDataSetStatusField``
- ``AnyMIDIPacket``
- ``MIDI1Parser``
- ``MIDI2Parser``
- ``AdvancedMIDI2Parser``
- ``ParameterNumberEventBundler``
- ``MIDIProtocolVersion``

### Core MIDI Related

- ``CoreMIDIAPIVersion``
- ``CoreMIDIClientRef``
- ``CoreMIDIObjectRef``
- ``CoreMIDIPortRef``
- ``CoreMIDIDeviceRef``
- ``CoreMIDIEntityRef``
- ``CoreMIDIEndpointRef``
- ``CoreMIDIThruConnectionRef``
- ``CoreMIDITimeStamp``
- ``CoreMIDIOSStatus``

### Errors

- ``MIDIIOError``
- ``MIDIOSStatus``

### I/O

- ``MIDIIOObject``
- ``MIDIIOObjectType``
- ``AnyMIDIIOObject``

- ``MIDIEndpoint``
- ``MIDIDevicesProtocol``
- ``MIDIEndpointsProtocol``
- ``MIDIManaged``
- ``MIDIManagedReceivesMessages``
- ``MIDIManagedSendsMessages``
