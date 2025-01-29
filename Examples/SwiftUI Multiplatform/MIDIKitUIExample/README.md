# MIDIKitUI Example (SwiftUI)

## Supported Platforms

- macOS
- iOS / iPadOS
- visionOS

## Overview

This example shows usage of the MIDIKitUI package target SwiftUI controls.

These bundled UI components provide easy-to-use implementations of endpoint selector lists and pickers.

- Updates the UI in realtime to reflect changes in system endpoints.
- Remembers selections between app launches.
- Shows visual feedback when a selection is an endpoint that is currently not present in the system, by displaying a caution symbol next to the list item. This selection will be fully restored when the endpoint reappears in the system.

## Future Development To-Do List

Possible features that may be added in future:

- Multiple-selection list control
- Demonstrate updating connections in the `MIDIManager` on endpoint selection change

## Troubleshooting

> [!TIP]
>
> If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

> [!TIP]
>
> When building for a physical iOS device or "Designed for iPad", you must select your Team ID in the app target's code signing.