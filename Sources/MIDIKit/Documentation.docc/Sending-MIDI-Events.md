# Sending MIDI Events

## Overview

In order to send MIDI events, there are two primary ways:
- Create a virtual Output.
  (``MIDIManager/addOutput(name:tag:uniqueID:)``)

or:

- Form a managed Output Connection that can connect to one or more existing MIDI inputs in the system.
(``MIDIManager/addOutputConnection(toInputs:tag:mode:filter:)-3a56s``)

### Send events from a created Output

To send events, call the ``MIDIIOSendsMIDIMessagesProtocol/send(event:)`` method on the ``MIDIManager/managedOutputs`` dictionary.

The dictionary key corresponds to the `tag` property that was specified at the time of creating the connection in the ``MIDIManager``.

```swift
let conn = midiManager.managedOutputs["Output1"]
try conn?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
```

### Send events from a managed Output Connection

To send events, call the ``MIDIIOSendsMIDIMessagesProtocol/send(event:)`` method on the ``MIDIManager/managedOutputConnections`` dictionary.

The dictionary key corresponds to the `tag` property that was specified at the time of creating the connection in the ``MIDIManager``.

```swift
let conn = midiManager.managedOutputConnections["OutputConnection1"]
try conn?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
```

## Topics

### Send Methods

- ``MIDIIOSendsMIDIMessagesProtocol/send(event:)``
- ``MIDIIOSendsMIDIMessagesProtocol/send(events:)``

### Protocols

- ``SendsMIDIEvents``
