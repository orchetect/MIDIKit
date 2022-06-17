# EventParsing Example (macOS SwiftUI)

This example demonstrates parsing received MIDI events and reading their values.

## Build Note

⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

## Key Features

- This example creates a virtual MIDI input port named "TestApp Input"
- Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
- Event values are logged in all formats available in MIDIKit:
  - MIDI 1.0 values (ie: 7-bit note velocity, CC value, 14-bit pitch bend, etc.)
  - MIDI 2.0 (ie: 16 and 32-bit values depending on the event)
  - Unit Interval (float between 0.0 ... 1.0)
