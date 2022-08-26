# Removing Ports and Connections

## Remove Individual Virtual Port or Connection

To remove an individual virtual port or connection owned by the ``MIDIManager`` and dispose of it in the system, call the relevant remove method:

``MIDIManager/remove(_:_:)``

```swift
midiManager.remove(.input, .withTag("VirtualInputTagHere"))
midiManager.remove(.output, .withTag("VirtualOutputTagHere"))
midiManager.remove(.inputConnection, .withTag("InConnTagHere"))
midiManager.remove(.outputConnection, .withTag("OutConnTagHere"))
```

## Remove All of a Type

Additionally, you can remove all of a certain type:

``MIDIManager/remove(_:_:)``

```swift
midiManager.remove(.input, .all)
midiManager.remove(.output, .all)
midiManager.remove(.inputConnection, .all)
midiManager.remove(.outputConnection, .all)
```

## Remove All

Or remove all ports and connections that are owned by the ``MIDIManager`` at once:

``MIDIManager/removeAll()``

```swift
midiManager.removeAll()
```

## Topics

### MIDIManager Methods

- ``MIDIManager/remove(_:_:)``
- ``MIDIManager/removeAll()``
