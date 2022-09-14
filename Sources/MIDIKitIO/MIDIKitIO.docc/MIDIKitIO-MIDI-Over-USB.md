# MIDI Over USB

Information about MIDI over physical USB connections.

## Overview

Direct USB connectivity is supported natively on macOS and iOS in MIDIKit without any additional code.

## USB MIDI controller connected to a Mac

- USB MIDI controllers will show up along side all other ``MIDIManager/devices``/``MIDIManager/endpoints`` in the ``MIDIManager``.
  - Controllers that are class-compliant require no driver installation by the user.
  - If the hardware requires drivers, once installed by the user, the device will present itself in the same manner.

## USB MIDI controller connected to an iOS/iPadOS device

- USB MIDI controllers can be connected to the iOS device by USB-C or Lightning depending on the device. This may involve using Apple's Camera Adapter dongle to adapt the connection.
- Once connected, class-compliant USB MIDI controllers will automatically show up along side all other ``MIDIManager/devices``/``MIDIManager/endpoints`` in the ``MIDIManager``.

## Connecting a Mac to an iOS Device via USB Cable

For an end-user to set up a direct USB connection between a Mac and an iOS device, have them follow these steps:

1. On the Mac, open **Audio MIDI Setup.app**.

2. Open the _Audio Devices_ window.

   If it is not already visible, select the _Window -> Audio Devices_ menu to display it.

3. Select the iOS device in the sidebar and enable it. Configure as desired.

Bidirectional MIDI connectivity will now be available between the macOS and iOS device over the USB cable. Endpoints will show up along side all other ``MIDIManager/devices``/``MIDIManager/endpoints`` in the ``MIDIManager``.
