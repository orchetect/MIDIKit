//
//  HUISwitch StatusAndGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Status/Group section (to the right of the channel strips).
    public enum StatusAndGroup {
        case auto
        case monitor
        case phase
        case group
        case create
        case suspend
    }
}

extension HUISwitch.StatusAndGroup: Equatable { }

extension HUISwitch.StatusAndGroup: Hashable { }

extension HUISwitch.StatusAndGroup: Sendable { }

extension HUISwitch.StatusAndGroup: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        case .phase:   (0x19, 0x0)
        case .monitor: (0x19, 0x1)
        case .auto:    (0x19, 0x2)
        case .suspend: (0x19, 0x3)
        case .create:  (0x19, 0x4)
        case .group:   (0x19, 0x5)
        }
    }
}

extension HUISwitch.StatusAndGroup: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        case .phase:   "phase"
        case .monitor: "monitor"
        case .auto:    "auto"
        case .suspend: "suspend"
        case .create:  "create"
        case .group:   "group"
        }
    }
}
