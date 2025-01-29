# EventParsing Example (UIKit)

## Supported Platforms

- iOS / iPadOS
- visionOS
- macOS (Designed for iPad)

## Overview

This example demonstrates parsing received MIDI events and reading their values.

## Key Features

- This example creates a virtual MIDI input port named "TestApp Input"
- Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.
- Event values are logged in all formats available in MIDIKit:
  - MIDI 1.0 values (ie: 7-bit note velocity, CC value, 14-bit pitch bend, etc.)
  - MIDI 2.0 (ie: 16 and 32-bit values depending on the event)
  - Unit Interval (float between 0.0 ... 1.0)

## Troubleshooting

> [!TIP]
> 
> If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

> [!TIP]
> 
> When building for a physical iOS device, you must select your Team ID in the app target's code signing.
