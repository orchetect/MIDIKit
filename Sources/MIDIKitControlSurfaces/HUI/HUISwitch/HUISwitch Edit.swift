//
//  HUISwitch Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Edit section (to the right of the channel strips).
    public enum Edit {
        case capture
        case cut
        case paste
        case separate
        case copy
        case delete
    }
}

extension HUISwitch.Edit: Equatable { }

extension HUISwitch.Edit: Hashable { }

extension HUISwitch.Edit: Sendable { }

extension HUISwitch.Edit: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        case .paste:    (0x1A, 0x0)
        case .cut:      (0x1A, 0x1)
        case .capture:  (0x1A, 0x2)
        case .delete:   (0x1A, 0x3)
        case .copy:     (0x1A, 0x4)
        case .separate: (0x1A, 0x5)
        }
    }
}

extension HUISwitch.Edit: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        case .paste:    "paste"
        case .cut:      "cut"
        case .capture:  "capture"
        case .delete:   "delete"
        case .copy:     "copy"
        case .separate: "separate"
        }
    }
}
