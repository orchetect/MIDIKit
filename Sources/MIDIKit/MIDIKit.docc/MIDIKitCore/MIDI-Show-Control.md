# MIDI Show Control

Construct MIDI Show Control messages.

## Background

The MIDI Show Control spec says:

> MIDI Show Control uses a single Universal Real Time System Exclusive ID number (sub-ID #1 = 0x02) for all Show commands (transmissions from Controller to Controlled Device).
>
> The format of a Show Control message is as follows:
>
> `F0 7F <device_ID> <msc> <command_format> <command> <data> F7`

## Constructing Events

For details on how to construct System Exclusive messages, see <doc:MIDIEvent-System-Exclusive>.

## See Also

- [MIDI Show Control Specification](https://www.midi.org/specifications/midi1-specifications/midi-show-control-2)
