# MIDIKit: Getting Started

This is a basic guide intended to give the most essential information on getting set up and running with MIDIKit.

There are many more features and aspects to the library that can be discovered through additional documentation and example projects.

## Import the Library

Add MIDIKit to your project, and import it.

```swift
import MIDIKit
```

## Create a Manager Instance

Create an instance of `MIDI.IO.Manager` within a lifecycle scope that makes sense for your app. 

Typically MIDI functionality is scoped at an app-level, and a single `Manager` instance can be stored in your AppDelegate or even at top level as a global singleton.

- `clientName` is an internal name used only to identify the manager instance to Core MIDI
- `model` is the user-visible model name of your app that is included in the meta-data of virtual ports you create
- `manufacturer` is the user-visible manufacturer, or company name of your app that is included in the meta-data of virtual ports you create

```swift
let midiManager = MIDI.IO.Manager(
    clientName: "MyAppMIDIManager",
    model: "MyApp",
    manufacturer: "MyCompany"
)
```

> 💡 Typically a single `Manager` instance can handle all MIDI I/O needs for an entire application. It is fully encapsulated however, and it is possible to have more than one instance but even very large and demanding MIDI applications should still only require a single instance.

## Start the Manager

> ⚠️ Once the manager instance is created, you must call `start()` before you can create and connections or ports.

```swift
do {
    try midiManager.start()
} catch let err {
    print("Error while starting MIDI manager: \(err)")
}
```

## Enable Network MIDI Sessions

To allow Network MIDI connections via Apple's built-in network MIDI feature, enable it by setting the desired connection policy. This is an app process-wide global setting and is not `Manager` instance-specific, so it is accessed as a static method.

```swift
MIDI.IO.setNetworkSession(policy: .anyone)
```

If the application is sandboxed, ensure the following entitlements are added to your build target:

- App Sandbox
  - [x] Incoming Connections (Server)
  - [x] Outgoing Connections (Client)

## Create Virtual MIDI Ports

If the application is sandboxed, ensure the following entitlements are added to iOS and Catalyst build target:

- Background Modes
  - [x] Audio, AirPlay, and Picture in Picture

### Virtual MIDI Inputs

A virtual input port is created and owned by the `Manager` and will be disposed from the system either when you call `.remove(.output, .withTag())` on the `Manager` or when the `Manager` de-inits.

MIDI events are received on the `receiveHandler:` block on a background thread. If the code in this block may result in UI updates, ensure that you encapsulate it inside a `DispatchQueue.main.async { }` block.

> 💡 By forwarding received events to a handler method (ie: `receivedMIDIEvent(_:)` in this example), you can reuse the same handler method if there are multiple ports or connections that should be funneled to the same receive block. For simple event handling, it can be handled entirely within the `receiveHandler:` closure.

```swift
let inputTag = "Virtual_MIDI_In"

try midiManager.addInput(
    name: "MyApp MIDI In",
    tag: inputTag,
    uniqueID: .userDefaultsManaged(key: inputTag),
    receiveHandler: .events { [weak self] events in
        // Note: this handler will be called on a background thread
        // so call the next line on main if it may result in UI updates
        DispatchQueue.main.async {
            events.forEach { self?.receivedMIDIEvent($0) }
        }
    }
)

private func receivedMIDIEvent(_ event: MIDI.Event) {
    switch event {
    case .noteOn(let payload):
        print("NoteOn:", payload.note, payload.velocity, payload.channel)
    case .noteOff(let payload):
        print("NoteOff:", payload.note, payload.velocity, payload.channel)
    case .cc(let payload):
        print("CC:", payload.controller, payload.value, payload.channel)
    case .programChange(let payload):
        print("PrgCh:", payload.program, payload.channel)
        
    // etc...

    default:
        break
    }
}
```

### Filter Events

For simple and powerful event filtering API, see [Event Filters](Events/Event Filters.md)

### Virtual MIDI Outputs

A virtual output port is created and owned by the `Manager` and will be disposed from the system either when you call `.remove(.output, .withTag())` on the `Manager` or when the `Manager` de-inits.

```swift
let outputTag = "Virtual_MIDI_Out"

try midiManager.addOutput(
    name: "MyApp MIDI Out",
    tag: outputTag,
    uniqueID: .userDefaultsManaged(key: outputTag)
)
```

To send events, call the `.send(event:)` method on the `managedOutputs` dictionary in the `Manager` instance.

```swift
let output = midiManager.managedOutputs[outputTag]
try output?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
try output?.send(event: .cc(11, value: .midi1(64), channel: 0x2))
```

## Create MIDI Connections

> 💡 In MIDIKit, a connection added to the `Manager` instance need only be added once in order to form and maintain a unidirectional connection to one or more MIDI ports in the system.
>
> As a managed connection, once added to the `Manager` it will automatically handle re-connecting to the target(s) for the lifecycle of the managed connection.
>
> If the target(s) are not present in the system at the time of creating the managed connection, the `Manager` will automatically subscribe to the target(s) if they appear. And if the target(s) disappear at any time, they will likewise be automatically re-subscribed once they appear again.

> 💡 You may create the connection without any target port(s) and add/remove them later by calling `.add(:)` or `.remove(:)` on the connection, or supply the target(s) at the time of creation.

### Input Connection

An Input Connection receives events from one or more system outputs.

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

As a convenience, MIDIKit offers a way to automatically subscribe to receiving events from all MIDI outputs in the system by initially adding all `.current()` system endpoints, and setting additional flags on the initializer:

```swift
try midiManager.addInputConnection(
    toOutputs: .current(), // add all current system outputs to start with
    tag: "InputConnection1",
    automaticallyAddNewOutputs: true, // continually auto-add new outputs that appear
    preventAddingManagedOutputs: true, // filter out Manager-owned virtual outputs
    receiveHandler: // add your handler here...
)
```

Add or remove target(s) from the connection at any time:

```swift
let conn = midiManager.managedInputConnections["InputConnection1"]

// add/remove endpoints from the system
conn?.add(outputs: [endpoint])
conn?.remove(outputs: [endpoint])

// add/remove based on criteria such as unique ID
conn?.add(outputs: [.uniqueID(uID)])
conn?.remove(outputs: [.uniqueID(uID)])
```

### Output Connection

An Output Connection sends events to one or more system inputs.

```swift
try midiManager.addOutputConnection(
    toInputs: [],
    tag: "OutputConnection1"
)
```

To send events, call the `.send(event:)` method on the `managedOutputConnections` dictionary in the `Manager` instance.

```swift
let conn = midiManager.managedOutputConnections["OutputConnection1"]
try conn?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
try conn?.send(event: .cc(11, value: .midi1(64), channel: 0x2))
```

Add or remove target(s) from the connection at any time:

```swift
let conn = midiManager.managedOutputConnections["OutputConnection1"]

// add/remove endpoints from the system
conn?.add(inputs: [endpoint])
conn?.remove(inputs: [endpoint])

// add/remove based on criteria such as unique ID
conn?.add(inputs: [.uniqueID(uID)])
conn?.remove(inputs: [.uniqueID(uID)])
```

## Remove a Virtual Port or Connection

To remove an individual virtual port or connection owned by the `Manager` and dispose of it in the system, call the relevant remove method:

```swift
midiManager.remove(.input, .withTag("VirtualInputTagHere"))
midiManager.remove(.output, .withTag("VirtualOutputTagHere"))
midiManager.remove(.inputConnection, .withTag("InConnTagHere"))
midiManager.remove(.outputConnection, .withTag("OutConnTagHere"))
```

Additionally, you can remove all of a certain type:

```swift
midiManager.remove(.input, .all)
midiManager.remove(.output, .all)
midiManager.remove(.inputConnection, .all)
midiManager.remove(.outputConnection, .all)
```

Or remove all ports and connections that are owned by the `Manager` at once:

```swift
midiManager.removeAll()
```

## Cleanup

All cleanup is done automatically in MIDIKit and no specific methods are required to be called before application termination.

- `MIDI.IO.Manager` will dispose of itself and all of its owned virtual ports and connections
- When removing individual ports or connections from a `Manager`, they will dispose of themselves
