//
//  MIDIKit-0.4.12.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

extension MIDIEvent {
    /// Creates an NRPN message, consisting of multiple MIDI Events.
    @available(
        *,
        unavailable,
        renamed: "ccNRPN(_:channel:group:)",
        message: "NRPN API has been unified with RPN API. Please use the .raw() enum case in place of parameter: dataEntryMSB: dataEntryLSB: parameters."
    )
    public static func ccNRPN(
        parameter: UInt7Pair,
        dataEntryMSB: UInt7?,
        dataEntryLSB: UInt7?,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        CC.Controller.NRPN.raw(
            parameter: parameter,
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        )
        .events(
            channel: channel,
            group: group
        )
    }
    
    /// Parse a complete raw MIDI 1.0 System Exclusive 7 message and return a
    /// ``sysEx7(manufacturer:data:group:)`` or
    /// ``universalSysEx7(universalType:deviceID:subID1:subID2:data:group:)`` case if successful.
    /// Message must begin with `0xF0` but terminating `0xF7` byte is optional.
    ///
    /// - Throws: ``ParseError`` if message is malformed.
    @available(*, unavailable, renamed: "Event.sysEx7(rawBytes:group:)")
    public init(
        sysEx7RawBytes rawBytes: [UInt8],
        group: UInt4 = 0
    ) throws {
        let sysEx = try Self.sysEx7(
            rawBytes: rawBytes,
            group: group
        )
        
        self = sysEx
    }
    
    /// Parse a complete MIDI 2.0 System Exclusive 8 message (starting with the Stream ID byte until
    /// the end of the packet) and return a ``sysEx8(manufacturer:data:group:)`` or
    /// ``universalSysEx8(universalType:deviceID:subID1:subID2:data:group:)`` case if successful.
    ///
    /// Valid rawBytes count is `1 ... 14`. (Must always contain a Stream ID, even if there are zero
    /// data bytes to follow)
    ///
    /// - Throws: ``ParseError`` if message is malformed.
    @available(*, unavailable, renamed: "Event.sysEx8(rawBytes:group:)")
    public init(
        sysEx8RawBytes rawBytes: [UInt8],
        group: UInt4 = 0
    ) throws {
        let sysEx = try Self.sysEx8(
            rawBytes: rawBytes,
            group: group
        )
        
        self = sysEx
    }
}
