//
//  Parameter StatusAndGroup.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIParameter {
    /// Status/Group (To the right of the channel strips)
    public enum StatusAndGroup: Equatable, Hashable {
        case auto
        case monitor
        case phase
        case group
        case create
        case suspend
    }
}

extension HUIParameter.StatusAndGroup: HUIParameterProtocol {
    @inlinable
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        case .phase:    return (0x19, 0x0)
        case .monitor:  return (0x19, 0x1)
        case .auto:     return (0x19, 0x2)
        case .suspend:  return (0x19, 0x3)
        case .create:   return (0x19, 0x4)
        case .group:    return (0x19, 0x5)
        }
    }
}

extension HUIParameter.StatusAndGroup: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        case .phase:    return "phase"
        case .monitor:  return "monitor"
        case .auto:     return "auto"
        case .suspend:  return "suspend"
        case .create:   return "create"
        case .group:    return "group"
        }
    }
}
