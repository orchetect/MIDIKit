//
//  Parameter WindowFunction.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIParameter {
    /// Window Functions
    public enum WindowFunction: Equatable, Hashable {
        case mix
        case edit
        case transport
        case memLoc
        case status
        case alt
    }
}

extension HUIParameter.WindowFunction: HUIParameterProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        // Zone 0x09
        // Window Functions
        case .mix:        return (0x09, 0x0)
        case .edit:       return (0x09, 0x1)
        case .transport:  return (0x09, 0x2)
        case .memLoc:     return (0x09, 0x3)
        case .status:     return (0x09, 0x4)
        case .alt:        return (0x09, 0x5)
        }
    }
}

extension HUIParameter.WindowFunction: CustomStringConvertible {
    public var description: String {
        switch self {
        // Zone 0x09
        // Window Functions
        case .mix:        return "mix"
        case .edit:       return "edit"
        case .transport:  return "transport"
        case .memLoc:     return "memLoc"
        case .status:     return "status"
        case .alt:        return "alt"
        }
    }
}
