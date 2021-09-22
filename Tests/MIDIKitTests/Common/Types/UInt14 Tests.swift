//
//  UInt14 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import XCTestExtensions

final class UInt14_Tests: XCTestCase {
    
    fileprivate let _min      = 0b00_0000_0000_0000
    fileprivate let _midpoint = 0b10_0000_0000_0000
    fileprivate let _max      = 0b11_1111_1111_1111
    
    func testInit_BinaryInteger() {
        
        // default
        
        XCTAssertEqual(MIDI.UInt14().value, 0)
        
        // different integer types
        
        XCTAssertEqual(MIDI.UInt14(0), 0)
        XCTAssertEqual(MIDI.UInt14(UInt8(0)), 0)
        XCTAssertEqual(MIDI.UInt14(UInt16(0)), 0)
        
        // values
        
        XCTAssertEqual(MIDI.UInt14(1), 1)
        XCTAssertEqual(MIDI.UInt14(2), 2)
        
        // overflow
        
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt14(_min - 1)
        }
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt14(_max + 1)
        }
        
    }
    
    func testInit_BinaryInteger_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt14(exactly: 0), 0)
        
        XCTAssertEqual(MIDI.UInt14(exactly: 1), 1)
        
        XCTAssertEqual(MIDI.UInt14(exactly: _max)?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt14(exactly: -1))
        
        XCTAssertNil(MIDI.UInt14(exactly: _max + 1))
        
    }
    
    func testInit_BinaryInteger_Clamping() {
        
        // within range
        
        XCTAssertEqual(MIDI.UInt14(clamping: 0), 0)
        XCTAssertEqual(MIDI.UInt14(clamping: 1), 1)
        XCTAssertEqual(MIDI.UInt14(clamping: _max).intValue, _max)
        
        // overflow
        
        XCTAssertEqual(MIDI.UInt14(clamping: -1).intValue, 0)
        XCTAssertEqual(MIDI.UInt14(clamping: _max + 1).intValue, _max)
        
    }
    
    func testInit_BinaryFloatingPoint() {
        
        XCTAssertEqual(MIDI.UInt14(Double(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt14(Double(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt14(Double(5.9)).intValue, 5)
        
        XCTAssertEqual(MIDI.UInt14(Float(0)).intValue, 0)
        XCTAssertEqual(MIDI.UInt14(Float(1)).intValue, 1)
        XCTAssertEqual(MIDI.UInt14(Float(5.9)).intValue, 5)
        
        // overflow
        
        _XCTAssertThrows {
            _ = MIDI.UInt14(Double(0 - 1))
            _ = MIDI.UInt14(Float(0 - 1))
        }
        
        _XCTAssertThrows { [self] in
            _ = MIDI.UInt14(Double(_max + 1))
            _ = MIDI.UInt14(Float(_max + 1))
        }
        
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        
        // typical
        
        XCTAssertEqual(MIDI.UInt14(exactly: 0.0), 0)
        
        XCTAssertEqual(MIDI.UInt14(exactly: 1.0), 1)
        
        XCTAssertEqual(MIDI.UInt14(exactly: Double(_max))?.intValue, _max)
        
        // overflow
        
        XCTAssertNil(MIDI.UInt14(exactly: -1.0))
        
        XCTAssertNil(MIDI.UInt14(exactly: Double(_max) + 1.0))
        
    }
    
    func testInitZeroMidpointFloat() {
        
        XCTAssertEqual(MIDI.UInt14(unitIntervalAroundZero: -1.0).intValue, _min)
        XCTAssertEqual(MIDI.UInt14(unitIntervalAroundZero: -0.5).intValue, 4096)
        XCTAssertEqual(MIDI.UInt14(unitIntervalAroundZero:  0.0).intValue, _midpoint)
        XCTAssertEqual(MIDI.UInt14(unitIntervalAroundZero:  0.5).intValue, 12287)
        XCTAssertEqual(MIDI.UInt14(unitIntervalAroundZero:  1.0).intValue, _max)
        
    }
    
    func testInitBytePair() {
        
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.Byte.Pair(msb: 0x00, lsb: 0x00)).intValue, _min)
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.Byte.Pair(msb: 0x40, lsb: 0x00)).intValue, _midpoint)
        XCTAssertEqual(MIDI.UInt14(bytePair: MIDI.Byte.Pair(msb: 0x7F, lsb: 0x7F)).intValue, _max)
        
    }
    
    func testInitUInt7Pair() {
        
        XCTAssertEqual(MIDI.UInt14(uInt7Pair: MIDI.UInt7.Pair(msb: 0x00, lsb: 0x00)).intValue, _min)
        XCTAssertEqual(MIDI.UInt14(uInt7Pair: MIDI.UInt7.Pair(msb: 0x40, lsb: 0x00)).intValue, _midpoint)
        XCTAssertEqual(MIDI.UInt14(uInt7Pair: MIDI.UInt7.Pair(msb: 0x7F, lsb: 0x7F)).intValue, _max)
        
    }
    
    func testMin() {
        
        XCTAssertEqual(MIDI.UInt14.min.intValue, _min)
        
    }
    
    func testMax() {
        
        XCTAssertEqual(MIDI.UInt14.max.intValue, _max)
        
    }
    
    func testComputedProperties() {
        
        XCTAssertEqual(MIDI.UInt14(1).intValue, 1)
        XCTAssertEqual(MIDI.UInt14(1).uInt16Value, 1)
        
    }
    
    func testZeroMidpointFloat() {
        
        XCTAssertEqual(MIDI.UInt14(_min).unitIntervalAroundZero, -1.0)
        XCTAssertEqual(MIDI.UInt14(4096).unitIntervalAroundZero, -0.5)
        XCTAssertEqual(MIDI.UInt14(_midpoint).unitIntervalAroundZero, 0.0)
        XCTAssertEqual(MIDI.UInt14(12287).unitIntervalAroundZero, 0.5, accuracy: 0.0001)
        XCTAssertEqual(MIDI.UInt14(_max).unitIntervalAroundZero, 1.0)
        
    }
    
    func testBytePair() {
        
        XCTAssertEqual(MIDI.UInt14(_min).bytePair.msb, 0x00)
        XCTAssertEqual(MIDI.UInt14(_min).bytePair.lsb, 0x00)
        
        XCTAssertEqual(MIDI.UInt14(_midpoint).bytePair.msb, 0x40)
        XCTAssertEqual(MIDI.UInt14(_midpoint).bytePair.lsb, 0x00)
        
        XCTAssertEqual(MIDI.UInt14(_max).bytePair.msb, 0x7F)
        XCTAssertEqual(MIDI.UInt14(_max).bytePair.lsb, 0x7F)
        
    }
    
    func testUInt7Pair() {
        
        XCTAssertEqual(MIDI.UInt14(_min).midiUInt7Pair.msb, 0x00)
        XCTAssertEqual(MIDI.UInt14(_min).midiUInt7Pair.lsb, 0x00)
        
        XCTAssertEqual(MIDI.UInt14(_midpoint).midiUInt7Pair.msb, 0x40)
        XCTAssertEqual(MIDI.UInt14(_midpoint).midiUInt7Pair.lsb, 0x00)
        
        XCTAssertEqual(MIDI.UInt14(_max).midiUInt7Pair.msb, 0x7F)
        XCTAssertEqual(MIDI.UInt14(_max).midiUInt7Pair.lsb, 0x7F)
        
    }
    
    func testEquatable() {
        
        XCTAssertTrue(MIDI.UInt14(0) == MIDI.UInt14(0))
        XCTAssertTrue(MIDI.UInt14(1) == MIDI.UInt14(1))
        XCTAssertTrue(MIDI.UInt14(_max) == MIDI.UInt14(_max))
        
        XCTAssertTrue(MIDI.UInt14(0) != MIDI.UInt14(1))
        
    }
    
    func testComparable() {
        
        XCTAssertFalse(MIDI.UInt14(0) > MIDI.UInt14(0))
        XCTAssertFalse(MIDI.UInt14(1) > MIDI.UInt14(1))
        XCTAssertFalse(MIDI.UInt14(_max) > MIDI.UInt14(_max))
        
        XCTAssertTrue(MIDI.UInt14(0) < MIDI.UInt14(1))
        XCTAssertTrue(MIDI.UInt14(1) > MIDI.UInt14(0))
        
    }
    
    func testHashable() {
        
        let set = Set<MIDI.UInt14>([0, 1, 1, 2])
        
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set == [0,1,2])
        
    }
    
    func testCodable() {
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        // encode
        
        let encoded = try? encoder.encode(MIDI.UInt14(_max))
        
        let encodedString = String(data: encoded!, encoding: .utf8)
        
        XCTAssertEqual(encodedString, #"{"UInt14":16383}"#)
        
        // decode
        
        let decoded = try? decoder.decode(MIDI.UInt14.self, from: encoded!)
        
        // assert value is identical to source
        
        XCTAssertEqual(decoded, MIDI.UInt14(_max))
        
    }
    
    // MARK: - Standard library extensions
    
    func testBinaryInteger_UInt14() {
        
        XCTAssertEqual(10.toMIDIUInt14, 10)
        
        XCTAssertEqual(Int8(10).toMIDIUInt14, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt14, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt14, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt14, 10)
        
    }
    
    func testBinaryInteger_UInt14Exactly() {
        
        XCTAssertEqual(0b00_0000_0000_0000.toMIDIUInt14Exactly, 0b00_0000_0000_0000)
        XCTAssertEqual(0b11_1111_1111_1111.toMIDIUInt14Exactly, 0b11_1111_1111_1111)
        
        XCTAssertEqual(Int8(10).toMIDIUInt14Exactly, 10)
        XCTAssertEqual(UInt8(10).toMIDIUInt14Exactly, 10)
        
        XCTAssertEqual(Int16(10).toMIDIUInt14Exactly, 10)
        XCTAssertEqual(UInt16(10).toMIDIUInt14Exactly, 10)
        
        // nil (overflow)
        
        XCTAssertNil(0b100_0000_0000_0000.toMIDIUInt14Exactly)
        
    }
    
    func testBinaryInteger_Init_UInt14() {
        
        XCTAssertEqual(Int(10.toMIDIUInt14), 10)
        XCTAssertEqual(Int(exactly: 10.toMIDIUInt14), 10)
        
        XCTAssertEqual(Int(exactly: 0b11_1111_1111_1111.toMIDIUInt14), 0b11_1111_1111_1111)
        XCTAssertNil(UInt8(exactly: 0b11_1111_1111_1111.toMIDIUInt14))
        
    }
    
    // MARK: - Operators
    
    func testOperators() {
        
        XCTAssertEqual(1.toMIDIUInt14 + 1              , 2.toMIDIUInt14)
        XCTAssertEqual(1 + 1.toMIDIUInt14              , 2.toMIDIUInt14)
        XCTAssertEqual(1.toMIDIUInt14 + 1.toMIDIUInt14 , 2)
        
        XCTAssertEqual(2.toMIDIUInt14 - 1              , 1.toMIDIUInt14)
        XCTAssertEqual(2 - 1.toMIDIUInt14              , 1.toMIDIUInt14)
        XCTAssertEqual(2.toMIDIUInt14 - 1.toMIDIUInt14 , 1)
        
        XCTAssertEqual(2.toMIDIUInt14 * 2              , 4.toMIDIUInt14)
        XCTAssertEqual(2 * 2.toMIDIUInt14              , 4.toMIDIUInt14)
        XCTAssertEqual(2.toMIDIUInt14 * 2.toMIDIUInt14 , 4)
        
        XCTAssertEqual(8.toMIDIUInt14 / 2              , 4.toMIDIUInt14)
        XCTAssertEqual(8 / 2.toMIDIUInt14              , 4.toMIDIUInt14)
        XCTAssertEqual(8.toMIDIUInt14 / 2.toMIDIUInt14 , 4)
        
        XCTAssertEqual(8.toMIDIUInt14 % 3              , 2.toMIDIUInt14)
        XCTAssertEqual(8 % 3.toMIDIUInt14              , 2.toMIDIUInt14)
        XCTAssertEqual(8.toMIDIUInt14 % 3.toMIDIUInt14 , 2)
        
    }
    
    func testAssignmentOperators() {
        
        var val = MIDI.UInt14(2)
        
        val += 5
        XCTAssertEqual(val, 7)
        
        val -= 5
        XCTAssertEqual(val, 2)
        
        val *= 3
        XCTAssertEqual(val, 6)
        
        val /= 3
        XCTAssertEqual(val, 2)
        
    }
    
}

#endif
