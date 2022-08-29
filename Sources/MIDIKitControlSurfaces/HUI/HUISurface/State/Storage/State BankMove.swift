//
//  State BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing bank and channel navigation.
    public struct BankMove: Equatable, Hashable {
        public var channelLeft = false
        public var channelRight = false
        public var bankLeft = false
        public var bankRight = false
    }
}

extension HUISurface.State.BankMove: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.BankMove

    public func state(of param: Param) -> Bool {
        switch param {
        case .channelLeft:   return channelLeft
        case .channelRight:  return channelRight
        case .bankLeft:      return bankLeft
        case .bankRight:     return bankRight
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .channelLeft:   channelLeft = state
        case .channelRight:  channelRight = state
        case .bankLeft:      bankLeft = state
        case .bankRight:     bankRight = state
        }
    }
}
