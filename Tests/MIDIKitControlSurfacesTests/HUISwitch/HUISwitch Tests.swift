//
//  HUISwitch Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct HUISwitchTests {
    /// Ensure all switches produce zone and port numbers that re-form the same switch case.
    @Test
    func allCases_InitZonePort() {
        for item in HUISwitch.allCases {
            let (zone, port) = item.zoneAndPort
            let sw = HUISwitch(zone: zone, port: port)
            #expect(item == sw)
        }
    }
}
