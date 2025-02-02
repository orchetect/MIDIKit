//
//  HUISwitch Window.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Window functions.
    public enum Window {
        case mix
        case edit
        case transport
        case memLoc
        case status
        case alt
    }
}

extension HUISwitch.Window: Equatable { }

extension HUISwitch.Window: Hashable { }

extension HUISwitch.Window: Sendable { }

extension HUISwitch.Window: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x09
        // Window Functions
        case .mix:       (0x09, 0x0)
        case .edit:      (0x09, 0x1)
        case .transport: (0x09, 0x2)
        case .memLoc:    (0x09, 0x3)
        case .status:    (0x09, 0x4)
        case .alt:       (0x09, 0x5)
        }
    }
}

extension HUISwitch.Window: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x09
        // Window Functions
        case .mix:       "mix"
        case .edit:      "edit"
        case .transport: "transport"
        case .memLoc:    "memLoc"
        case .status:    "status"
        case .alt:       "alt"
        }
    }
}
