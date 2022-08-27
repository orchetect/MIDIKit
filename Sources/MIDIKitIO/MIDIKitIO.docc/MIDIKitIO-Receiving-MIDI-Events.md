# Receiving MIDI Events

## Overview

In order to begin receiving MIDI events, there are two primary mechanisms:

- term ``MIDIManager/addInput(name:tag:uniqueID:receiver:)``: Create a virtual Input.
- term ``MIDIManager/addInputConnection(toOutputs:tag:mode:filter:receiver:)-5xxyz``: Form a managed Input Connection that can connect to one or more existing MIDI outputs in the system.

## Topics

### Receive Handlers

- ``MIDIReceiver``

### Protocols

- ``ReceivesMIDIEvents``
