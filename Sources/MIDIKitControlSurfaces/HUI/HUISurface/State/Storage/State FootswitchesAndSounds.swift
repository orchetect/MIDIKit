//
//  State FootswitchesAndSounds.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing footswitches and sounds.
    public struct FootswitchesAndSounds: Equatable, Hashable {
        public var footswitchRelay1 = false
        public var footswitchRelay2 = false
        public var click = false
        public var beep = false
    }
}

extension HUISurface.State.FootswitchesAndSounds: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.FootswitchesAndSounds

    public func state(of param: Param) -> Bool {
        switch param {
        case .footswitchRelay1:  return footswitchRelay1
        case .footswitchRelay2:  return footswitchRelay2
        case .click:             return click
        case .beep:              return beep
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .footswitchRelay1:  footswitchRelay1 = state
        case .footswitchRelay2:  footswitchRelay2 = state
        case .click:             click = state
        case .beep:              beep = state
        }
    }
}
