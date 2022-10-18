//
//  HUISwitch HotKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Keyboard hotkeys.
    public enum HotKey: Equatable, Hashable {
        case ctrl
        case shift
        case editMode
        case undo
        case cmd
        case option
        case editTool
        case save
    }
}

extension HUISwitch.HotKey: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x08
        // Keyboard Shortcuts
        case .ctrl:      return (0x08, 0x0)
        case .shift:     return (0x08, 0x1)
        case .editMode:  return (0x08, 0x2)
        case .undo:      return (0x08, 0x3)
        case .cmd:       return (0x08, 0x4)
        case .option:    return (0x08, 0x5)
        case .editTool:  return (0x08, 0x6)
        case .save:      return (0x08, 0x7)
        }
    }
}

extension HUISwitch.HotKey: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x08
        // Keyboard Shortcuts
        case .ctrl:      return "ctrl"
        case .shift:     return "shift"
        case .editMode:  return "editMode"
        case .undo:      return "undo"
        case .cmd:       return "cmd"
        case .option:    return "option"
        case .editTool:  return "editTool"
        case .save:      return "save"
        }
    }
}
