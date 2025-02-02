//
//  HUISwitchProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUISwitchProtocol: Sendable {
    /// HUI zone and port constant for the switch.
    var zoneAndPort: HUIZoneAndPort { get }
}
