//
//  Stress Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import CoreMIDI
@testable import MIDIKitSync
import XCTest

final class StressTests: XCTestCase {
    func testThreadingMTCGenerator() {
        // MARK: - Generator
        
        let mtcGen = MTCGenerator { midiMessage in
            _ = midiMessage
        }
        
        // test public properties and methods
        // to make sure we don't encounter thread-related crashes
        
        func access() {
            // public properties (set and get where applicable)
            _ = mtcGen.name
            _ = mtcGen.mtcFrameRate
            _ = mtcGen.state
            _ = mtcGen.timecode
            _ = mtcGen.localFrameRate
            _ = mtcGen.locateBehavior
            mtcGen.locateBehavior = .always
            _ = mtcGen.midiOutHandler
            mtcGen.midiOutHandler = { _ in }
            
            // public methods
            mtcGen.locate(to: Timecode(.zero, at: .fps24))
            mtcGen.locate(to: Timecode.Components.zero)
            mtcGen.start(now: Timecode(.zero, at: .fps24))
            mtcGen.stop()
            mtcGen.start(now: Timecode.Components.zero, frameRate: .fps24, base: .max100SubFrames)
            mtcGen.stop()
            mtcGen.start(now: 0.0, frameRate: .fps24)
            mtcGen.stop()
        }
        
        // from same thread as its allocation
        access()
        
        // from different thread
        DispatchQueue.global().sync {
            access()
        }
    }
    
    func testThreadingMTCReceiver() {
        // MARK: - Receiver
        
        // (Receiver.midiIn() is async internally so we need to wait for
        // property updates to occur before reading them)
        
        // init with local frame rate
        let mtcRec = MTCReceiver(name: "test", initialLocalFrameRate: .fps24) { timecode, messageType, direction, displayNeedsUpdate in
            _ = timecode
            _ = messageType
            _ = direction
            _ = displayNeedsUpdate
        } stateChanged: { state in
            _ = state
        }
        
        // test public properties and methods
        // to make sure we don't encounter thread-related crashes
        
        func access() {
            // public properties (set and get where applicable)
            _ = mtcRec.state
            _ = mtcRec.timecode
            _ = mtcRec.localFrameRate
            mtcRec.localFrameRate = .fps30
            _ = mtcRec.mtcFrameRate
            _ = mtcRec.direction
            _ = mtcRec.syncPolicy
            mtcRec.syncPolicy = .init()
            _ = mtcRec.timecodeChangedHandler
            mtcRec.timecodeChangedHandler = { _, _, _, _ in }
            
            // public methods
            // (none)
        }
        
        // from same thread as its allocation
        access()
        
        // from different thread
        DispatchQueue.global().sync {
            access()
        }
    }
}
