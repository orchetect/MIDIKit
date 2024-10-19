//
//  HUISwitch Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import XCTest

final class HUISwitchTests: XCTestCase {
    /// Ensure all switches produce zone and port numbers that re-form the same switch case.
    func testAllCases_InitZonePort() {
        HUISwitch.allCases.forEach {
            let (zone, port) = $0.zoneAndPort
            let sw = HUISwitch(zone: zone, port: port)
            XCTAssertEqual($0, sw)
        }
    }
}
