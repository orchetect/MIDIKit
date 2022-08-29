# Creating Ports

Virtual MIDI ports (endpoints) can be created in order to allow the user to send your app MIDI events or receive events that your app sends. These will appear in the system to other software as MIDI ports, similar to physical MIDI ports.

## Overview

### iOS App Target Entitlements

If the application targets iOS or Mac Catalyst, ensure the following entitlements are added to the build target.

- To allow the creation of virtual ports on iOS, add the **Background Modes** entitlement and enable the **Audio, AirPlay and Picture in Picture** mode.

![Background Modes](background-modes-audio.png)

### Virtual Inputs

A virtual input port is created and owned by the ``MIDIManager`` and will be disposed from the system either when you call ``MIDIManager/remove(_:_:)`` on the ``MIDIManager`` or when the ``MIDIManager`` de-inits.

> Note: MIDI events are received on a background thread managed by Core MIDI. If your code in the receive handler closure may result in UI updates, ensure that you dispatch it on the main thread, as demonstrated below.

> Tip: By forwarding received events to a handler method (`func received(midiEvent:)` in this example), you can reuse the same handler method if you plan to use multiple ports or connections that you need to funnel to the same receive block. However for simple event handling, it could be handled entirely within the `receiver:` parameter closure.

```swift
let inputTag = "Virtual_MIDI_In"

try midiManager.addInput(
    name: "MyApp MIDI In",
    tag: inputTag,
    uniqueID: .userDefaultsManaged(key: inputTag),
    receiver: .events { [weak self] events in
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

For the `uniqueID:` parameter It is best to use ``MIDIIdentifierPersistence/userDefaultsManaged(key:suite:)`` which automatically manages the endpoint's Core MIDI identity and restores it each time the same virtual endpoint is created, which other applications rely on to uniquely identify your endpoint so that they can reconnect to it in future.

For simple and powerful event filtering API, see [Event Filters](Event-Filters).

## Virtual Outputs

A virtual output port is created and owned by the ``MIDIManager`` and will be disposed from the system either when you call ``MIDIManager/remove(_:_:)`` or when the manager de-inits. No special clean-up is necessary.

```swift
let outputTag = "Virtual_MIDI_Out"

try midiManager.addOutput(
    name: "MyApp MIDI Out",
    tag: outputTag,
    uniqueID: .userDefaultsManaged(key: outputTag)
)
```

For the `uniqueID:` parameter it is best to use ``MIDIIdentifierPersistence/userDefaultsManaged(key:suite:)`` which automatically manages the endpoint's Core MIDI identity and restores it each time the same virtual endpoint is created, which other applications rely on to uniquely identify your endpoint so that they can reconnect to it in future.

To send events, call the ``MIDIIOSendsMIDIMessagesProtocol/send(event:)`` method on the ``MIDIManager/managedOutputs`` dictionary in the ``MIDIManager`` instance.

```swift
let output = midiManager.managedOutputs[outputTag]
try output?.send(event: .noteOn(60, velocity: .midi1(127), channel: 0x2))
try output?.send(event: .cc(11, value: .midi1(64), channel: 0x2))
```

## Topics

### MIDIManager Methods

- ``MIDIManager/addInput(name:tag:uniqueID:receiver:)``
- ``MIDIManager/addOutput(name:tag:uniqueID:)``
