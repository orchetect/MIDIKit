//
//  HUISurfaceModel ControlRoom.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModel {
    /// State storage representing the Control Room section.
    public struct ControlRoom: Equatable, Hashable {
        public var input1 = false
        public var input2 = false
        public var input3 = false
        public var discreteInput1to1 = false
        public var mute = false
        
        public var output1 = false
        public var output2 = false
        public var output3 = false
        public var dim = false
        public var mono = false
    }
}

extension HUISurfaceModel.ControlRoom: HUISurfaceModelState {
    public typealias Switch = HUISwitch.ControlRoom

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .input1:             return input1
        case .input2:             return input2
        case .input3:             return input3
        case .discreteInput1to1:  return discreteInput1to1
        case .mute:               return mute
        case .dim:                return dim
        case .mono:               return mono
        case .output1:            return output1
        case .output2:            return output2
        case .output3:            return output3
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .input1:             input1 = state
        case .input2:             input2 = state
        case .input3:             input3 = state
        case .discreteInput1to1:  discreteInput1to1 = state
        case .mute:               mute = state
        case .dim:                dim = state
        case .mono:               mono = state
        case .output1:            output1 = state
        case .output2:            output2 = state
        case .output3:            output3 = state
        }
    }
}
