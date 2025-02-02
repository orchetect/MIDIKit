//
//  HUISwitch HotKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISwitch {
    /// Keyboard hotkeys.
    public enum HotKey {
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

extension HUISwitch.HotKey: Equatable { }

extension HUISwitch.HotKey: Hashable { }

extension HUISwitch.HotKey: Sendable { }

extension HUISwitch.HotKey: HUISwitchProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x08
        // Keyboard Shortcuts
        case .ctrl:     (0x08, 0x0)
        case .shift:    (0x08, 0x1)
        case .editMode: (0x08, 0x2)
        case .undo:     (0x08, 0x3)
        case .cmd:      (0x08, 0x4)
        case .option:   (0x08, 0x5)
        case .editTool: (0x08, 0x6)
        case .save:     (0x08, 0x7)
        }
    }
}

extension HUISwitch.HotKey: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x08
        // Keyboard Shortcuts
        case .ctrl:     "ctrl"
        case .shift:    "shift"
        case .editMode: "editMode"
        case .undo:     "undo"
        case .cmd:      "cmd"
        case .option:   "option"
        case .editTool: "editTool"
        case .save:     "save"
        }
    }
}
