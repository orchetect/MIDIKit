//
//  HUISurfaceModelState StatusAndGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Status/Group section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class StatusAndGroup {
        public var auto = false
        public var monitor = false
        public var phase = false
        public var group = false
        public var create = false
        public var suspend = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.StatusAndGroup: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.StatusAndGroup
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .auto:    auto
        case .monitor: monitor
        case .phase:   phase
        case .group:   group
        case .create:  create
        case .suspend: suspend
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .auto:    auto = state
        case .monitor: monitor = state
        case .phase:   phase = state
        case .group:   group = state
        case .create:  create = state
        case .suspend: suspend = state
        }
    }
}
