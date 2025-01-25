//
//  MTC Receiver SyncPolicy Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite struct MTC_Receiver_SyncPolicy_Tests {
    @Test
    func mtcReceiver_SyncPolicy_init() {
        var sp: MTCReceiver.SyncPolicy
        
        // with defaults
        
        sp = .init()
        #expect(sp.lockFrames == 16)
        #expect(sp.dropOutFrames == 10)
        
        // valid values
        
        sp = .init(lockFrames: 0, dropOutFrames: 0)
        #expect(sp.lockFrames == 0)
        #expect(sp.dropOutFrames == 0)
        
        sp = .init(lockFrames: 8, dropOutFrames: 9)
        #expect(sp.lockFrames == 8)
        #expect(sp.dropOutFrames == 9)
        
        // edge cases
        
        // underflow clamps to 0
        sp = .init(lockFrames: -1, dropOutFrames: -1)
        #expect(sp.lockFrames == 0)
        #expect(sp.dropOutFrames == 0)
        
        // overflow clamps to 100
        sp = .init(lockFrames: 200, dropOutFrames: 200)
        #expect(sp.lockFrames == 100)
        #expect(sp.dropOutFrames == 100)
    }
    
    @Test
    func mtcReceiver_SyncPolicy_Durations() {
        var sp: MTCReceiver.SyncPolicy
        
        sp = .init(lockFrames: 30, dropOutFrames: 30)
        
        #expect(
            sp.lockDuration(at: .fps30) ==
                1.0000000
            // accuracy: 0.0000001
        )
        
        #expect(
            sp.dropOutDuration(at: .fps30) ==
                1.0000000
            // accuracy: 0.0000001
        )
    }
}
