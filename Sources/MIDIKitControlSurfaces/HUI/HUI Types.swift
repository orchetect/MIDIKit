//
//  HUI Types.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

/// Raw HUI zone byte.
public typealias HUIZone = UInt8

/// Raw HUI port nibble.
public typealias HUIPort = UInt4

/// Raw HUI zone and port pair.
public typealias HUIZoneAndPort = (zone: HUIZone, port: HUIPort)

/// Enum describing the HUI role (host or client surface).
public enum HUIRole: Equatable, Hashable, CaseIterable {
    /// Host
    /// (ie: a desktop DAW).
    case host
    
    /// HUI Surface
    /// (ie: a physical HUI control surface device or
    /// a software emulation like an iPad HUI control surface app).
    case surface
    
    /// Returns the inverted role.
    /// (ie: for ``host``, returns ``surface``. And vice-versa.)
    public func inverted() -> Self {
        switch self {
        case .host: return .surface
        case .surface: return .host
        }
    }
}
