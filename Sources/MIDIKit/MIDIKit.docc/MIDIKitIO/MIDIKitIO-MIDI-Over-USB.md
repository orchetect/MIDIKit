# MIDI Over USB

Information about MIDI over physical USB connections.

## Overview

Direct USB connectivity is supported natively on macOS and iOS in MIDIKit without any additional code.

## MIDI controller → USB Cable → Mac

- USB MIDI controllers will show up along side all other ``MIDIManager/devices``/``MIDIManager/endpoints`` in the ``MIDIManager``.
  - Controllers that are class-compliant require no driver installation by the user.
  - If the hardware requires drivers, once installed by the user, the device will present itself in the same manner.

## MIDI controller → USB Cable → iOS/iPadOS device

- USB MIDI controllers can be connected to the iOS device by USB-C or Lightning depending on the device. This may involve using Apple's Camera Adapter dongle to adapt the connection.
- Once connected, class-compliant USB MIDI controllers will automatically show up along side all other ``MIDIManager/devices`` and ``MIDIManager/endpoints`` in the ``MIDIManager``.

## iOS Device → USB Cable → Mac

For an end-user to set up a direct USB connection between a Mac and an iOS device, have them follow these steps:

1. On the Mac, open **Audio MIDI Setup.app**.

2. Open the _Audio Devices_ window.

   If it is not already visible, select the _Window -> Audio Devices_ menu to display it.

3. Select the iOS device in the sidebar and click the Enable button.

Bidirectional MIDI connectivity will now be available between the macOS and iOS device over the USB cable.

On iOS, the operating system will create one input and one output endpoint both named "IDAM MIDI Host". These are normal endpoints that show up along side all other ``MIDIManager/endpoints`` in the ``MIDIManager``.

On macOS, the operating system will create one input and one output endpoint with the name of the device (ie: "iPhone" or "iPad"). The iOS device will also appear in the MIDI Studio window of Audio MIDI Setup.

See the [USB iOS to Mac](https://github.com/orchetect/MIDIKit/tree/main/Examples/iOS%20SwiftUI/USB%20iOS%20to%20Mac) example project for more information.
