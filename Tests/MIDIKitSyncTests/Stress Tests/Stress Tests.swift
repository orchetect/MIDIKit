//
//  Stress Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import CoreMIDI
@testable import MIDIKitSync
import XCTest

final class StressTests: XCTestCase {
    func testThreadingMTCGenerator() async {
        // MARK: - Generator
        
        let mtcGen = MTCGenerator { midiMessage in
            _ = midiMessage
        }
        
        // test public properties and methods
        // to make sure we don't encounter thread-related crashes
        
        func access() async {
            // public properties (set and get where applicable)
            _ = await mtcGen.name
            _ = await mtcGen.mtcFrameRate
            _ = await mtcGen.state
            _ = await mtcGen.timecode
            _ = await mtcGen.localFrameRate
            _ = await mtcGen.locateBehavior
            await mtcGen.setLocateBehavior(.always)
            _ = await mtcGen.midiOutHandler
            await mtcGen.setMIDIOutHandler { _ in }
            
            // public methods
            await mtcGen.locate(to: Timecode(.zero, at: .fps24))
            await mtcGen.locate(to: Timecode.Components.zero)
            await mtcGen.start(now: Timecode(.zero, at: .fps24))
            await mtcGen.stop()
            await mtcGen.start(now: Timecode.Components.zero, frameRate: .fps24, base: .max100SubFrames)
            await mtcGen.stop()
            await mtcGen.start(now: 0.0, frameRate: .fps24)
            await mtcGen.stop()
        }
        
        // from same thread as its allocation
        await access()
        
        // from different thread
        _ = await Task {
            await access()
        }.value
    }
    
    func testThreadingMTCReceiver() async {
        // MARK: - Receiver
        
        // (Receiver.midiIn() is async internally so we need to wait for
        // property updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(
            name: "test",
            initialLocalFrameRate: .fps24
        ) { timecode, messageType, direction, displayNeedsUpdate in
            _ = timecode
            _ = messageType
            _ = direction
            _ = displayNeedsUpdate
        } stateChanged: { state in
            _ = state
        }
        
        // test public properties and methods
        // to make sure we don't encounter thread-related crashes
        
        func access() async {
            // public properties (set and get where applicable)
            _ = await mtcRec.state
            _ = await mtcRec.timecode
            _ = await mtcRec.localFrameRate
            await mtcRec.setLocalFrameRate(.fps30)
            _ = await mtcRec.mtcFrameRate
            _ = await mtcRec.direction
            _ = await mtcRec.syncPolicy
            await mtcRec.setSyncPolicy(.init(lockFrames: 0, dropOutFrames: 10))
            _ = await mtcRec.timecodeChangedHandler
            await mtcRec.setTimecodeChangedHandler { _, _, _, _ in }
            
            // public methods
            // (none)
        }
        
        // from same thread as its allocation
        await access()
        
        // from different thread
        _ = await Task {
            await access()
        }.value
    }
}
