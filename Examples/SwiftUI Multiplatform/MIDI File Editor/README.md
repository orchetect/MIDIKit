# MIDI File Editor Example (SwiftUI)

## Supported Platforms

- macOS
- iOS / iPadOS
- visionOS

## Overview

This example demonstrates reading and writing Standard MIDI files in a document-based app.

## Key Features

- Create new MIDI files (*File → New*)
- Open MIDI files (*File → Open* or drag files to the app's dock icon on macOS)
- View MIDI file header info
- View and edit chunks
  - View, add, remove, reorder (by dragging), and edit tracks
    - View, add, remove, reorder (by dragging), and edit events on tracks

  - View summary info, remove, reorder (by dragging) for undefined chunks


## Troubleshooting

> [!TIP]
> 
> If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

> [!TIP]
> 
> When building for a physical iOS device or "Designed for iPad", you must select your Team ID in the app target's code signing.
