//
//  MIDIOSStatus Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
import MIDIKit

final class Errors_MIDIOSStatus_Tests: XCTestCase {
    func testRawValue() {
        // spot check: known constant
		
        XCTAssertEqual(
            MIDIOSStatus(rawValue: -10830),
            .invalidClient
        )
		
        XCTAssertEqual(
            MIDIOSStatus.invalidClient.rawValue,
            -10830
        )
		
        // other
		
        XCTAssertEqual(
            MIDIOSStatus(rawValue: 7777),
            .other(7777)
        )
		
        XCTAssertEqual(
            MIDIOSStatus.other(7777).rawValue,
            7777
        )
    }
	
    func testCustomStringConvertible() {
        // spot check: known constant
		
        XCTAssert(
            "\(MIDIOSStatus.invalidClient)".contains("kMIDIInvalidClient")
        )
    }
}

#endif
