//
//  AssignableController init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.AssignableController {
    /// Initialize an enum case from the controller number.
    /// If a case matching the param bytes is not found, the
    /// ``MIDIEvent/AssignableController/raw(parameter:dataEntryMSB:dataEntryLSB:)`` case will be
    /// returned.
    public init(
        parameter: UInt7Pair,
        data: (msb: UInt7?, lsb: UInt7?)
    ) {
        switch (parameter.msb, parameter.lsb) {
        case (0x7F, 0x7F):
            self = .null // ignore data entry bytes
            
        default:
            self = .raw(
                parameter: parameter,
                dataEntryMSB: data.msb,
                dataEntryLSB: data.lsb
            )
        }
    }
}
