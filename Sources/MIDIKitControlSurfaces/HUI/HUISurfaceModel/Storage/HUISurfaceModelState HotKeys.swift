//
//  HUISurfaceModelState HotKeys.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing HotKeys (keyboard shortcut keys).
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class HotKeys {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.HotKeys: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.HotKey
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .ctrl:     ctrl
        case .shift:    shift
        case .editMode: editMode
        case .undo:     undo
        case .cmd:      cmd
        case .option:   option
        case .editTool: editTool
        case .save:     save
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .ctrl:     ctrl = state
        case .shift:    shift = state
        case .editMode: editMode = state
        case .undo:     undo = state
        case .cmd:      cmd = state
        case .option:   option = state
        case .editTool: editTool = state
        case .save:     save = state
        }
    }
}
