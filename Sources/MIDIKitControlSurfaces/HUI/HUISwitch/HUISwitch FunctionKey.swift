//
//  HUISwitch FunctionKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Function keys (to the right of the channel strips).
    public enum FunctionKey {
        case f1
        case f2
        case f3
        case f4
        case f5
        case f6
        case f7
        case f8OrEsc
    }
}

extension HUISwitch.FunctionKey: Equatable { }

extension HUISwitch.FunctionKey: Hashable { }

extension HUISwitch.FunctionKey: Sendable { }

extension HUISwitch.FunctionKey: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x1B
        // Function Keys
        case .f1:      (0x1B, 0x0)
        case .f2:      (0x1B, 0x1)
        case .f3:      (0x1B, 0x2)
        case .f4:      (0x1B, 0x3)
        case .f5:      (0x1B, 0x4)
        case .f6:      (0x1B, 0x5)
        case .f7:      (0x1B, 0x6)
        case .f8OrEsc: (0x1B, 0x7)
        }
    }
}

extension HUISwitch.FunctionKey: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x1B
        // Function Keys
        case .f1:      "f1"
        case .f2:      "f2"
        case .f3:      "f3"
        case .f4:      "f4"
        case .f5:      "f5"
        case .f6:      "f6"
        case .f7:      "f7"
        case .f8OrEsc: "f8OrEsc"
        }
    }
}
