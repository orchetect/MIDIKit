//
//  HUIParameterProtocol.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUIParameterProtocol {
    /// HUI zone and port constant for the parameter
    @inlinable var zoneAndPort: HUIZoneAndPort { get }
}
