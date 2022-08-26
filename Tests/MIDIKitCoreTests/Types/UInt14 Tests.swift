//
//  UInt14 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class UInt14_Tests: XCTestCase {
    fileprivate let _min      = 0b000000_00000000 // int     0, hex 0x0000
    fileprivate let _midpoint = 0b100000_00000000 // int  8192, hex 0x2000
    fileprivate let _max      = 0b111111_11111111 // int 16383, hex 0x3FFF
    
    func testInit_BinaryInteger() {
        // default
    
        XCTAssertEqual(UInt14().intValue, 0)
    
        // different integer types
    
        XCTAssertEqual(UInt14(0), 0)
        XCTAssertEqual(UInt14(UInt8(0)), 0)
        XCTAssertEqual(UInt14(UInt16(0)), 0)
    
        // values
    
        XCTAssertEqual(UInt14(1), 1)
        XCTAssertEqual(UInt14(2), 2)
    
        // overflow
    
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows { [self] in
        //    _ = UInt14(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt14(_max + 1)
        // }
    }
    
    func testInit_BinaryInteger_Exactly() {
        // typical
    
        XCTAssertEqual(UInt14(exactly: 0), 0)
    
        XCTAssertEqual(UInt14(exactly: 1), 1)
    
        XCTAssertEqual(UInt14(exactly: _max)?.intValue, _max)
    
        // overflow
    
        XCTAssertNil(UInt14(exactly: -1))
    
        XCTAssertNil(UInt14(exactly: _max + 1))
    }
    
    func testInit_BinaryInteger_Clamping() {
        // within range
    
        XCTAssertEqual(UInt14(clamping: 0), 0)
        XCTAssertEqual(UInt14(clamping: 1), 1)
        XCTAssertEqual(UInt14(clamping: _max).intValue, _max)
    
        // overflow
    
        XCTAssertEqual(UInt14(clamping: -1).intValue, 0)
        XCTAssertEqual(UInt14(clamping: _max + 1).intValue, _max)
    }
    
    func testInit_BinaryFloatingPoint() {
        XCTAssertEqual(UInt14(Double(0)).intValue, 0)
        XCTAssertEqual(UInt14(Double(1)).intValue, 1)
        XCTAssertEqual(UInt14(Double(5.9)).intValue, 5)
    
        XCTAssertEqual(UInt14(Float(0)).intValue, 0)
        XCTAssertEqual(UInt14(Float(1)).intValue, 1)
        XCTAssertEqual(UInt14(Float(5.9)).intValue, 5)
    
        // overflow
    
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
    
        // _XCTAssertThrows {
        //    _ = UInt14(Double(0 - 1))
        //    _ = UInt14(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt14(Double(_max + 1))
        //    _ = UInt14(Float(_max + 1))
        // }
    }
    
    func testInit_BinaryFloatingPoint_Exactly() {
        // typical
    
        XCTAssertEqual(UInt14(exactly: 0.0), 0)
    
        XCTAssertEqual(UInt14(exactly: 1.0), 1)
    
        XCTAssertEqual(UInt14(exactly: Double(_max))?.intValue, _max)
    
        // overflow
    
        XCTAssertNil(UInt14(exactly: -1.0))
    
        XCTAssertNil(UInt14(exactly: Double(_max) + 1.0))
    }
    
    func testInitBipolarUnitInterval() {
        XCTAssertEqual(UInt14(bipolarUnitInterval: -1.0).intValue, _min)
        XCTAssertEqual(UInt14(bipolarUnitInterval: -0.5).intValue, 4096)
        XCTAssertEqual(UInt14(bipolarUnitInterval:  0.0).intValue, _midpoint)
        XCTAssertEqual(UInt14(bipolarUnitInterval:  0.5).intValue, 12287)
        XCTAssertEqual(UInt14(bipolarUnitInterval:  1.0).intValue, _max)
    }
    
    func testInitBytePair() {
        XCTAssertEqual(
            UInt14(bytePair: BytePair(msb: 0x00, lsb: 0x00)).intValue,
            _min
        )
        XCTAssertEqual(
            UInt14(bytePair: BytePair(msb: 0x40, lsb: 0x00)).intValue,
            _midpoint
        )
        XCTAssertEqual(
            UInt14(bytePair: BytePair(msb: 0x7F, lsb: 0x7F)).intValue,
            _max
        )
    }
    
    func testInitUInt7Pair() {
        XCTAssertEqual(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x00, lsb: 0x00)).intValue,
            _min
        )
        XCTAssertEqual(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x40, lsb: 0x00)).intValue,
            _midpoint
        )
        XCTAssertEqual(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x7F, lsb: 0x7F)).intValue,
            _max
        )
    }
    
    func testMin() {
        XCTAssertEqual(UInt14.min.intValue, _min)
    }
    
    func testMax() {
        XCTAssertEqual(UInt14.max.intValue, _max)
    }
    
    func testComputedProperties() {
        XCTAssertEqual(UInt14(1).intValue, 1)
        XCTAssertEqual(UInt14(1).uInt16Value, 1)
    }
    
    func testStrideable() {
        let min = UInt14(_min)
        let max = UInt14(_max)
    
        let strideBy1 = stride(from: min, through: max, by: 1)
        XCTAssertEqual(strideBy1.underestimatedCount, _max + 1)
        XCTAssertTrue(strideBy1.starts(with: [min]))
        XCTAssertEqual(strideBy1.suffix(1), [max])
    
        let range = min ... max
        XCTAssertEqual(range.count, _max + 1)
        XCTAssertEqual(range.lowerBound, min)
        XCTAssertEqual(range.upperBound, max)
    }
    
    func testBipolarUnitIntervalValue() {
        XCTAssertEqual(UInt14(_min).bipolarUnitIntervalValue, -1.0)
        XCTAssertEqual(UInt14(4096).bipolarUnitIntervalValue, -0.5)
        XCTAssertEqual(UInt14(_midpoint).bipolarUnitIntervalValue, 0.0)
        XCTAssertEqual(UInt14(12287).bipolarUnitIntervalValue, 0.5, accuracy: 0.0001)
        XCTAssertEqual(UInt14(_max).bipolarUnitIntervalValue, 1.0)
    }
    
    func testBytePair() {
        XCTAssertEqual(UInt14(_min).bytePair.msb, 0x00)
        XCTAssertEqual(UInt14(_min).bytePair.lsb, 0x00)
    
        XCTAssertEqual(UInt14(_midpoint).bytePair.msb, 0x40)
        XCTAssertEqual(UInt14(_midpoint).bytePair.lsb, 0x00)
    
        XCTAssertEqual(UInt14(_max).bytePair.msb, 0x7F)
        XCTAssertEqual(UInt14(_max).bytePair.lsb, 0x7F)
    }
    
    func testUInt7Pair() {
        XCTAssertEqual(UInt14(_min).midiUInt7Pair.msb, 0x00)
        XCTAssertEqual(UInt14(_min).midiUInt7Pair.lsb, 0x00)
    
        XCTAssertEqual(UInt14(_midpoint).midiUInt7Pair.msb, 0x40)
        XCTAssertEqual(UInt14(_midpoint).midiUInt7Pair.lsb, 0x00)
    
        XCTAssertEqual(UInt14(_max).midiUInt7Pair.msb, 0x7F)
        XCTAssertEqual(UInt14(_max).midiUInt7Pair.lsb, 0x7F)
    }
    
    func testEquatable() {
        XCTAssertTrue(UInt14(0) == UInt14(0))
        XCTAssertTrue(UInt14(1) == UInt14(1))
        XCTAssertTrue(UInt14(_max) == UInt14(_max))
    
        XCTAssertTrue(UInt14(0) != UInt14(1))
    }
    
    func testComparable() {
        XCTAssertFalse(UInt14(0) > UInt14(0))
        XCTAssertFalse(UInt14(1) > UInt14(1))
        XCTAssertFalse(UInt14(_max) > UInt14(_max))
    
        XCTAssertTrue(UInt14(0) < UInt14(1))
        XCTAssertTrue(UInt14(1) > UInt14(0))
    }
    
    func testHashable() {
        let set = Set<UInt14>([0, 1, 1, 2])
    
        XCTAssertEqual(set.count, 3)
        XCTAssertTrue(set == [0, 1, 2])
    }
    
    func testCodable() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
    
        // encode
    
        let encoded = try? encoder.encode(UInt14(_max))
    
        let encodedString = String(data: encoded!, encoding: .utf8)
    
        XCTAssertEqual(encodedString, #"{"UInt14":16383}"#)
    
        // decode
    
        let decoded = try? decoder.decode(UInt14.self, from: encoded!)
    
        // assert value is identical to source
    
        XCTAssertEqual(decoded, UInt14(_max))
    }
    
    // MARK: - Standard library extensions
    
    func testBinaryInteger_UInt14() {
        XCTAssertEqual(10.toUInt14, 10)
    
        XCTAssertEqual(Int8(10).toUInt14, 10)
        XCTAssertEqual(UInt8(10).toUInt14, 10)
    
        XCTAssertEqual(Int16(10).toUInt14, 10)
        XCTAssertEqual(UInt16(10).toUInt14, 10)
    }
    
    func testBinaryInteger_UInt14Exactly() {
        XCTAssertEqual(0b000000_00000000.toUInt14Exactly, 0b000000_00000000)
        XCTAssertEqual(0b111111_11111111.toUInt14Exactly, 0b111111_11111111)
    
        XCTAssertEqual(Int8(10).toUInt14Exactly, 10)
        XCTAssertEqual(UInt8(10).toUInt14Exactly, 10)
    
        XCTAssertEqual(Int16(10).toUInt14Exactly, 10)
        XCTAssertEqual(UInt16(10).toUInt14Exactly, 10)
    
        // nil (overflow)
    
        XCTAssertNil(0b1000000_00000000.toUInt14Exactly)
    }
    
    func testBinaryInteger_Init_UInt14() {
        XCTAssertEqual(Int(10.toUInt14), 10)
        XCTAssertEqual(Int(exactly: 10.toUInt14), 10)
    
        XCTAssertEqual(Int(exactly: 0b111111_11111111.toUInt14), 0b111111_11111111)
        XCTAssertNil(UInt8(exactly: 0b111111_11111111.toUInt14))
    }
    
    // MARK: - Operators
    
    func testOperators() {
        XCTAssertEqual(1.toUInt14 + 1, 2.toUInt14)
        XCTAssertEqual(1 + 1.toUInt14, 2.toUInt14)
        XCTAssertEqual(1.toUInt14 + 1.toUInt14, 2)
    
        XCTAssertEqual(2.toUInt14 - 1, 1.toUInt14)
        XCTAssertEqual(2 - 1.toUInt14, 1.toUInt14)
        XCTAssertEqual(2.toUInt14 - 1.toUInt14, 1)
    
        XCTAssertEqual(2.toUInt14 * 2, 4.toUInt14)
        XCTAssertEqual(2 * 2.toUInt14, 4.toUInt14)
        XCTAssertEqual(2.toUInt14 * 2.toUInt14, 4)
    
        XCTAssertEqual(8.toUInt14 / 2, 4.toUInt14)
        XCTAssertEqual(8 / 2.toUInt14, 4.toUInt14)
        XCTAssertEqual(8.toUInt14 / 2.toUInt14, 4)
    
        XCTAssertEqual(8.toUInt14 % 3, 2.toUInt14)
        XCTAssertEqual(8 % 3.toUInt14, 2.toUInt14)
        XCTAssertEqual(8.toUInt14 % 3.toUInt14, 2)
    }
    
    func testAssignmentOperators() {
        var val = UInt14(2)
    
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
