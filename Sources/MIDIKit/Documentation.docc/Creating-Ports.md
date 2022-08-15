# Creating Ports

Virtual MIDI ports (endpoints) can be created in order to allow the user to send your app MIDI events or receive events that your app sends. These will appear in the system to other software as MIDI ports, similar to physical MIDI ports.

## Overview

### iOS App Target Entitlements

If the application targets iOS or Mac Catalyst, ensure the following entitlements are added to the build target.

- Even though Bluetooth MIDI largely operates via Core MIDI, you still need to give your app appropriate entitlements.
- Add the **Background Modes** entitlement and enable the **Audio, AirPlay and Picture in Picture** mode.

![Background Modes](background-modes-audio.png)

### Virtual Inputs

A virtual input port is created and owned by the ``MIDIManager`` and will be disposed from the system either when you call ``MIDIManager/remove(_:_:)`` on the `Manager` or when the ``MIDIManager`` de-inits.

MIDI events are received on the `receiveHandler:` block on a background thread. If the code in this block may result in UI updates, ensure that you encapsulate it inside a `DispatchQueue.main.async { }` block.

> By forwarding received events to a handler method (ie: `func received(midiEvent:)` in this example), you can reuse the same handler method if you plan to use multiple ports or connections that you need to funnel to the same receive block. However for simple event handling, it could be handled entirely within the `receiveHandler:` closure.

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
            events.forEach { self?.received(midiEvent: $0) }
        }
    }
)

private func received(midiEvent: MIDIEvent) {
    switch midiEvent {
    case .noteOn(let payload):
        print("Note On:", payload.note, payload.velocity, payload.channel)
    case .noteOff(let payload):
        print("Note Off:", payload.note, payload.velocity, payload.channel)
    case .cc(let payload):
        print("CC:", payload.controller, payload.value, payload.channel)
    case .programChange(let payload):
        print("Program Change:", payload.program, payload.channel)
        
    // etc...

    default:
        break
    }
}
```

For `uniqueID` It is best to use `.userDefaultsManaged` which automatically manages the endpoint's Core MIDI identity and restores it each time the same virtual endpoint is created, which other applications rely on to uniquely identify your endpoint so that they can reconnect to it in future.

For simple and powerful event filtering API, see [Event Filters](Event-Filters).

## Virtual Outputs

A virtual output port is created and owned by the `Manager` and will be disposed from the system either when you call `.remove(.output, .withTag())` on the `Manager` or when the `Manager` de-inits.

```swift
let outputTag = "Virtual_MIDI_Out"

try midiManager.addOutput(
    name: "MyApp MIDI Out",
    tag: outputTag,
    uniqueID: .userDefaultsManaged(key: outputTag)
)
```

For `uniqueID` it is best to use `.userDefaultsManaged(key:)` which automatically manages the endpoint's Core MIDI identity and restores it each time the same virtual endpoint is created, which other applications rely on to uniquely identify your endpoint so that they can reconnect to it in future.

To send events, call the `.send(event:)` method on the `managedOutputs` dictionary in the `Manager` instance.

```swift
let output = midiManager.managedOutputs[outputTag]
try output?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
try output?.send(event: .cc(11, value: .midi1(64), channel: 0x2))
```

## Topics

### Creating Ports

- ``MIDIManager/addInput(name:tag:uniqueID:receiver:)``
- ``MIDIManager/addOutput(name:tag:uniqueID:)``
