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

There are three options that can work to construct these messages.

Given the example Show Control SysEx bytes `F0 7F 01 02 01 07 0A F7`, the following examples all construct exactly the same message.

1. The ``MIDIEvent/sysEx7(rawBytes:group:)`` constructor will take an array of MIDI 1.0 SysEx bytes.
   
   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawBytes: [0xF0, 0x7F, 0x01, 0x02, 0x01, 0x07, 0x0A, 0xF7]
   )
   ```

2. The ``MIDIEvent/sysEx7(rawHexString:group:)`` constructor does the same thing, but conveniently takes a hex byte string. Hex bytes can be contiguous or padded with a space between them.
   
   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F07F010201070AF7"
   )
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F0 7F 01 02 01 07 0A F7"
   )
   ```

3. The ``MIDIEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:group:)-1p0x1`` constructor will also work since MIDI Show Control specifically uses Universal SysEx format. It just separates the header parts into more descriptive types, as per the MIDI spec. (With this one, you only supply the inner data bytes, so the F0/F7 trailing SysEx bytes and header info is taken care of for you.)
   
   ```swift
   let event: MIDIEvent = try .universalSysEx7(
       universalType: .realTime, // byte two (0x7F)
       deviceID: 0x01, // byte three (<device_ID>)
       subID1: 0x02, // byte four (<msc>)
       subID2: 0x01, // byte five (<command_format>)
       data: [0x07, 0x0A] // byte six and onward; omit trailing 0xF7
   )
   ```

## See Also

- [MIDI Show Control Specification](https://www.midi.org/specifications/midi1-specifications/midi-show-control-2)
