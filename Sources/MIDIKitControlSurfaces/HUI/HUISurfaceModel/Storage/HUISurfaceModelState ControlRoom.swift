//
//  HUISurfaceModelState ControlRoom.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Control Room section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class ControlRoom {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.ControlRoom: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.ControlRoom
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .input1:            input1
        case .input2:            input2
        case .input3:            input3
        case .discreteInput1to1: discreteInput1to1
        case .mute:              mute
        case .dim:               dim
        case .mono:              mono
        case .output1:           output1
        case .output2:           output2
        case .output3:           output3
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .input1:            input1 = state
        case .input2:            input2 = state
        case .input3:            input3 = state
        case .discreteInput1to1: discreteInput1to1 = state
        case .mute:              mute = state
        case .dim:               dim = state
        case .mono:              mono = state
        case .output1:           output1 = state
        case .output2:           output2 = state
        case .output3:           output3 = state
        }
    }
}
