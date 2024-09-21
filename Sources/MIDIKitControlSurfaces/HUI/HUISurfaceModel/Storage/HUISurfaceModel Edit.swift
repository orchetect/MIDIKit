//
//  HUISurfaceModel Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModel {
    /// State storage representing the Edit section.
    public struct Edit: Equatable, Hashable {
        public var capture = false
        public var cut = false
        public var paste = false
        public var separate = false
        public var copy = false
        public var delete = false
    }
}

extension HUISurfaceModel.Edit: HUISurfaceModelState {
    public typealias Switch = HUISwitch.Edit

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .capture:  return capture
        case .cut:      return cut
        case .paste:    return paste
        case .separate: return separate
        case .copy:     return copy
        case .delete:   return delete
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .capture:  capture = state
        case .cut:      cut = state
        case .paste:    paste = state
        case .separate: separate = state
        case .copy:     copy = state
        case .delete:   delete = state
        }
    }
}
