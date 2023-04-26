# Utility Messages

The MIDI 2.0 Spec provides a set of UMP transport-related utility messages, including jitter-reduction messages to help improve event timing.

These messages are available only when using Universal MIDI Packets (UMP).

- Note: This is an advanced feature. These messages are optional and not generally intended to be used by end users. Core MIDI already provides accurate timing at the system/driver level for devices and virtual endpoints and is more than sufficient in the majority of cases.

## Topics

### Constructors (MIDI 2.0)

- ``MIDIEvent/noOp(group:)``

- ``MIDIEvent/jrClock(time:group:)``

- ``MIDIEvent/jrTimestamp(time:group:)``

### Switch Case Unwrapping (MIDI 2.0)

- ``MIDIEvent/noOp(_:)``
- ``MIDIEvent/NoOp``

- ``MIDIEvent/jrClock(_:)``
- ``MIDIEvent/JRClock``

- ``MIDIEvent/jrTimestamp(_:)``
- ``MIDIEvent/JRTimestamp``
