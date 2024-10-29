//
//  HUISurfaceModelState FunctionKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Function Key section.
    public struct FunctionKey: Equatable, Hashable {
        public var f1 = false
        public var f2 = false
        public var f3 = false
        public var f4 = false
        public var f5 = false
        public var f6 = false
        public var f7 = false
        public var f8OrEsc = false
    }
}

extension HUISurfaceModelState.FunctionKey: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.FunctionKey

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .f1:         return f1
        case .f2:         return f2
        case .f3:         return f3
        case .f4:         return f4
        case .f5:         return f5
        case .f6:         return f6
        case .f7:         return f7
        case .f8OrEsc:    return f8OrEsc
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .f1:         f1 = state
        case .f2:         f2 = state
        case .f3:         f3 = state
        case .f4:         f4 = state
        case .f5:         f5 = state
        case .f6:         f6 = state
        case .f7:         f7 = state
        case .f8OrEsc:    f8OrEsc = state
        }
    }
}
