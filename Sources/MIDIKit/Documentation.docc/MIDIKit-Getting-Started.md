# Getting Started

Welcome to MIDIKit!

![MIDIKit](midikit-banner.png)

This is a basic guide intended to give the most essential information on getting set up and running with MIDIKit.

There are many more features and aspects to the library that can be discovered through additional documentation and example projects.

## 1. Import the Library

Add MIDIKit to your project, and import it.

```swift
import MIDIKit
```

## 2. Set up the Manager

Follow the steps in the ``MIDIManager`` documentation to create an instance of the manager and start it.

## 3. Set up Bluetooth and Network MIDI if Needed

- <doc:MIDIKit-MIDI-Over-Bluetooth> connectivity for your iOS app
- <doc:MIDIKit-MIDI-Over-Network> on macOS or iOS

## 4. Learn how MIDIKit Value Types Work

MIDIKit was built to use smart hybrid MIDI event value types, simplifying the learning curve to adopting MIDI 2.0 and allowing for a form of value type-erasure. This results in the ability to use MIDI 1.0 values, MIDI 2.0 values, unit intervals or any combination of those - seamlessly regardless whether your platform supports MIDI 1.0 or MIDI 2.0.

Learn how MIDIKit's <doc:MIDI-Value-Types> work.

## 5. Next Steps

From here, you have laid the necessary groundwork to set up ports and connections.

- <doc:MIDIManager-Creating-Ports>
- <doc:MIDIManager-Creating-Connections> to one or more existing MIDI ports in the system
- <doc:MIDIManager-Removing-Ports-and-Connections>
- Learn about powerful <doc:Event-Filters>
- Explore the [Example Projects](https://github.com/orchetect/MIDIKit/blob/main/Examples/)
  - Creating virtual ports and managed connections
  - Creating MIDI endpoint selection menus & controls and persisting user selections
  - Parsing and filtering received MIDI events
  - Working with Bluetooth MIDI
  - Working with Bluetooth MIDI
- Explore add-ons for MIDIKit with <doc:MIDIKit-Extensions>

## 6. Additional Features

MIDIKit contains additional objects and value types.

- term ``MIDINote``: Struct representing a MIDI note with constructors and getters for note number, note name (ie: `"A#-1"`), and frequency in Hz and other metadata. This can be useful for generating UI labels with note names or calculating frequency for synthesis.
- term ``MIDIEventFilterGroup``: Class allowing the configuration of zero or more MIDI event filters in series, capable of applying the filters to arrays of MIDI events.

## Examples

See the [example projects](https://github.com/orchetect/MIDIKit/blob/main/Examples/) for demonstration of best practises in using MIDIKit.

- term **Barebones MIDI listener**:<doc:Simple-MIDI-Listener-Class-Example>

## Troubleshooting


- term **Example projects build but do not run**: Ensure the project's scheme is selected in Xcode first.
- term **Error -50**: This usually happens while trying to interact with the Manager before it's been started, or if your project is sandboxed or targets iOS and the appropriate app entitlements have not been added.
- term **Errors building for React Native**: [See this thread](https://github.com/orchetect/MIDIKit/issues/91) if you are having build errors.
