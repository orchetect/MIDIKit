# Virtual Input Example (AppKit)

This example demonstrates creating a virtual MIDI input and logs received events.

## Key Features

- This example creates a virtual MIDI input port named "TestApp Input"
- Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.

## Troubleshooting

- ⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.
