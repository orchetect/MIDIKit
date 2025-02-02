//
//  HUISwitch ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Parameter Edit section.
    public enum ParameterEdit {
        case assign
        case compare
        case bypass
        case param1Select
        case param2Select
        case param3Select
        case param4Select
        
        // note: four vPots are not switches, they are handled elsewhere
        
        /// Toggle: Insert (off) / Param (on).
        case insertOrParam
    }
}

extension HUISwitch.ParameterEdit: Equatable { }

extension HUISwitch.ParameterEdit: Hashable { }

extension HUISwitch.ParameterEdit: Sendable { }

extension HUISwitch.ParameterEdit: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        case .insertOrParam: (0x1C, 0x0)
        case .assign:        (0x1C, 0x1)
        case .param1Select:  (0x1C, 0x2)
        case .param2Select:  (0x1C, 0x3)
        case .param3Select:  (0x1C, 0x4)
        case .param4Select:  (0x1C, 0x5)
        case .bypass:        (0x1C, 0x6)
        case .compare:       (0x1C, 0x7)
        }
    }
}

extension HUISwitch.ParameterEdit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .insertOrParam: "insertOrParam"
        case .assign:        "assign"
        case .param1Select:  "param1Select"
        case .param2Select:  "param2Select"
        case .param3Select:  "param3Select"
        case .param4Select:  "param4Select"
        case .bypass:        "bypass"
        case .compare:       "compare"
        }
    }
}
