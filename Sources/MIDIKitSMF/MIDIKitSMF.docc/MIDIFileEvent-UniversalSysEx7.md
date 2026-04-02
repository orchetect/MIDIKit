# Universal System Exclusive 7

Universal System Exclusive (7-bit)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
}

Some standard Universal System Exclusive 7 messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.

- `deviceID` of `0x7F` indicates "All Devices".

## Topics

### Constructors

- ``MIDIFileEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:)-(_,_,_,_,[UInt8])``
- ``MIDIFileEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:)-(_,_,_,_,[UInt7])``

### Switch Case Unwrapping

- ``MIDIFileEvent/universalSysEx7(_:)``
- ``MIDIFileEvent/UniversalSysEx7``
