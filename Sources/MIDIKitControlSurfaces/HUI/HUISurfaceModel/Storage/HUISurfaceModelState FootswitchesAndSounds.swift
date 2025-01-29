//
//  HUISurfaceModelState FootswitchesAndSounds.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing footswitches and sounds.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class FootswitchesAndSounds {
        public var footswitchRelay1 = false
        public var footswitchRelay2 = false
        public var click = false
        public var beep = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.FootswitchesAndSounds: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.FootswitchesAndSounds
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .footswitchRelay1: return footswitchRelay1
        case .footswitchRelay2: return footswitchRelay2
        case .click:            return click
        case .beep:             return beep
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .footswitchRelay1: footswitchRelay1 = state
        case .footswitchRelay2: footswitchRelay2 = state
        case .click:            click = state
        case .beep:             beep = state
        }
    }
}
