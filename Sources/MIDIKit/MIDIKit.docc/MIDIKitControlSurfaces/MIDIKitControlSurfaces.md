# MIDIKitControlSurfaces

MIDI control surface protocol abstractions (HUI, etc.) for MIDIKit.

![MIDIKit](midikitcontrolsurfaces-banner.png)

![Layer Diagram](midikitcontrolsurfaces-diagram.svg)

## Topics

### Introduction

- <doc:MIDIKitControlSurfaces-Getting-Started>

### HUI Host (DAW)

- ``HUIHost``
- ``HUIHostBank``
- ``HUIHostEvent``
- <doc:MIDIKitControlSurfaces-Text>

### HUI Surface (Controller)

- ``HUISurface``
- ``HUISurfaceModel``
- ``HUISurfaceModelNotification``
- ``HUISurfaceEvent``

### HUI Common

- ``HUISwitch``

- ``HUIVPot``
- ``HUIVPotDisplay``


### MIDIKit Protocol Conformances

- ``SendsMIDIEvents``
- ``ReceivesMIDIEvents``

### Internals

- <doc:MIDIKitControlSurfaces-Internals>