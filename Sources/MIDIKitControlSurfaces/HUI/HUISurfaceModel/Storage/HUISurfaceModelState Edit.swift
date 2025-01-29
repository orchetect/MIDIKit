//
//  HUISurfaceModelState Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Edit section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class Edit {
        public var capture = false
        public var cut = false
        public var paste = false
        public var separate = false
        public var copy = false
        public var delete = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.Edit: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.Edit
    
    @inlinable
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
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
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
