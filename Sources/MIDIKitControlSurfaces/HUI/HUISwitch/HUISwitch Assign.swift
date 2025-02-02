//
//  HUISwitch Assign.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Assign section (buttons to top left of channel strips).
    public enum Assign {
        case sendA
        case sendB
        case sendC
        case sendD
        case sendE
        case pan
        
        case recordReadyAll
        case bypass
        case mute
        case shift
        case suspend
        case defaultBtn
        case assign
        case input
        case output
    }
}

extension HUISwitch.Assign: Equatable { }

extension HUISwitch.Assign: Hashable { }

extension HUISwitch.Assign: Sendable { }

extension HUISwitch.Assign: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        case .output:          (0x0B, 0x0)
        case .input:           (0x0B, 0x1)
        case .pan:             (0x0B, 0x2)
        case .sendE:           (0x0B, 0x3)
        case .sendD:           (0x0B, 0x4)
        case .sendC:           (0x0B, 0x5)
        case .sendB:           (0x0B, 0x6)
        case .sendA:           (0x0B, 0x7)
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        case .assign:          (0x0C, 0x0)
        case .defaultBtn:      (0x0C, 0x1)
        case .suspend:         (0x0C, 0x2)
        case .shift:           (0x0C, 0x3)
        case .mute:            (0x0C, 0x4)
        case .bypass:          (0x0C, 0x5)
        case .recordReadyAll:  (0x0C, 0x6)
        }
    }
}

extension HUISwitch.Assign: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        case .output:         "output"
        case .input:          "input"
        case .pan:            "pan"
        case .sendE:          "sendE"
        case .sendD:          "sendD"
        case .sendC:          "sendC"
        case .sendB:          "sendB"
        case .sendA:          "sendA"
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        case .assign:         "assign"
        case .defaultBtn:     "default"
        case .suspend:        "suspend"
        case .shift:          "shift"
        case .mute:           "mute"
        case .bypass:         "bypass"
        case .recordReadyAll: "recordReadyAll"
        }
    }
}
