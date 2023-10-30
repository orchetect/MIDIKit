//
//  MIDIOSStatus Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import XCTest

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
        // spot check expected output
        
        let desc = "\(MIDIOSStatus.invalidClient))"
		print(desc)
        XCTAssert(desc.contains("invalidClient"))
    }
    
    func testLocalizedDescription() {
        // spot check expected output
        
        let desc = MIDIOSStatus.invalidClient.localizedDescription
        print(desc)
        XCTAssert(desc.contains("kMIDIInvalidClient"))
    }
}

#endif
