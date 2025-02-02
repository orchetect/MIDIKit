//
//  HUISurfaceModelState FunctionKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Function Key section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class FunctionKey {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.FunctionKey: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.FunctionKey
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .f1:      f1
        case .f2:      f2
        case .f3:      f3
        case .f4:      f4
        case .f5:      f5
        case .f6:      f6
        case .f7:      f7
        case .f8OrEsc: f8OrEsc
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .f1:      f1 = state
        case .f2:      f2 = state
        case .f3:      f3 = state
        case .f4:      f4 = state
        case .f5:      f5 = state
        case .f6:      f6 = state
        case .f7:      f7 = state
        case .f8OrEsc: f8OrEsc = state
        }
    }
}
