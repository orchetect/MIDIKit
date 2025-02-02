//
//  AssignableController description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.AssignableController: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .raw(
            parameter: parameter,
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            let msb = dataEntryMSB != nil ? "\(dataEntryMSB!)" : "nil (0)"
            let lsb = dataEntryLSB != nil ? "\(dataEntryLSB!)" : "nil (0)"
            return "raw(param: \(parameter), dataMSB: \(msb), dataLSB: \(lsb))"
            
        case .null:
            return "null"
        }
    }
}
