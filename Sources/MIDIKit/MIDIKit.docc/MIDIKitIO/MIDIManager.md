# ``MIDIKit/MIDIManager``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## 1. Create a Manager Instance

Create an instance of `MIDIManager` within a lifecycle scope that makes sense for your app. 

- Typically MIDI functionality is scoped at an app-level since only one Manager is needed for an entire application's MIDI needs.
- A `MIDIManager` instance can be stored globally, perhaps in your AppDelegate.

Parameters:

- `clientName` is an internal name used only to identify the manager instance to Core MIDI
- `model` is the user-visible model name of your app that is included in the meta-data of virtual ports you create
- `manufacturer` is the user-visible manufacturer, or company name of your app that is included in the meta-data of virtual ports you create

```swift
let midiManager = MIDIManager(
    clientName: "MyAppMIDIManager",
    model: "MyApp",
    manufacturer: "MyCompany"
)
```

> Tip: Typically a single `MIDIManager` instance can handle all MIDI I/O needs for an entire application. It is fully encapsulated however, and it is possible to have more than one instance but even very large and demanding MIDI applications should still only require a single instance.

## 2. Start the Manager

Once the manager instance is created, you must call ``MIDIManager/start()`` before you can create and connections or ports. Subsequent calls to ``MIDIManager/start()`` have no effect after it is first successfully called.

Typically you should only start the manager once, usually at app launch or when MIDI services are first required in your application. The Manager will dispose of itself and all of its ports and connections upon `deinit`.

> Important: Do not destroy and create new `MIDIManager`s during the lifecycle of your application. This is not harmful but it is unnecessary.

```swift
do {
    try midiManager.start()
} catch {
    print("Error while starting MIDI manager: \(error)")
}
```

## A Note About Cleanup

All cleanup is done automatically in MIDIKit and no specific methods are required to be called before application termination.

- `MIDIManager` will dispose of itself and all of its owned virtual ports and connections
- When removing individual ports or connections from a `MIDIManager`, they will dispose of themselves

## Topics

### Instance the Manager

- ``init(clientName:model:manufacturer:notificationHandler:)``

### Start the Manager

- ``start()``

### Create Ports

- ``addInput(name:tag:uniqueID:receiver:)``
- ``addOutput(name:tag:uniqueID:)``

### Create Managed Connections

- ``addInputConnection(toOutputs:tag:mode:filter:receiver:)-5xxyz``
- ``addInputConnection(toOutputs:tag:mode:filter:receiver:)-5r30y``
- ``addInputConnection(toOutputs:tag:mode:filter:receiver:)-100f9``

- ``addOutputConnection(toInputs:tag:mode:filter:)-3a56s``
- ``addOutputConnection(toInputs:tag:mode:filter:)-3mw``
- ``addOutputConnection(toInputs:tag:mode:filter:)-1pqwx``

### Accessing Created Ports and Managed Connections

Ports and managed connections created by the `MIDIManager` can be accessed from these `Dictionary` properties. The keys of the dictionaries correspond to the `tag` parameter that was passed when creating them.

- ``managedInputs``
- ``managedOutputs``
- ``managedInputConnections``
- ``managedOutputConnections``

### Removing Ports and Connections

Remove one or more ports or managed connections from the `MIDIManager`.

- ``remove(_:_:)``
- ``removeAll()``

### Thru Connections

Thru connections are a native feature of Core MIDI that can pass MIDI events from outputs to inputs directly.

- ``addThruConnection(outputs:inputs:tag:lifecycle:params:using:)``
- ``managedThruConnections``
- ``unmanagedPersistentThruConnections(ownerID:)``
- ``removeAllUnmanagedPersistentThruConnections(ownerID:)``

### Accessing Endpoints in the System

Devices contain entities, and entities contain endpoints. Endpoints can be inputs or outputs. For most use cases, simply accessing `endpoints` will be sufficient as it contains all possible endpoints in the system.

- ``devices``
- ``endpoints``

### Core MIDI System Notification Handler

- ``notificationHandler``

### Core MIDI

- ``clientName``
- ``manufacturer``
- ``model``
- ``coreMIDIClientRef``
- ``preferredAPI``