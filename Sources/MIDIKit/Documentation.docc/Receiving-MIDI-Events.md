# Receiving MIDI Events

## Overview

In order to receive MIDI events, there are two primary ways:
- Create a virtual Input.
(``MIDIManager/addInput(name:tag:uniqueID:receiver:)``)

or:

- Form a managed Input Connection that can connect to one or more existing MIDI outputs in the system.
(``MIDIManager/addInputConnection(toOutputs:tag:mode:filter:receiver:)-7ldjl``)

## Topics

### Receive Handlers

- ``MIDIReceiver``

### Protocols

- ``ReceivesMIDIEvents``
