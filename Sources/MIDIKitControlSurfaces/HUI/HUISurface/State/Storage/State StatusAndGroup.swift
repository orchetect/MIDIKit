//
//  State StatusAndGroup.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing the Status/Group section
    public struct StatusAndGroup: Equatable, Hashable {
        public var auto = false
        public var monitor = false
        public var phase = false
        public var group = false
        public var create = false
        public var suspend = false
    }
}

extension HUISurface.State.StatusAndGroup: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.StatusAndGroup

    public func state(of param: Param) -> Bool {
        switch param {
        case .auto:     return auto
        case .monitor:  return monitor
        case .phase:    return phase
        case .group:    return group
        case .create:   return create
        case .suspend:  return suspend
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .auto:     auto = state
        case .monitor:  monitor = state
        case .phase:    phase = state
        case .group:    group = state
        case .create:   create = state
        case .suspend:  suspend = state
        }
    }
}
