# MIDIKit

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift%205.3-grey.svg?style=flat"
     alt="Swift 5.3 compatible" /></a>
<a href="#installation">
<img src="https://img.shields.io/badge/SPM-grey.svg?style=flat"
     alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platforms-macOS%2010.12%20|%20iOS%2010%20-blue.svg?style=flat"
     alt="Platforms - macOS 10.12 | iOS 10" /></a>
<a href="https://github.com/orchetect/MIDIKit/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat"
     alt="License: MIT" /></a>

A modular Swift CoreMIDI wrapper with type-safe abstraction for MIDI events, MTC, MMC, HUI, and SMF (Standard MIDI Files).

| Module              | Description                         | Completion        | Docs | Tests |
| ------------------- | ----------------------------------- | ----------------- | :--: | :---: |
| `MIDIKit`           | -                                   | -                 |  -   |   -   |
| ─ `MIDIKitIO` 🔌     | CoreMIDI I/O ports & connections    | 🚧 In Progress     |  ⚪️   |   ⚪️   |
| ─ `MIDIKitEvents` 🏷 | MIDI events encoding/decoding       | 🟠 50% • Postponed |  ⚪️   |   ⚪️   |
| ─ `MIDIKitHUI` 🎛    | HUI protocol abstraction            | ⚪️ 50% • Future    |  ⚪️   |   ⚪️   |
| ─ `MIDIKitSMF` 📄    | Standard MIDI File read/write       | 🟠 80% • Future    |  ⚪️   |   🟠   |
| ─ `MIDIKitSync` ⏱   | -                                   | -                 |  -   |   -   |
| ── `MTC.Receiver`   | MIDI Timecode Receiver abstraction  | 🟢 90% • Testing   |  🟢   |   🟢   |
| ── `MTC.Generator`  | MIDI Timecode Generator abstraction | 🟠 Future          |  🟢   |   ⚪️   |
| ── `MMC`            | MIDI Machine Control abstraction    | ⚪️ Future          |  ⚪️   |   ⚪️   |

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

## Roadmap

- [ ] Possible MIDI 2.0 support in future

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/MIDIKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome.