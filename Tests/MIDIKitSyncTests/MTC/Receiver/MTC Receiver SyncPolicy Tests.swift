//
//  MTC Receiver SyncPolicy Tests.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSync
import TimecodeKit

final class MTC_Receiver_SyncPolicy_Tests: XCTestCase {
    func testMTC_Receiver_SyncPolicy_init() {
        var sp: MTCReceiver.SyncPolicy
        
        // with defaults
        
        sp = .init()
        XCTAssertEqual(sp.lockFrames, 16)
        XCTAssertEqual(sp.dropOutFrames, 10)
        
        // valid values
        
        sp = .init(lockFrames: 0, dropOutFrames: 0)
        XCTAssertEqual(sp.lockFrames, 0)
        XCTAssertEqual(sp.dropOutFrames, 0)
        
        sp = .init(lockFrames: 8, dropOutFrames: 9)
        XCTAssertEqual(sp.lockFrames, 8)
        XCTAssertEqual(sp.dropOutFrames, 9)
        
        // edge cases
        
        // underflow clamps to 0
        sp = .init(lockFrames: -1, dropOutFrames: -1)
        XCTAssertEqual(sp.lockFrames, 0)
        XCTAssertEqual(sp.dropOutFrames, 0)
        
        // overflow clamps to 100
        sp = .init(lockFrames: 200, dropOutFrames: 200)
        XCTAssertEqual(sp.lockFrames, 100)
        XCTAssertEqual(sp.dropOutFrames, 100)
    }
    
    func testMTC_Receiver_SyncPolicy_Durations() {
        var sp: MTCReceiver.SyncPolicy
        
        sp = .init(lockFrames: 30, dropOutFrames: 30)
        
        XCTAssertEqual(
            sp.lockDuration(at: ._30),
            1.0000000,
            accuracy: 0.0000001
        )
        
        XCTAssertEqual(
            sp.dropOutDuration(at: ._30),
            1.0000000,
            accuracy: 0.0000001
        )
    }
}

#endif
