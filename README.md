# 🎹 MIDIKit

[![CI Build Status](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml) [![Platforms - macOS 10.12+ | iOS 10+ | tvOS (beta) | watchOS (beta)](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B%20|%20tvOS%20(beta)%20|%20watchOS%20(beta)-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MIDIKit/blob/main/LICENSE)

An elegant and modern Swift CoreMIDI wrapper with:

- strongly-typed protocol-agnostic MIDI events
  - (ie: a single 'note on' event & its value types are homogenous between MIDI 1.0 and 2.0)
- event filters
  - easily filter or drop events by message type, channel, CC number, UMP group, and more
- seamless unified API across **macOS 10.12 Sierra** and later (including **macOS 12.0 Monterey**)
- seamless unified API across **iOS 10** and later (including **iOS 15**)
- beta support for **tvOS** and **watchOS** in development

Back-porting a limited subset of MIDI 2.0 features to older platforms (macOS Catalina or older, and iOS 13 or older) is planned, but not yet supported.

## MIDIKit Extensions

Abstractions are built as optional extensions in their own repos.

- [MIDIKitControlSurfaces](https://github.com/orchetect/MIDIKitControlSurfaces): MIDIKit extension for Control Surfaces (HUI, etc.)
- [MIDIKitSync](https://github.com/orchetect/MIDIKitSync): MIDIKit extension for sync (MTC, etc.)

## Getting Started

1. Add MIDIKit as a dependency  using Swift Package Manager.
   - In an app project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/MIDIKit`
    
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/orchetect/MIDIKit", from: "0.2.0")
     ```
  
1. Import the library:
  ```swift
  import MIDIKit
  ```

3. See [Examples](https://github.com/orchetect/MIDIKit/blob/master/Examples/) folder and [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder for usage.

## Documentation

See [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Discussion in Issues is encouraged prior to new features or modifications.
