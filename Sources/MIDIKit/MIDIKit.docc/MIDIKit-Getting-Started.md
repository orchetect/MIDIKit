# Getting Started

Welcome to MIDIKit!

![MIDIKit](midikit-banner.png)

This is a basic guide intended to give the most essential information on getting set up and running with MIDIKit I/O and events.

There are many more features and aspects to the library that can be discovered through additional documentation and example projects.

## Table of Contents

1. [Import the Library](#1-Import-the-Library)
2. [Set up the Manager](#2-Set-up-the-Manager)
3. [Additional Connectivity: Bluetooth, Network, USB](#3-Additional-Connectivity-Bluetooth-Network-USB)
4. [Learn how MIDIKit Value Types Work](#4-Learn-how-MIDIKit-Value-Types-Work)
5. [Constructing Events](#5-Constructing-Events)
6. [Create Ports and Connections](#6-Create-Ports-and-Connections)
7. [Example Projects](#7-Example-Projects)
8. [Additional Features](#8-Additional-Features)
9. [Additional Guides](#9-Additional-Guides)

## 1. Import the Library

MIDIKit is modular and allows for flexible configuration of imports.

**Everything**

To import the whole library:

- Add the `MIDIKit` package product to your project, and import it.

  ```swift
  import MIDIKit
  // implicitly imports -> MIDIKitCore
  // implicitly imports -> MIDIKitIO
  // implicitly imports -> MIDIKitSMF
  // implicitly imports -> MIDIKitSync
  // implicitly imports -> MIDIKitControlSurfaces
  ```

**Essentials**

If only MIDI I/O and MIDI Events are needed:

- Add the `MIDIKitIO` package product to your project, and import it.

  ```swift
  import MIDIKitIO
  // implicitly imports -> MIDIKitCore
  ```

**Bare Bones**

If only core types and MIDI event definitions are needed, without I/O:

- Add the `MIDIKitCore` package product to your project, and import it.

  ```swift
  import MIDIKitCore
  ```

**Area of Specialty**

If only a specific extension is needed along with I/O:

- Add the extension product (ie: `MIDIKitSync`) product along with the I/O product `MIDIKitIO` to your project, and import them.

  ```swift
  import MIDIKitIO
  // implicitly imports -> MIDIKitCore
  import MIDIKitSync
  ```

**Just MIDI Files**

If you are only working with Standard MIDI Files and do not require I/O or any extensions:

- Add the `MIDIKitSMF` package product to your project, and import it.

  ```swift
  import MIDIKitSMF
  // implicitly imports -> MIDIKitCore
  ```

## 2. Set up the Manager

Follow the steps in the ``MIDIManager`` documentation to create an instance of the manager and start it.

## 3. Additional Connectivity: Bluetooth, Network, USB

- See <doc:MIDIKitIO-MIDI-Over-Bluetooth> for Bluetooth MIDI connectivity for your iOS app
- See <doc:MIDIKitIO-MIDI-Over-Network> for network MIDI connectivity on macOS or iOS
- See <doc:MIDIKitIO-MIDI-Over-USB> for USB connectivity information on macOS or iOS

## 4. Learn how MIDIKit Value Types Work

MIDIKit was built to use smart hybrid MIDI event value types, simplifying the learning curve to adopting MIDI 2.0 and allowing for a form of value type-erasure. This results in the ability to use MIDI 1.0 values, MIDI 2.0 values, unit intervals or any combination of those - seamlessly regardless whether your platform supports MIDI 1.0 or MIDI 2.0.

Learn how MIDIKit's value types work: <doc:MIDIKitCore-Value-Types>

## 5. Constructing Events

- Learn how to construct ``MIDIKit/MIDIEvent``s
- Learn about powerful <doc:MIDIKitCore-Event-Filters>

## 6. Create Ports and Connections

From here, you have laid the necessary groundwork to set up ports and connections.

- <doc:MIDIManager-Creating-Ports>
- <doc:MIDIManager-Creating-Connections> to one or more existing MIDI ports in the system
- <doc:MIDIManager-Removing-Ports-and-Connections>

## 7. Example Projects

- Explore the [Example Projects](https://github.com/orchetect/MIDIKit/blob/main/Examples/)
  - Creating virtual ports and managed connections
  - Creating MIDI endpoint selection menus & controls and persisting user selections
  - Parsing and filtering received MIDI events
  - Working with Bluetooth MIDI
- Explore MIDI extension modules included in MIDIKit: <doc:MIDIKitUI>, <doc:MIDIKitSMF>, <doc:MIDIKitSync>, <doc:MIDIKitControlSurfaces>.

## 8. Additional Features

MIDIKit contains additional objects and value types.

- term ``MIDINote``: Struct representing a MIDI note with constructors and getters for note number, note name (ie: `"A#-1"`), and frequency in Hz and other metadata. This can be useful for generating UI labels with note names or calculating frequency for synthesis.
- term ``MIDIEventFilterGroup``: Struct allowing the configuration of zero or more MIDI event filters in series, capable of applying the filters to arrays of MIDI events.

## 9. Additional Guides

- <doc:MIDI-Show-Control>
- <doc:Send-and-Receive-on-iOS-in-Background>

## Examples

See the [example projects](https://github.com/orchetect/MIDIKit/blob/main/Examples/) for demonstration of best practises in using MIDIKit.

- term **Barebones MIDI listener**:<doc:Simple-MIDI-Listener-Class-Example>

## Troubleshooting

- term **Example projects build but do not run**: Ensure the project's scheme is selected in Xcode first.
- term **Error -50**: This usually happens while trying to interact with the ``MIDIManager`` before it's been started, or if your project is sandboxed or targets iOS and the appropriate app entitlements have not been added.
- term **Errors building for React Native**: [See this thread](https://github.com/orchetect/MIDIKit/issues/91) if you are having build errors.

## Topics

### Simple Examples

- <doc:Simple-MIDI-Listener-Class-Example>
