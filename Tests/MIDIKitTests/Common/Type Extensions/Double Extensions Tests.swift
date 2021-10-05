//
//  Double Extensions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

final class DoubleExtensions_Tests: XCTestCase {
    
    func testInitBipolarUnitInterval() {
        
        XCTAssertEqual(Double(bipolarUnitInterval: -1.0), 0.00)
        XCTAssertEqual(Double(bipolarUnitInterval: -0.5), 0.25)
        XCTAssertEqual(Double(bipolarUnitInterval:  0.0), 0.50)
        XCTAssertEqual(Double(bipolarUnitInterval:  0.5), 0.75)
        XCTAssertEqual(Double(bipolarUnitInterval:  1.0), 1.00)
        
    }
    
    func testBipolarUnitIntervalValue() {
        
        XCTAssertEqual(0.00.bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(0.25.bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(0.50.bipolarUnitIntervalValue,  0.0)
        XCTAssertEqual(0.75.bipolarUnitIntervalValue,  0.5)
        XCTAssertEqual(1.00.bipolarUnitIntervalValue,  1.0)
        
    }
    
}

#endif
