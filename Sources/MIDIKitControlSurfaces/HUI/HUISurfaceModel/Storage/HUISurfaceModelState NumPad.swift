//
//  HUISurfaceModelState NumPad.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing Number Pad Keys on the HUI surface.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class NumPad {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.NumPad: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.NumPad
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .num0:         num0
        case .num1:         num1
        case .num2:         num2
        case .num3:         num3
        case .num4:         num4
        case .num5:         num5
        case .num6:         num6
        case .num7:         num7
        case .num8:         num8
        case .num9:         num9
        case .period:       period
        case .plus:         plus
        case .minus:        minus
        case .enter:        enter
        case .clr:          clr
        case .equals:       equals
        case .forwardSlash: forwardSlash
        case .asterisk:     asterisk
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .num0:         num0 = state
        case .num1:         num1 = state
        case .num2:         num2 = state
        case .num3:         num3 = state
        case .num4:         num4 = state
        case .num5:         num5 = state
        case .num6:         num6 = state
        case .num7:         num7 = state
        case .num8:         num8 = state
        case .num9:         num9 = state
        case .period:       period = state
        case .plus:         plus = state
        case .minus:        minus = state
        case .enter:        enter = state
        case .clr:          clr = state
        case .equals:       equals = state
        case .forwardSlash: forwardSlash = state
        case .asterisk:     asterisk = state
        }
    }
}
