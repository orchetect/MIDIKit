//
//  HUISurfaceModelState HotKeys.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing HotKeys (keyboard shortcut keys).
    public struct HotKeys: Equatable, Hashable {
        public var shift = false
        public var ctrl = false
        public var option = false
        public var cmd = false
        
        public var undo = false
        public var save = false
        
        public var editMode = false
        public var editTool = false
    }
}

extension HUISurfaceModelState.HotKeys: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.HotKey

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .ctrl:      return ctrl
        case .shift:     return shift
        case .editMode:  return editMode
        case .undo:      return undo
        case .cmd:       return cmd
        case .option:    return option
        case .editTool:  return editTool
        case .save:      return save
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .ctrl:      ctrl = state
        case .shift:     shift = state
        case .editMode:  editMode = state
        case .undo:      undo = state
        case .cmd:       cmd = state
        case .option:    option = state
        case .editTool:  editTool = state
        case .save:      save = state
        }
    }
}
