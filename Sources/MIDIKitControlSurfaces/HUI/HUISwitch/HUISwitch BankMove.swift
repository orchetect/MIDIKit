//
//  HUISwitch BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Bank and channel navigation.
    public enum BankMove: Equatable, Hashable {
        case channelLeft
        case channelRight
        
        case bankLeft
        case bankRight
    }
}

extension HUISwitch.BankMove: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:   return (0x0A, 0x0)
        case .bankLeft:      return (0x0A, 0x1)
        case .channelRight:  return (0x0A, 0x2)
        case .bankRight:     return (0x0A, 0x3)
        }
    }
}

extension HUISwitch.BankMove: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case .channelLeft:   return "channelLeft"
        case .bankLeft:      return "bankLeft"
        case .channelRight:  return "channelRight"
        case .bankRight:     return "bankRight"
        }
    }
}
