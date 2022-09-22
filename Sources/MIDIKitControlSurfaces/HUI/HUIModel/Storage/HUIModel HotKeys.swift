//
//  HUIModel HotKeys.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
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

extension HUIModel.HotKeys: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.HotKey

    public func state(of param: Param) -> Bool {
        switch param {
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
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
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
