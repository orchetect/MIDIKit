# ``SwiftMIDI``

Umbrella package that includes all SwiftMIDI extensions.

![swift-midi](swift-midi-banner.png)

![Topology Diagram](swift-midi-topology.svg)

## Getting Started

This is a basic guide intended to give the most essential information on getting set up and running with SwiftMIDI.

There are many more features and aspects to the library that can be discovered through additional documentation and example projects.

## Table of Contents

- [Import the Library](#Import-the-Library)
- [Events and Value Types](#Events-and-Value-Types)
- [Setting up I/O](#Setting-up-IO)
- [Examples](#Examples)
- [Troubleshooting](#Troubleshooting)

## Import the Library

Add the `SwiftMIDI` package product to your project, and import it.

```swift
import SwiftMIDI
```

This will import the whole library and make available all extensions:

- [swift-midi-controlsurfaces](https://github.com/orchetect/swift-midi-controlsurfaces)
- [swift-midi-core](https://github.com/orchetect/swift-midi-core)
- [swift-midi-file](https://github.com/orchetect/swift-midi-file)
- [swift-midi-io](https://github.com/orchetect/swift-midi-io)
- [swift-midi-sync](https://github.com/orchetect/swift-midi-sync)
- [swift-midi-ui](https://github.com/orchetect/swift-midi-ui)

> Tip:
>
> SwiftMIDI is a modular set of repositories. Using the main `swift-midi` umbrella repository as a dependency will implicitly import all extensions. If only a subset of features is required, consider importing only the specific packages that are needed instead.

## Events and Value Types

See the [SwiftMIDI Core documentation](https://swiftpackageindex.com/orchetect/swift-midi-core/main/documentation/swiftmidicore/getting-started) for a getting started guide on MIDI events and value types.

## Setting up I/O

See the [SwiftMIDI I/O documentation](https://swiftpackageindex.com/orchetect/swift-midi-io/main/documentation/swiftmidiio/getting-started) for a getting started guide on MIDI events and value types.

## Examples

See the [example projects](https://github.com/orchetect/swift-midi-examples) for demonstration of best practises in using SwiftMIDI.

## Troubleshooting

- term **Example projects build but do not run**: Ensure the project's scheme is selected in Xcode first.
- term **Errors building for React Native**: [See this thread](https://github.com/orchetect/swift-midi/issues/91) if you are having build errors.
