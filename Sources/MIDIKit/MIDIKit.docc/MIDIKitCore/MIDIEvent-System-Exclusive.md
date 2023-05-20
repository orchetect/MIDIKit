# System Exclusive

System Exclusive messages carry a header and an arbitrary number of data bytes. These messages are typically used to communicate patch and preset data or binary data payloads such as raw audio samples or device firmware updates. It is up to each software or hardware manufacturer to determine how the data is formatted.

System Exclusives can be divided into two main types which determine their header content:

- System Exclusive
- Universal System Exclusive

MIDI 1.0 supports 7-bit data bytes. In order to encode 8-bit bytes into the data portion, you may need to employ a custom encoding and decoding algorithm. It is up to each software or hardware manufacturer to determine how their data is formatted.

MIDI 2.0 supports both legacy 7-bit System Exclusive messages, as well as a new format where 8-bit data bytes to be used. It is up to each software or hardware manufacturer to determine how their data is formatted. Note that 8-bit System Exclusive is a new format in MIDI 2.0 and is not backwards compatible with MIDI 1.0 or 7-bit System Exclusive whatsoever.

### System Exclusive (7-Bit)

There are several ways to construct 7-bit System Exclusive messages.

Given the example raw MIDI 1.0 SysEx bytes `F0 43 01 02 03 04 F7`, the following examples all construct exactly the same message.

1. The ``MIDIEvent/sysEx7(rawBytes:group:)`` constructor will take an array of MIDI 1.0 SysEx bytes.

   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawBytes: [0xF0, 0x43, 0x01, 0x02, 0x03, 0x04, 0xF7]
   )
   ```

2. The ``MIDIEvent/sysEx7(rawHexString:group:)`` constructor does the same thing, but conveniently takes a hex byte string. Hex bytes can be contiguous or padded with a space between them. An error is thrown if the string is malformed or if not all bytes are valid 7-bit values.

   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F04301020304F7"
   )
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F0 43 01 02 03 04 F7"
   )
   ```

3. The ``MIDIEvent/sysEx7(manufacturer:data:group:)-2xian`` constructor separates the header parts into more descriptive types, as defined by the MIDI spec. (You only supply the payload bytes, so the F0/F7 trailing SysEx bytes and header info is taken care of for you.)

   ```swift
   let event: MIDIEvent = try .sysEx7(
       manufacturer: .oneByte(0x43), // byte two
       data: [0x01, 0x02, 0x03, 0x04] // byte six and seven; omit trailing 0xF7
   )
   ```

- Compatibility: MIDI 1.0 & MIDI 2.0

### Universal System Exclusive (7-Bit)

There are several ways to construct 7-bit Universal System Exclusive messages.

Given the example raw MIDI 1.0 SysEx bytes `F0 7F 01 02 01 07 0A F7`, the following examples all construct exactly the same message.

1. The ``MIDIEvent/sysEx7(rawBytes:group:)`` constructor will take an array of MIDI 1.0 SysEx bytes.

   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawBytes: [0xF0, 0x7F, 0x01, 0x02, 0x01, 0x07, 0x0A, 0xF7]
   )
   ```

2. The ``MIDIEvent/sysEx7(rawHexString:group:)`` constructor does the same thing, but conveniently takes a hex byte string. Hex bytes can be contiguous or padded with a space between them. An error is thrown if the string is malformed or if not all bytes are valid 7-bit values.

   ```swift
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F07F010201070AF7"
   )
   let event: MIDIEvent = try .sysEx7(
       rawHexString: "F0 7F 01 02 01 07 0A F7"
   )
   ```

3. The ``MIDIEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:group:)-1p0x1`` constructor separates the header parts into more descriptive types, as defined by the MIDI spec. (You only supply the payload bytes, so the F0/F7 trailing SysEx bytes and header info is taken care of for you.)
   
   ```swift
   let event: MIDIEvent = try .universalSysEx7(
       universalType: .realTime, // byte two (0x7F)
       deviceID: 0x01, // byte three
       subID1: 0x02, // byte four 
       subID2: 0x01, // byte five
       data: [0x07, 0x0A] // byte six and seven; omit trailing 0xF7
   )
   ```

- Compatibility: MIDI 1.0 & MIDI 2.0

### System Exclusive (8-Bit)

The API to construct 8-bit System Exclusive is the same as described above for 7-bit, except the messages can take 8-bit data bytes. However, note that 8-bit System Exclusive must follow the UMP format and is not compatible with legacy 7-bit System Exclusive.

- See ``MIDIEvent/sysEx8(rawBytes:group:)``
- See ``MIDIEvent/sysEx8(manufacturer:data:group:)``
- Compatibility: MIDI 2.0

### Universal System Exclusive (8-Bit)

The API to construct 8-bit Universal System Exclusive is the same as described above for 7-bit, except the messages can take 8-bit data bytes. However, note that 8-bit Universal System Exclusive must follow the UMP format and is not compatible with legacy 7-bit System Exclusive.

- See ``MIDIEvent/sysEx8(rawBytes:group:)``
- See ``MIDIEvent/universalSysEx8(universalType:deviceID:subID1:subID2:data:group:)``
- Compatibility: MIDI 2.0

## Event Value Types

For an overview of how event value types work (such as note velocity, CC value, etc.) see <doc:MIDIKitCore-Value-Types>.

## Topics

### Constructors

- ``MIDIEvent/sysEx7(manufacturer:data:group:)-2xian``
- ``MIDIEvent/sysEx7(manufacturer:data:group:)-8tnhw``
- ``MIDIEvent/sysEx7(rawHexString:group:)``
- ``MIDIEvent/sysEx7(rawBytes:group:)``
- ``MIDIEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:group:)-1p0x1``
- ``MIDIEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:group:)-150x7``

- ``MIDIEvent/sysEx8(manufacturer:data:group:)``
- ``MIDIEvent/sysEx8(rawBytes:group:)``
- ``MIDIEvent/universalSysEx8(universalType:deviceID:subID1:subID2:data:group:)``

### Switch Case Unwrapping

- ``MIDIEvent/sysEx7(_:)``
- ``MIDIEvent/SysEx7``

- ``MIDIEvent/universalSysEx7(_:)``
- ``MIDIEvent/UniversalSysEx7``

- ``MIDIEvent/sysEx8(_:)``
- ``MIDIEvent/SysEx8``

- ``MIDIEvent/universalSysEx8(_:)``
- ``MIDIEvent/UniversalSysEx8``

### Related

- ``MIDIEvent/SysExID``
- ``MIDIEvent/SysExManufacturer``
- ``MIDIEvent/UniversalSysExType``
