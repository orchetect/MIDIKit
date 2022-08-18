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

- ``MIDIConnectionMode``
- ``MIDIEndpointType``

### MIDI Packets and Parsing

- ``MIDIPacketData``
- ``UniversalMIDIPacketData``
- ``MIDIUMPMessageType``
- ``MIDIUMPSysExStatusField``
- ``MIDIUMPUtilityStatusField``
- ``AnyMIDIPacket``
- ``MIDI1Parser``
- ``MIDI2Parser``
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

- ``MIDIEndpointProtocol``
- ``MIDIIODevicesProtocol``
- ``MIDIIOEndpointsProtocol``
- ``MIDIIOManagedProtocol``
- ``MIDIIOReceivesMIDIMessagesProtocol``
- ``MIDIIOSendsMIDIMessagesProtocol``
- ``MIDIReceiveHandlerProtocol``

### Value Type Protocols

- ``MIDIIntegerProtocol``
