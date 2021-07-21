# MIDIKit

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift-5.3-blue.svg?style=flat"
     alt="Swift 5.3 compatible" /></a>
<a href="#installation">
<img src="https://img.shields.io/badge/SPM-5.3-blue.svg?style=flat"
     alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platforms-macOS%2010.12%20|%20iOS%2010%20-%23989898.svg?style=flat"
     alt="Platforms - macOS 10.12 | iOS 10" /></a>
<a href="https://github.com/orchetect/MIDIKit/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-green.svg?style=flat"
     alt="License: MIT" /></a>

An elegant and modern Swift CoreMIDI wrapper with type-safe handling of MIDI events, MTC, HUI, and SMF (Standard MIDI Files).

### Available Modules

| Module            | Description                         |                          Completion                          | Docs | Tests |
| ----------------- | ----------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `I/O`       | CoreMIDI I/O ports & connections    | ![Progress](https://progress-bar.dev/90/?title=Operational&color=555555&width=80) |  ⚪️   |   🟠   |
| Sync: `MTC.Receiver` | MIDI Timecode Receiver abstraction  | ![Progress](https://progress-bar.dev/100/?title=Complete&color=555555&width=95) |  🟢   |   🟢   |
| Sync: `MTC.Generator` | MIDI Timecode Generator abstraction | ![Progress](https://progress-bar.dev/100/?title=Complete&color=555555&width=95) |  🟢   |   🟢   |

### Modules in Development

| Module          | Description                                    |                          Completion                          | Docs | Tests |
| --------------- | ---------------------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `Events` | MIDI 1.0: events                               | ![Progress](https://progress-bar.dev/50/?title=In%20Progress&color=555555&width=75) |  ⚪️   |   ⚪️   |
| `Events` | MIDI 2.0: events, MIDI-CI, UMP, 1.0 extensions | ![Progress](https://progress-bar.dev/0/?title=Future&color=555555&width=105) |  ⚪️   |   ⚪️   |
| `HUI` | HUI protocol abstraction          | ![Progress](https://progress-bar.dev/50/?title=In%20Progress&color=555555&width=75) |  ⚪️   |   ⚪️   |

### Modules Planned

| Module       | Description                       |                          Completion                          | Docs | Tests |
| ------------ | --------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `SMF` | Standard MIDI 1.0 File read/write | ![Progress](https://progress-bar.dev/80/?title=Future&color=555555&width=105) |  ⚪️   |   🟠   |

## Getting Started

Import the library, and all objects will be accessible under the `MIDI` namespace in your project.

```swift
import MIDIKit
```

See [Examples](https://github.com/orchetect/MIDIKit/blob/master/Examples/) folder and [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder for usage.

## Documentation

See [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder.

## Roadmap

- [ ] MIDI 2.0 support
- [ ] Bluetooth & network MIDI connection support
- [ ] Rewrite of legacy HUI code (♻️ in progress)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Discussion on bug fixes or new features is encouraged before creating pull requests.

Commit messages should be prefixed with the module they are concerned with, generally as follows:

| Commits with changes within   | Commit message prefix                              |
| ----------------------------- | -------------------------------------------------- |
| `/`                           | "Common: "                                         |
| `/Sources/MIDIKit`            | "Common: "                                         |
| `/Sources/MIDIKit/Common`      | "Common: "                                         |
| `/Sources/MIDIKit/Events`      | "Events: "                                         |
| `/Sources/MIDIKit/IO`          | "IO: "                                             |
| `/Sources/MIDIKit/HUI`        | "HUI: "                                           |
| `/Sources/MIDIKit/Sync`        | "Sync: "                                           |
| `/Sources/MIDIKitTestsCommon` | "Common: "                                         |
| `/Tests/<subfolder>`          | use corresponding <subfolder> prefix as seen above |
