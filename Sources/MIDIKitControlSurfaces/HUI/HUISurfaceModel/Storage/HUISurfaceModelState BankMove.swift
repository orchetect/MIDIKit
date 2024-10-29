//
//  HUISurfaceModelState BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing bank and channel navigation.
    public struct BankMove: Equatable, Hashable {
        public var channelLeft = false
        public var channelRight = false
        public var bankLeft = false
        public var bankRight = false
    }
}

extension HUISurfaceModelState.BankMove: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.BankMove

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .channelLeft:   return channelLeft
        case .channelRight:  return channelRight
        case .bankLeft:      return bankLeft
        case .bankRight:     return bankRight
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .channelLeft:   channelLeft = state
        case .channelRight:  channelRight = state
        case .bankLeft:      bankLeft = state
        case .bankRight:     bankRight = state
        }
    }
}
