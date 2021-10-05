//
//  ChanVoice Value Conversions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit

class ChanVoiceValueConversionsTests: XCTestCase {
    
    // MARK: - 7-Bit <--> 16-Bit
    
    func testScaled_16Bit_from_7Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:   0), 0x0000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit:  64), 0x8000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(from7Bit: 127), 0xFFFF)
        
    }
    
    func testScaled_7Bit_from_16Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x0000),   0)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0x8000),  64)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from16Bit: 0xFFFF), 127)
        
    }
    
    // MARK: - 7-Bit <--> 32-Bit
    
    func testScaled_32Bit_from_7Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:   0), 0x00000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit:  64), 0x80000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from7Bit: 127), 0xFFFFFFFF)
        
    }
    
    func testScaled_7Bit_from_32Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x00000000), 0)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0x80000000), 64)
        XCTAssertEqual(MIDI.Event.scaled7Bit(from32Bit: 0xFFFFFFFF), 127)
        
    }
    
    // MARK: - 14-Bit <--> 32-Bit
    
    func testScaled_32Bit_from_14Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x0000), 0x00000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x2000), 0x80000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(from14Bit: 0x3FFF), 0xFFFFFFFF)
        
    }
    
    func testScaled_14Bit_from_32Bit() {
        
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0x00000000), 0x0000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0x80000000), 0x2000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(from32Bit: 0xFFFFFFFF), 0x3FFF)
        
    }
    
    // MARK: - Unit Interval <--> 7-Bit
    
    func testScaled_UnitInterval_from_7Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:   0), 0.0)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit:  64), 0.5)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from7Bit: 127), 1.0)
        
    }
    
    func testScaled_7Bit_from_UnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.0), 0)
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 0.5), 64)
        XCTAssertEqual(MIDI.Event.scaled7Bit(fromUnitInterval: 1.0), 127)
        
    }
    
    // MARK: - Unit Interval <--> 14-Bit
    
    func testScaled_UnitInterval_from_14Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x0000), 0.0)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x2000), 0.5)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from14Bit: 0x3FFF), 1.0)
        
    }
    
    func testScaled_14Bit_from_UnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.0), 0x0000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 0.5), 0x2000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromUnitInterval: 1.0), 0x3FFF)
        
    }
    
    // MARK: - Unit Interval <--> 16-Bit
    
    func testScaled_UnitInterval_from_16Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0x0000), 0.0)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0x8000), 0.5)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from16Bit: 0xFFFF), 1.0)
        
    }
    
    func testScaled_16Bit_from_UnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.0), 0x0000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 0.5), 0x8000)
        XCTAssertEqual(MIDI.Event.scaled16Bit(fromUnitInterval: 1.0), 0xFFFF)
        
    }
    
    // MARK: - Unit Interval <--> 32-Bit
    
    func testScaled_UnitInterval_from_32Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0x00000000), 0.0)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0x80000000), 0.5)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(from32Bit: 0xFFFFFFFF), 1.0)
        
    }
    
    func testScaled_32Bit_from_UnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.0), 0x00000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 0.5), 0x80000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromUnitInterval: 1.0), 0xFFFFFFFF)
        
    }
    
    // MARK: - Bipolar Unit Interval <--> Unit Interval
    
    func testScaled_BipolarUnitInterval_from_UnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.00), -1.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.25), -0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.50),  0.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 0.75),  0.5)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(fromUnitInterval: 1.00),  1.0)
        
    }
    
    func testScaled_UnitInterval_from_BipolarUnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval: -1.0), 0.00)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval: -0.5), 0.25)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  0.0), 0.50)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  0.5), 0.75)
        XCTAssertEqual(MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval:  1.0), 1.00)
        
    }
    
    // MARK: - Bipolar Unit Interval <--> 14-Bit
    
    func testScaled_BipolarUnitInterval_from_14Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x0000), -1.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x2000),  0.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from14Bit: 0x3FFF),  1.0)
        
    }
    
    func testScaled_14Bit_from_BipolarUnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval: -1.0), 0x0000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval:  0.0), 0x2000)
        XCTAssertEqual(MIDI.Event.scaled14Bit(fromBipolarUnitInterval:  1.0), 0x3FFF)
        
    }
    
    // MARK: - Bipolar Unit Interval <--> 32-Bit
    
    func testScaled_BipolarUnitInterval_from_32Bit() {
        
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0x00000000), -1.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0x80000000),  0.0)
        XCTAssertEqual(MIDI.Event.scaledBipolarUnitInterval(from32Bit: 0xFFFFFFFF),  1.0)
        
    }
    
    func testScaled_32Bit_from_BipolarUnitInterval() {
        
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval: -1.0), 0x00000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval:  0.0), 0x80000000)
        XCTAssertEqual(MIDI.Event.scaled32Bit(fromBipolarUnitInterval:  1.0), 0xFFFFFFFF)
        
    }
    
}

#endif
