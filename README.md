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

A modular Swift CoreMIDI wrapper with type-safe abstraction for MIDI events, MTC, MMC, HUI, and SMF (Standard MIDI Files).

### Available Modules

| Module           | Description                        |                          Completion                          | Docs | Tests |
| ---------------- | ---------------------------------- | :----------------------------------------------------------: | :--: | :---: |
| `MIDIKitIO`      | CoreMIDI I/O ports & connections   | ![Progress](https://progress-bar.dev/80/?title=Testing&color=555555&width=95) |  ⚪️   |   🟠   |
| `MIDIKitSync`    |                                    |                                                              |      |       |
| ─ `MTC.Receiver` | MIDI Timecode Receiver abstraction | ![Progress](https://progress-bar.dev/90/?title=Testing&color=555555&width=95) |  🟢   |   🟢   |

### Modules in Development

| Module            | Description                         | Completion     | Docs | Tests |
| ----------------- | ----------------------------------- | :------------: | :--: | :---: |
| `MIDIKitEvents`   | MIDI events encoding/decoding       | ![Progress](https://progress-bar.dev/50/?title=Postponed&color=555555&width=80) |  ⚪️   |   ⚪️   |
| `MIDIKitHUI`      | HUI protocol abstraction            | ![Progress](https://progress-bar.dev/40/?title=Future&color=555555&width=98) |  ⚪️   |   ⚪️   |
| `MIDIKitSMF`      | Standard MIDI File read/write       | ![Progress](https://progress-bar.dev/80/?title=Future&color=555555&width=98) |  ⚪️   |   🟠   |
| `MIDIKitSync`     |                                     |               |      |       |
| ─ `MTC.Generator` | MIDI Timecode Generator abstraction | ![Progress](https://progress-bar.dev/0/?title=Future&color=555555&width=98) |  🟢   |   ⚪️   |
| ─ `MMC`           | MIDI Machine Control abstraction    | ![Progress](https://progress-bar.dev/0/?title=Future&color=555555&width=98) |  ⚪️   |   ⚪️   |

## Getting Started

Import all modules at once:

```swift
import MIDIKit
//     ├→ imports: MIDIKitIO
//     ├→ imports: MIDIKitEvents
//     └→ etc. ...
```

Or import only specific submodules:

```swift
import MIDIKitIO
import MIDIKitEvents
```

For documentation on how each module works, see individual module README files.

## Roadmap

- [ ] Possible MIDI 2.0 support in future
- [ ] Bluetooth & network MIDI connection support

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Discussion on bug fixes or new features is encouraged before creating pull requests.

Individual commits should have commit messages prefixed with the module they are concerned with, as follows:

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
