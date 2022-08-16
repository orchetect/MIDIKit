# Creating Connections

Managed connections are smart MIDI connections owned and maintained by the ``MIDIManager``. They form connections to one or more endpoints and automatically reconnect if the target endpoints disappear and reappear in the system.

## Overview

> In MIDIKit, a connection added to the ``MIDIManager`` instance need only be added once in order to form and maintain a unidirectional connection to one or more MIDI ports in the system.

> As a managed connection, once added to the ``MIDIManager`` it will automatically handle re-connecting to the target(s) for the lifecycle of the managed connection.

> If the target(s) are not present in the system at the time of creating the managed connection, the ``MIDIManager`` will automatically subscribe to the target(s) if they appear. And if the target(s) disappear at any time, they will likewise be automatically re-subscribed once they appear again.

> You may supply the target(s) at the time of creation, or create the connection without any target port(s) and add/remove them later by calling ``MIDIInputConnection/add(outputs:)-fshr``, ``MIDIOutputConnection/add(inputs:)-4xbwz``, ``MIDIInputConnection/remove(outputs:)-7zf2d``, or ``MIDIOutputConnection/remove(inputs:)-66yrn``.

### Managed Input Connections

A managed Input Connection receives events from one or more system outputs.

The connection will be reformed automatically if the target endpoint(s) disappear and reappear in the system. Which means you may even create the managed connection and supply target endpoint(s) if those endpoint(s) do not currently appear in the system, as they will be connected as soon as they appear.

Target endpoint(s) can be supplied upon managed connection creation, or added later.

```swift
try midiManager.addInputConnection(
    toOutputs: [],
    tag: "InputConnection1",
    receiveHandler: .events { [weak self] events in
        // Note: this handler will be called on a background thread
        // so call the next line on main if it may result in UI updates
        DispatchQueue.main.async {
            events.forEach { self?.receivedMIDIEvent($0) }
        }
    }
)
```

As a convenience, MIDIKit offers a way to automatically subscribe to receiving events from all MIDI outputs in the system by setting the ``MIDIConnectionMode/allEndpoints`` mode and filtering out ``MIDIEndpointFilter/owned()`` endpoints owned by the ``MIDIManager``.

```swift
try midiManager.addInputConnection(
    toOutputs: [],
    tag: "InputConnection1",
    mode: .allEndpoints, // continually auto-add new outputs that appear
    filter: .owned(), // filter out Manager-owned virtual outputs
    receiveHandler: // add your handler here...
)
```

Add or remove target(s) from the connection at any time:

```swift
let conn = midiManager.managedInputConnections["InputConnection1"]

// add/remove endpoints
conn?.add(outputs: [endpoint])
conn?.remove(outputs: [endpoint])

// add/remove endpoints based on identity criteria such as unique ID
conn?.add(outputs: [.uniqueID(uID)])
conn?.remove(outputs: [.uniqueID(uID)])
```

For simple and powerful event filtering API, see <doc:Event-Filters>.

## Managed Output Connections

A managed Output Connection sends events to one or more system inputs.

The connection will be reformed automatically if the target endpoint(s) disappear and reappear in the system. Which means you may even create the managed connection and supply target endpoint(s) if those endpoint(s) do not currently appear in the system, as they will be connected as soon as they appear.

Target endpoint(s) can be supplied upon managed connection creation, or added later.

```swift
try midiManager.addOutputConnection(
    toInputs: [],
    tag: "OutputConnection1"
)
```

Add or remove target(s) from the connection at any time:

```swift
let conn = midiManager.managedOutputConnections["OutputConnection1"]

// add/remove endpoints
conn?.add(inputs: [endpoint])
conn?.remove(inputs: [endpoint])

// add/remove endpoints based on identity criteria such as unique ID
conn?.add(inputs: [.uniqueID(uID)])
conn?.remove(inputs: [.uniqueID(uID)])
```

## Topics

### MIDIManager Methods

- ``MIDIManager/addInputConnection(toOutputs:tag:mode:filter:receiver:)-5xxyz``
