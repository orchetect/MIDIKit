# MIDI Over Network

Set up Network MIDI connectivity.

## Overview

Apple platforms offer built-in network MIDI connectivity between a mix of two or more Macs and/or iOS devices. The connection must first be set up by the end-user.

## Setting MIDI Network Session Policy

To allow Network MIDI connections via Apple's built-in network MIDI feature, enable it by setting the desired connection policy. This is a globally-scoped setting for the application.

This needs to only be done once, usually at app startup.

- ``setMIDINetworkSession(policy:)``

```swift
setMIDINetworkSession(policy: .anyone)
```

> The connection policy can be set to ``MIDIIONetworkConnectionPolicy/anyone`` or can be constrained to ``MIDIIONetworkConnectionPolicy/hostsInContactList`` for greater security.

## macOS Entitlements

If the application is sandboxed, ensure the Incoming and Outgoing Connections entitlements are added to your build target:

![App Sandbox Network Entitlements](sandbox-network.png)

## iOS Entitlements

No special entitlements are necessary on iOS.

## Network MIDI Session Connectivity

The connection must first be set up by the end-user. For information on how to form a network MIDI connection between two or more devices, see Apple's [How-To Guide](https://support.apple.com/en-ca/guide/audio-midi-setup/ams1012/mac).

> Warning:
> There is a known issue/bug on some versions of macOS where Live Routings **do not work**.
>
> ![macOS MIDI Network Live Routings](macos-midi-network-live-routings.png)

Once a network MIDI session session is established between devices, MIDI endpoints will be automatically created in the system for each participant in the session. These endpoints will have the same name as the network session name. Access them by getting these properties on the ``MIDIManager`` instance:

- ``MIDIManager/endpoints``.``MIDIEndpoints/inputs``
- ``MIDIManager/endpoints``.``MIDIEndpoints/outputs``

Connect to these endpoints to transmit and receive MIDI over the established network session:

- ``MIDIManager/addInputConnection(to:tag:filter:receiver:)``
- ``MIDIManager/addOutputConnection(to:tag:filter:)``

## Example

There are no Network MIDI example projects because there is no special implementation required (other than setting the [MIDI Network Session Policy](#Setting-MIDI-Network-Session-Policy)). The connection is entirely set up by the end-user in the system as described above. The automatically-created MIDI endpoints can then be used like any other MIDI endpoints.

## Additional Information

Apple's network MIDI uses the RTP-MIDI protocol under the hood. It is generally compatible with any network device that supports RTP-MIDI, including Windows systems. Note that 3rd-party software or drivers may be required on Windows to enable this capability.

## Topics

### Global Methods

- ``setMIDINetworkSession(policy:)``

### Related

- ``MIDIIONetworkConnectionPolicy``
