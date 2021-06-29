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

A modular Swift CoreMIDI wrapper with type-safe abstraction for MIDI I/O, events, sync and Standard MIDI Files.

### Available Modules

| Module            | Description                         |                          Completion                          | Docs | Tests |
| ----------------- | ----------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `MIDIKitIO`       | CoreMIDI I/O ports & connections    | ![Progress](https://progress-bar.dev/90/?title=Operational&color=555555&width=80) |  ⚪️   |   🟠   |
| `MIDIKitSync`     |                                     |                                                              |      |       |
| ─ `MTC.Receiver`  | MIDI Timecode Receiver abstraction  | ![Progress](https://progress-bar.dev/100/?title=Complete&color=555555&width=95) |  🟢   |   🟢   |
| ─ `MTC.Generator` | MIDI Timecode Generator abstraction | ![Progress](https://progress-bar.dev/100/?title=Complete&color=555555&width=95) |  🟢   |   🟢   |

### Modules in Development

| Module          | Description                                    |                          Completion                          | Docs | Tests |
| --------------- | ---------------------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `MIDIKitEvents` | MIDI 1.0: events                               | ![Progress](https://progress-bar.dev/50/?title=In%20Progress&color=555555&width=75) |  ⚪️   |   ⚪️   |
| `MIDIKitEvents` | MIDI 2.0: events, MIDI-CI, UMP, 1.0 extensions | ![Progress](https://progress-bar.dev/0/?title=Future&color=555555&width=105) |  ⚪️   |   ⚪️   |

### Modules Planned

| Module       | Description                       |                          Completion                          | Docs | Tests |
| ------------ | --------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `MIDIKitHUI` | HUI protocol abstraction          | ![Progress](https://progress-bar.dev/20/?title=Legacy%20Code&color=555555&width=76) |  ⚪️   |   ⚪️   |
| `MIDIKitSMF` | Standard MIDI 1.0 File read/write | ![Progress](https://progress-bar.dev/80/?title=Future&color=555555&width=105) |  ⚪️   |   🟠   |

## Getting Started

Import all modules at once:

```swift
import MIDIKit
```

Or import only specific submodules:

```swift
import MIDIKitIO
import MIDIKitEvents
// etc. ...
```

See [Examples](https://github.com/orchetect/MIDIKit/blob/master/Examples/) folder and [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder for usage.

## Documentation

See [Docs](https://github.com/orchetect/MIDIKit/blob/master/Docs/) folder.

## Roadmap

- [ ] MIDI 2.0 support
- [ ] Bluetooth & network MIDI connection support
- [ ] Rewrite of legacy HUI code

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
| `/Sources/MIDIKitCommon`      | "Common: "                                         |
| `/Sources/MIDIKitEvents`      | "Events: "                                         |
| `/Sources/MIDIKitIO`          | "IO: "                                             |
| `/Sources/MIDIKitSync`        | "Sync: "                                           |
| `/Sources/MIDIKitTestsCommon` | "Common: "                                         |
| `/Tests/<subfolder>`          | use corresponding <subfolder> prefix as seen above |