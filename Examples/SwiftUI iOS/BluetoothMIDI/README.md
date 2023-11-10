# BluetoothMIDI Example (SwiftUI iOS)

This example demonstrates connecting to Bluetooth MIDI devices on iOS and receiving events.

Events received from all MIDI output endpoints are automatically logged to the console.

> **Note**: This project must be run on a physical iOS device. Bluetooth does not function in an iOS Simulator.

## Key Features

- This example demonstrates the use of Apple's Bluetooth MIDI classes to allow your app to configure Bluetooth MIDI connections.

## Info.plist Keys

- The following key is required in the info.plist file with a string containing a reason for allowing your app access to bluetooth connectivity.
  - `NSBluetoothAlwaysUsageDescription`

## Operation

Once Bluetooth connectivity is implemented (see examples above), Bluetooth MIDI devices' ports simply show up as MIDI input or output endpoints in the system. Access them by getting these properties on your `MIDIManager` instance:

- `midiManager.observableEndpoints.inputs`
- `midiManager.observableEndpoints.outputs`

## Troubleshooting

- ⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.
- ⚠️ When building for a physical iOS device, you must select your Team ID in the app target's code signing.
