# Universal System Exclusive 7

Universal System Exclusive (7-bit)

@Comment {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileTrackEvent enum case (`case keySignature(_:)`, etc.)
    //   - MIDIFileTrackEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileTrackEvent type
    // ------------------------------------
}

Some standard Universal System Exclusive 7 messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.

- `deviceID` of `0x7F` indicates "All Devices".

## Topics

### Constructors

- ``MIDIFileTrackEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:)-(_,_,_,_,[UInt8])``
- ``MIDIFileTrackEvent/universalSysEx7(universalType:deviceID:subID1:subID2:data:)-(_,_,_,_,[UInt7])``

### Switch Case Unwrapping

- ``MIDIFileTrackEvent/universalSysEx7(_:)``
- ``MIDIFileTrackEvent/UniversalSysEx7``
