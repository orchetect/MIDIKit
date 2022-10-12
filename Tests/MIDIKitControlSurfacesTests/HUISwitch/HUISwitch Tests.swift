//
//  HUISwitch Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

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

#endif
