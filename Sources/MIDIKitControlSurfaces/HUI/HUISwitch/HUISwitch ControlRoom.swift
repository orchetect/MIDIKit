//
//  HUISwitch ControlRoom.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Control Room section.
    public enum ControlRoom {
        case input1
        case input2
        case input3
        case discreteInput1to1
        case mute
        case dim
        case mono
        case output1
        case output2
        case output3
    }
}

extension HUISwitch.ControlRoom: Equatable { }

extension HUISwitch.ControlRoom: Hashable { }

extension HUISwitch.ControlRoom: Sendable { }

extension HUISwitch.ControlRoom: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x11
        // Control Room - Monitor Input
        case .input3:            (0x11, 0x0)
        case .input2:            (0x11, 0x1)
        case .input1:            (0x11, 0x2)
        case .mute:              (0x11, 0x3)
        case .discreteInput1to1: (0x11, 0x4)
        // Zone 0x12
        // Control Room - Monitor Output
        case .output3:           (0x12, 0x0)
        case .output2:           (0x12, 0x1)
        case .output1:           (0x12, 0x2)
        case .dim:               (0x12, 0x3)
        case .mono:              (0x12, 0x4)
        }
    }
}

extension HUISwitch.ControlRoom: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x11
        // Control Room - Monitor Input
        case .input3:            "input3"
        case .input2:            "input2"
        case .input1:            "input1"
        case .mute:              "mute"
        case .discreteInput1to1: "discreteInput1to1"
        // Zone 0x12
        // Control Room - Monitor Output
        case .output3:           "output3"
        case .output2:           "output2"
        case .output1:           "output1"
        case .dim:               "dim"
        case .mono:              "mono"
        }
    }
}
