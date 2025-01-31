# ``MIDIKitInternals``

Internal helper methods used by MIDIKit.

## Overview

These methods are shared internally between MIDIKit targets and not exported by default.

The `MIDIKitInternals` target may be imported if direct access to MIDI packet utilities is needed.

## Topics

### MIDIEventList

- ``CoreMIDI/MIDIEventList/init(protocol:packetWords:timeStamp:)``

### MIDIEventPacket

- ``CoreMIDI/MIDIEventPacket/init(words:timeStamp:)``
- ``CoreMIDI/MIDIEventPacket/rawWords``
- ``Swift/UnsafePointer/rawWords``
- ``Swift/UnsafeMutablePointer/rawWords``

### MIDIPacketList (Legacy)

- ``CoreMIDI/MIDIPacketList/init(data:)-7ftbk``
- ``CoreMIDI/MIDIPacketList/init(data:)-8kgqn``
- ``Swift/UnsafeMutablePointer/init(data:)-10dv0``
- ``Swift/UnsafeMutablePointer/init(data:)-3h6ga``
- ``CoreMIDI/MIDIPacketList/packetPointerIterator(_:)``

### MIDIPacket (Legacy)

- ``CoreMIDI/MIDIPacket/rawBytes``
- ``CoreMIDI/MIDIPacket/rawTimeStamp``
- ``Swift/UnsafePointer/rawBytes``
- ``Swift/UnsafePointer/rawTimeStamp``
- ``Swift/UnsafeMutablePointer/rawBytes``
- ``Swift/UnsafeMutablePointer/rawTimeStamp``

### Errors

- ``MIDIInternalError``
