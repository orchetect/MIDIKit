# VirtualInput Example (iOS UIKit)

This example demonstrates creating a virtual MIDI input and logs received events.

## Build Note

⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

## Key Features

- This example creates a virtual MIDI input port named "TestApp Input"
- Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
- Event values are logged in their native format.
  - On modern operating systems supporting MIDI 2.0, event values will be natively received as MIDI 2.0 values.
  - Regardless, MIDI 1.0 ←→ MIDI 2.0 values are always seamlessly convertible. See the MIDIKit Wiki for details.
