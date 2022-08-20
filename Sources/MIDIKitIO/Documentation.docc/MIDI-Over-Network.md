# MIDI Over Network

Set up Network MIDI connectivity.

To allow Network MIDI connections via Apple's built-in network MIDI feature, enable it by setting the desired connection policy. This is a globally-scoped setting for the application.

- ``setMIDINetworkSession(policy:)``

```swift
setMIDINetworkSession(policy: .anyone)
```

## macOS Entitlements

If the application is sandboxed, ensure the Incoming and Outgoing Connections entitlements are added to your build target:

![App Sandbox Network Entitlements](sandbox-network.png)

## iOS Entitlements

No special entitlements are necessary on iOS.

## Topics

### Global Methods

- ``setMIDINetworkSession(policy:)``

### Related

- ``MIDIIONetworkConnectionPolicy``
