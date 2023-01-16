//
//  HUISurfaceModel NumPad.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModel {
    /// State storage representing Number Pad Keys on the HUI surface.
    public struct NumPad: Equatable, Hashable {
        public var num0 = false
        public var num1 = false
        public var num2 = false
        public var num3 = false
        public var num4 = false
        public var num5 = false
        public var num6 = false
        public var num7 = false
        public var num8 = false
        public var num9 = false
        
        public var period = false       // .
        public var plus = false         // +
        public var minus = false        // -
        public var enter = false        // ENTER
        public var clr = false          // clr
        public var equals = false       // =
        public var forwardSlash = false // /
        public var asterisk = false     // *
    }
}

extension HUISurfaceModel.NumPad: HUISurfaceModelState {
    public typealias Switch = HUISwitch.NumPad

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .num0:          return num0
        case .num1:          return num1
        case .num2:          return num2
        case .num3:          return num3
        case .num4:          return num4
        case .num5:          return num5
        case .num6:          return num6
        case .num7:          return num7
        case .num8:          return num8
        case .num9:          return num9
        
        case .period:        return period
        case .plus:          return plus
        case .minus:         return minus
        case .enter:         return enter
        case .clr:           return clr
        case .equals:        return equals
        case .forwardSlash:  return forwardSlash
        case .asterisk:      return asterisk
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .num0:          num0 = state
        case .num1:          num1 = state
        case .num2:          num2 = state
        case .num3:          num3 = state
        case .num4:          num4 = state
        case .num5:          num5 = state
        case .num6:          num6 = state
        case .num7:          num7 = state
        case .num8:          num8 = state
        case .num9:          num9 = state
        
        case .period:        period = state
        case .plus:          plus = state
        case .minus:         minus = state
        case .enter:         enter = state
        case .clr:           clr = state
        case .equals:        equals = state
        case .forwardSlash:  forwardSlash = state
        case .asterisk:      asterisk = state
        }
    }
}
