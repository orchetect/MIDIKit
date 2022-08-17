![MIDIKit](Images/midikit-banner.png)

# MIDIKit

[![CI Build Status](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/MIDIKit/actions/workflows/build.yml) [![Platforms - macOS 10.12+ | iOS 10+ (beta)](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/MIDIKit/blob/main/LICENSE)

An elegant and modern CoreMIDI wrapper in pure Swift supporting MIDI 1.0 and MIDI 2.0.

- Modular, user-friendly I/O
- Automatic MIDI endpoint connection management and identity persistence
- Strongly-typed MIDI events that seamlessly interoperate between MIDI 1.0 and MIDI 2.0
- Automatically uses appropriate Core MIDI API and defaults to MIDI 2.0 on platforms that support it
- Supports Swift Playgrounds on iPad and macOS
- Full documentation available in Xcode Documentation browser, including helpful guides and getting started information

## MIDIKit Extensions

Extensions are available as optional package product imports.

- MIDIKitControlSurfaces: Control Surface protocols (HUI, etc.)
- MIDIKitSync: Synchronization protocols (MTC, etc.)
- MIDIKitSMF: Reading/writing Standard MIDI Files (SMF)

## Getting Started

1. Add MIDIKit as a dependency using Swift Package Manager.
   - In a project or framework:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/MIDIKit`
   
   - In a Swift Package:
     ```swift
     .package(url: "https://github.com/orchetect/MIDIKit", from: "0.6.0")
     ```
  
2. Import the library:
   ```swift
   import MIDIKit
   ```

## Documentation

See the bundled DocC documentation for MIDIKit in Xcode which includes a getting started guide, links to examples, and troubleshooting tips.

## System Compatibility

- Xcode 12.4 / macOS 10.15.7 are minimum requirements to compile
- Once compiled, MIDIKit supports macOS 10.12+ and iOS 10.0+. tvOS and watchOS are not supported (as there is no Core MIDI implementation) but MIDIKit will build successfully on those platforms in the event it is included as a dependency in multi-platform projects.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using MIDIKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Contributions

Contributions are welcome. Discussion in Issues is encouraged prior to new features or modifications.
