//
//  HUIModel AutoMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
    /// State storage representing the Auto Mode section.
    public struct AutoMode: Equatable, Hashable {
        public var read = false
        public var latch = false
        public var trim = false
        public var touch = false
        public var write = false
        public var off = false
    }
}

extension HUIModel.AutoMode: HUISurfaceStateProtocol {
    public typealias Switch = HUISwitch.AutoMode

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .read:   return read
        case .latch:  return latch
        case .trim:   return trim
        case .touch:  return touch
        case .write:  return write
        case .off:    return off
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .read:   read = state
        case .latch:  latch = state
        case .trim:   trim = state
        case .touch:  touch = state
        case .write:  write = state
        case .off:    off = state
        }
    }
}
