//
//  HUISwitchProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUISwitchProtocol {
    /// HUI zone and port constant for the parameter.
    var zoneAndPort: HUIZoneAndPort { get }
}
