//
//  MIDIParameterNumberUtils.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// This is a namespace implemented for MIDI Parameter Number utility functions since
// Swift won't let us declare self-contained static funcs on a protocol (ie: MIDIParameterNumber)
// and then call them on the protocol; it forces us to call them on a concrete
// type that conforms to the protocol which is unnecessary for these util methods.
public enum MIDIParameterNumberUtils {
    /// Utility:
    /// Returns the raw UMP SysEx Status Nibble for the given parameter type and change type.
    public static func umpStatusNibble(
        type: MIDIParameterNumberType,
        change: MIDI2ParameterNumberChange
    ) -> UInt4 {
        switch type {
        case .registered:
            switch change {
            case .absolute:
                0x2
            case .relative:
                0x4
            }
            
        case .assignable:
            switch change {
            case .absolute:
                0x3
            case .relative:
                0x5
            }
        }
    }
    
    /// Utility:
    /// Returns the parameter type and change type for the given raw UMP SysEx Status Nibble.
    /// Returns `nil` if status nibble is invalid.
    public static func typeAndChange(
        fromUMPStatusNibble: UInt4
    ) -> (
        type: MIDIParameterNumberType,
        change: MIDI2ParameterNumberChange
    )? {
        switch fromUMPStatusNibble {
        case 0x2:
            (type: .registered, change: .absolute)
        case 0x3:
            (type: .assignable, change: .absolute)
        case 0x4:
            (type: .registered, change: .relative)
        case 0x5:
            (type: .assignable, change: .relative)
        default:
            nil
        }
    }
}
