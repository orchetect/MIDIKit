//
//  HUISurfaceModelState BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing bank and channel navigation.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class BankMove {
        public var channelLeft = false
        public var channelRight = false
        public var bankLeft = false
        public var bankRight = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.BankMove: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.BankMove
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .channelLeft:  channelLeft
        case .channelRight: channelRight
        case .bankLeft:     bankLeft
        case .bankRight:    bankRight
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .channelLeft:  channelLeft = state
        case .channelRight: channelRight = state
        case .bankLeft:     bankLeft = state
        case .bankRight:    bankRight = state
        }
    }
}
