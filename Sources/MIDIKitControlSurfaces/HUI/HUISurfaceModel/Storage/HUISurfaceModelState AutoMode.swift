//
//  HUISurfaceModelState AutoMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Auto Mode section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class AutoMode {
        public var read = false
        public var latch = false
        public var trim = false
        public var touch = false
        public var write = false
        public var off = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.AutoMode: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.AutoMode
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .read:  read
        case .latch: latch
        case .trim:  trim
        case .touch: touch
        case .write: write
        case .off:   off
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .read:  read = state
        case .latch: latch = state
        case .trim:  trim = state
        case .touch: touch = state
        case .write: write = state
        case .off:   off = state
        }
    }
}
