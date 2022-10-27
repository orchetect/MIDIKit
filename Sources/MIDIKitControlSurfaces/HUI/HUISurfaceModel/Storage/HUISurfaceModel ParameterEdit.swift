//
//  HUISurfaceModel ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModel {
    /// State storage representing the Parameter Edit section.
    public struct ParameterEdit: Equatable, Hashable {
        public var assign = false
        public var compare = false
        public var bypass = false
        
        public var param1Select = false
        
        /// Parameter 1 V-Pot Display LEDs.
        public var param1VPotDisplay: HUIVPotDisplay = .init()
        
        public var param2Select = false
        
        /// Parameter 2 V-Pot Display LEDs.
        public var param2VPotDisplay: HUIVPotDisplay = .init()
        
        public var param3Select = false
        
        /// Parameter 3 V-Pot Display LEDs.
        public var param3VPotDisplay: HUIVPotDisplay = .init()
        
        public var param4Select = false
        
        /// Parameter 4 V-Pot Display LEDs.
        public var param4VPotDisplay: HUIVPotDisplay = .init()
        
        /// Toggle: Insert (off) / Param (on)
        public var insertOrParam = false
    }
}

extension HUISurfaceModel.ParameterEdit: HUISurfaceModelState {
    public typealias Switch = HUISwitch.ParameterEdit

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .assign:         return assign
        case .compare:        return compare
        case .bypass:         return bypass
        case .param1Select:   return param1Select
        case .param2Select:   return param2Select
        case .param3Select:   return param3Select
        case .param4Select:   return param4Select
        case .insertOrParam:  return insertOrParam
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .assign:         assign = state
        case .compare:        compare = state
        case .bypass:         bypass = state
        case .param1Select:   param1Select = state
        case .param2Select:   param2Select = state
        case .param3Select:   param3Select = state
        case .param4Select:   param4Select = state
        case .insertOrParam:  insertOrParam = state
        }
    }
}
