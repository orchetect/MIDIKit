//
//  Parameter ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIParameter {
    /// Parameter Edit section.
    public enum ParameterEdit: Equatable, Hashable {
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

extension HUIParameter.ParameterEdit: HUIParameterProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        case .insertOrParam:  return (0x1C, 0x0)
        case .assign:         return (0x1C, 0x1)
        case .param1Select:   return (0x1C, 0x2)
        case .param2Select:   return (0x1C, 0x3)
        case .param3Select:   return (0x1C, 0x4)
        case .param4Select:   return (0x1C, 0x5)
        case .bypass:         return (0x1C, 0x6)
        case .compare:        return (0x1C, 0x7)
        }
    }
}

extension HUIParameter.ParameterEdit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .insertOrParam:  return "insertOrParam"
        case .assign:         return "assign"
        case .param1Select:   return "param1Select"
        case .param2Select:   return "param2Select"
        case .param3Select:   return "param3Select"
        case .param4Select:   return "param4Select"
        case .bypass:         return "bypass"
        case .compare:        return "compare"
        }
    }
}
