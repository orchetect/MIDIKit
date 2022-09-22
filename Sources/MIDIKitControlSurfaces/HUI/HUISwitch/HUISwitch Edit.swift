//
//  HUISwitch Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Edit section (to the right of the channel strips).
    public enum Edit: Equatable, Hashable {
        case capture
        case cut
        case paste
        case separate
        case copy
        case delete
    }
}

extension HUISwitch.Edit: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        case .paste:     return (0x1A, 0x0)
        case .cut:       return (0x1A, 0x1)
        case .capture:   return (0x1A, 0x2)
        case .delete:    return (0x1A, 0x3)
        case .copy:      return (0x1A, 0x4)
        case .separate:  return (0x1A, 0x5)
        }
    }
}

extension HUISwitch.Edit: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        case .paste:     return "paste"
        case .cut:       return "cut"
        case .capture:   return "capture"
        case .delete:    return "delete"
        case .copy:      return "copy"
        case .separate:  return "separate"
        }
    }
}
