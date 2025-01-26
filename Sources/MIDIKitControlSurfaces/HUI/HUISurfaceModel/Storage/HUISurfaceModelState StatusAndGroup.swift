//
//  HUISurfaceModelState StatusAndGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Status/Group section.
    public struct StatusAndGroup {
        public var auto = false
        public var monitor = false
        public var phase = false
        public var group = false
        public var create = false
        public var suspend = false
    }
}

extension HUISurfaceModelState.StatusAndGroup: Equatable { }

extension HUISurfaceModelState.StatusAndGroup: Hashable { }

extension HUISurfaceModelState.StatusAndGroup: Sendable { }

extension HUISurfaceModelState.StatusAndGroup: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.StatusAndGroup

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .auto:    return auto
        case .monitor: return monitor
        case .phase:   return phase
        case .group:   return group
        case .create:  return create
        case .suspend: return suspend
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
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
