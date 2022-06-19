# BluetoothMIDI Example (iOS SwiftUI)

This example demonstrates configuring Bluetooth MIDI connections in order to receive MIDI.

## Build Note

⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

## Key Features

- This example demonstrates the use of Apple's Bluetooth MIDI classes to allow your app to configure Bluetooth MIDI connections.
- This example allows receiving MIDI over Bluetooth.

## App Target Entitlements

- Even though Bluetooth MIDI largely operates via Core MIDI, you still need to give your app appropriate entitlements.
- Add the **Background Modes** entitlement and enable the **Audio, AirPlay and Picture in Picture** mode.

![Background Modes](/Users/stef/Dropbox/coding/MIDIKit/Examples/iOS UIKit/BluetoothMIDI/Images/background-modes-audio.png)
