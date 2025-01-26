//
//  HUIRole.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Enum describing the HUI role (host or client surface).
public enum HUIRole {
    /// Host
    /// (ie: a desktop DAW).
    case host
    
    /// HUI Surface
    /// (ie: a physical HUI control surface device or
    /// a software emulation like an iPad HUI control surface app).
    case surface
}

extension HUIRole: Equatable { }

extension HUIRole: Hashable { }

extension HUIRole: CaseIterable { }

extension HUIRole: Sendable { }

extension HUIRole {
    /// Returns the inverted role.
    /// (ie: for ``host``, returns ``surface``. And vice-versa.)
    public func inverted() -> Self {
        switch self {
        case .host: return .surface
        case .surface: return .host
        }
    }
}
