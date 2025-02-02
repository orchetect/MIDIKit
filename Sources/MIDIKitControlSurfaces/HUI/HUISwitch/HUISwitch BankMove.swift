//
//  HUISwitch BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Bank and channel navigation.
    public enum BankMove {
        case channelLeft
        case channelRight
        
        case bankLeft
        case bankRight
    }
}

extension HUISwitch.BankMove: Equatable { }

extension HUISwitch.BankMove: Hashable { }

extension HUISwitch.BankMove: Sendable { }

extension HUISwitch.BankMove: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:  (0x0A, 0x0)
        case .bankLeft:     (0x0A, 0x1)
        case .channelRight: (0x0A, 0x2)
        case .bankRight:    (0x0A, 0x3)
        }
    }
}

extension HUISwitch.BankMove: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:  "channelLeft"
        case .bankLeft:     "bankLeft"
        case .channelRight: "channelRight"
        case .bankRight:    "bankRight"
        }
    }
}
