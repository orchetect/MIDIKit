//
//  UInt32 Extensions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitEvents

final class UInt32Extensions_Tests: XCTestCase {
    fileprivate let _min: UInt32      = 0x0000_0000
    fileprivate let _midpoint: UInt32 = 0x8000_0000
    fileprivate let _max: UInt32      = 0xFFFF_FFFF
    
    func testInitBipolarUnitInterval_Float() {
        XCTAssertEqual(UInt32(bipolarUnitInterval: Float(-1.0)), UInt32(_min))
        XCTAssertEqual(UInt32(bipolarUnitInterval: Float(-0.5)), UInt32(0x4000_0000))
        XCTAssertEqual(UInt32(bipolarUnitInterval: Float(0.0)), UInt32(_midpoint))
        XCTAssertEqual(UInt32(bipolarUnitInterval: Float(0.5)), UInt32(0xBFFF_FFFF))
        XCTAssertEqual(UInt32(bipolarUnitInterval: Float(1.0)), UInt32(_max))
    }
    
    func testInitBipolarUnitInterval_Double() {
        XCTAssertEqual(UInt32(bipolarUnitInterval: -1.0), UInt32(_min))
        XCTAssertEqual(UInt32(bipolarUnitInterval: -0.5), UInt32(0x4000_0000))
        XCTAssertEqual(UInt32(bipolarUnitInterval:  0.0), UInt32(_midpoint))
        XCTAssertEqual(UInt32(bipolarUnitInterval:  0.5), UInt32(0xBFFF_FFFF))
        XCTAssertEqual(UInt32(bipolarUnitInterval:  1.0), UInt32(_max))
    }
    
    func testBipolarUnitIntervalValue() {
        XCTAssertEqual(UInt32(_min).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(UInt32(0x4000_0000).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(UInt32(_midpoint).bipolarUnitIntervalValue, 0.0)
        XCTAssertEqual(UInt32(0xBFFF_FFFF).bipolarUnitIntervalValue, 0.5, accuracy: 0.000000001)
        XCTAssertEqual(UInt32(_max).bipolarUnitIntervalValue, 1.0)
    }
}

#endif
