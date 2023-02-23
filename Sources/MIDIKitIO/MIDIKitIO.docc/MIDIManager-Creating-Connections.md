# Creating Connections

Managed connections are smart MIDI connections owned and maintained by the ``MIDIManager``. They form connections to one or more endpoints and automatically reconnect if the target endpoints disappear and reappear in the system.

## Overview

> In MIDIKit, a connection added to the ``MIDIManager`` instance need only be added once in order to form and maintain a unidirectional connection to one or more MIDI ports in the system.
>
> As a managed connection, once added to the ``MIDIManager`` it will automatically handle re-connecting to the target(s) for the lifecycle of the managed connection.
>
> If the target(s) are not present in the system at the time of creating the managed connection, the ``MIDIManager`` will automatically subscribe to the target(s) if they appear. And if the target(s) disappear at any time, they will likewise be automatically re-subscribed once they appear again.
>
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
        // Note: this handler will be called on a background thread so be
        // sure to call anything that may result in UI updates on the main thread
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

For simple and powerful event filtering API, see the Event Filters topic in MIDIKitCore's docs.

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

## Managed Thru Connections

Core MIDI has a feature called play-thru connections. Events from between 1-8 existing output endpoints can be directly routed to 1-8 existing input endpoints. These can be any endpoints on the system.

These connections can be created in one of two different flavors: non-persistent and persistent.

### Non-Persistent Thru Connection

Non-persistent thru connections are owned by the ``MIDIManager`` and automatically dispose of themselves when it deinits and/or when your app quits.

```swift
try midiManager.addOutputConnection(
    outputs: [],
    inputs: [],
    tag: "ThruConnection1",
    lifecycle: .nonPersistent
)
```

Once created, these can be managed by accessing ``MIDIManager/managedThruConnections``.

### Persistent Thru Connection

Persistent thru connections are stored persistently in the system and are always active, even after app termination and after system reboots.

An owner ID is supplied when creating these connections so that they can be modified or removed later. Typically is ID is a reverse-DNS domain string and usually the application's bundle ID is used.

```swift
try midiManager.addOutputConnection(
    outputs: [],
    inputs: [],
    tag: "ThruConnection1",
    lifecycle: .persistent(ownerID: "com.mydomain.myapp")
)
```

Once created, these are not stored as managed objects in ``MIDIManager``.

Instead, you can access them by reading ``MIDIManager/unmanagedPersistentThruConnections(ownerID:)``.

All persistent connections belonging to a particular owner ID may also be removed all at once by calling ``MIDIManager/removeAllUnmanagedPersistentThruConnections(ownerID:)``.

> Warning: 
> 
> Be careful when creating persistent thru connections, as they can become stale and orphaned if the endpoints used to create them cease to be relevant at any point in time.

> Warning: 
> 
> Due to a Core MIDI bug, persistent thru connections are not functional on macOS 11 & 12 and iOS 14 & 15. On these systems, an error will be thrown. There is no known solution or workaround.

## Topics

### MIDIManager Methods

- ``MIDIManager/addInputConnection(toOutputs:tag:mode:filter:receiver:)-5xxyz``
- ``MIDIManager/addOutputConnection(toInputs:tag:mode:filter:)-3a56s``
- ``MIDIManager/addThruConnection(outputs:inputs:tag:lifecycle:params:)``
