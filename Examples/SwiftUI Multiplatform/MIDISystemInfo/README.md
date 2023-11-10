# MIDI System Info (SwiftUI macOS/iOS)

This example demonstrates reading MIDI device/port information from the system. It is also a useful diagnostic workbench.

The example app's structure is using legacy `NSApplicationDelegate`/`UIApplicationDelegate` in order to maintain backwards compatibility with macOS 10.10 and iOS 13. 

## Key Features

- Lists devices, their entities, and their endpoints in a navigation tree
- Displays all available properties and their values for quick inspection/diagnostics
- Updates in real-time in response to MIDI devices/endpoints appearing or disappearing in the system

## Troubleshooting

- ⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.
- ⚠️ When building for a physical iOS device or "Designed for iPad", you must select your Team ID in the app target's code signing.
