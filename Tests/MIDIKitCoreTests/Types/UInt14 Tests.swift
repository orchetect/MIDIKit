//
//  UInt14 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct UInt14_Tests {
    fileprivate let _min      = 0b000000_00000000 // int     0, hex 0x0000
    fileprivate let _midpoint = 0b100000_00000000 // int  8192, hex 0x2000
    fileprivate let _max      = 0b111111_11111111 // int 16383, hex 0x3FFF
    
    @Test
    func init_BinaryInteger() {
        // default
        
        #expect(UInt14().intValue == 0)
        
        // different integer types
        
        #expect(UInt14(0) == 0)
        #expect(UInt14(UInt8(0)) == 0)
        #expect(UInt14(UInt16(0)) == 0)
        
        // values
        
        #expect(UInt14(1) == 1)
        #expect(UInt14(2) == 2)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows { [self] in
        //     _ = UInt14(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt14(_max + 1)
        // }
    }
    
    @Test
    func init_BinaryInteger_Exactly() {
        // typical
        
        #expect(UInt14(exactly: 0) == 0)
        
        #expect(UInt14(exactly: 1) == 1)
        
        #expect(UInt14(exactly: _max)?.intValue == _max)
        
        // overflow
        
        #expect(UInt14(exactly: -1) == nil)
        
        #expect(UInt14(exactly: _max + 1) == nil)
    }
    
    @Test
    func init_BinaryInteger_Clamping() {
        // within range
        
        #expect(UInt14(clamping: 0) == 0)
        #expect(UInt14(clamping: 1) == 1)
        #expect(UInt14(clamping: _max).intValue == _max)
        
        // overflow
        
        #expect(UInt14(clamping: -1).intValue == 0)
        #expect(UInt14(clamping: _max + 1).intValue == _max)
    }
    
    @Test
    func init_BinaryFloatingPoint() {
        #expect(UInt14(Double(0)).intValue == 0)
        #expect(UInt14(Double(1)).intValue == 1)
        #expect(UInt14(Double(5.9)).intValue == 5)
        
        #expect(UInt14(Float(0)).intValue == 0)
        #expect(UInt14(Float(1)).intValue == 1)
        #expect(UInt14(Float(5.9)).intValue == 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //     _ = UInt14(Double(0 - 1))
        //     _ = UInt14(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt14(Double(_max + 1))
        //     _ = UInt14(Float(_max + 1))
        // }
    }
    
    @Test
    func init_BinaryFloatingPoint_Exactly() {
        // typical
        
        #expect(UInt14(exactly: 0.0) == 0)
        
        #expect(UInt14(exactly: 1.0) == 1)
        
        #expect(UInt14(exactly: Double(_max))?.intValue == _max)
        
        // overflow
        
        #expect(UInt14(exactly: -1.0) == nil)
        
        #expect(UInt14(exactly: Double(_max) + 1.0) == nil)
    }
    
    @Test
    func initBipolarUnitInterval() {
        #expect(UInt14(bipolarUnitInterval: -1.0).intValue == _min)
        #expect(UInt14(bipolarUnitInterval: -0.5).intValue == 4096)
        #expect(UInt14(bipolarUnitInterval:  0.0).intValue == _midpoint)
        #expect(UInt14(bipolarUnitInterval:  0.5).intValue == 12287)
        #expect(UInt14(bipolarUnitInterval:  1.0).intValue == _max)
    }
    
    @Test
    func initBytePair() {
        #expect(
            UInt14(bytePair: BytePair(msb: 0x00, lsb: 0x00)).intValue ==
            _min
        )
        #expect(
            UInt14(bytePair: BytePair(msb: 0x40, lsb: 0x00)).intValue ==
            _midpoint
        )
        #expect(
            UInt14(bytePair: BytePair(msb: 0x7F, lsb: 0x7F)).intValue ==
            _max
        )
    }
    
    @Test
    func initUInt7Pair() {
        #expect(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x00, lsb: 0x00)).intValue ==
            _min
        )
        #expect(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x40, lsb: 0x00)).intValue ==
            _midpoint
        )
        #expect(
            UInt14(uInt7Pair: UInt7Pair(msb: 0x7F, lsb: 0x7F)).intValue ==
            _max
        )
    }
    
    @Test
    func testMin() {
        #expect(UInt14.min.intValue == _min)
    }
    
    @Test
    func testMax() {
        #expect(UInt14.max.intValue == _max)
    }
    
    @Test
    func computedProperties() {
        #expect(UInt14(1).intValue == 1)
        #expect(UInt14(1).uInt16Value == 1)
    }
    
    @Test
    func strideable() {
        let min = UInt14(_min)
        let max = UInt14(_max)
        
        let strideBy1 = stride(from: min, through: max, by: 1)
        #expect(strideBy1.underestimatedCount == _max + 1)
        #expect(strideBy1.starts(with: [min]))
        #expect(strideBy1.suffix(1) == [max])
        
        let range = min ... max
        #expect(range.count == _max + 1)
        #expect(range.lowerBound == min)
        #expect(range.upperBound == max)
    }
    
    @Test
    func bipolarUnitIntervalValue() {
        #expect(UInt14(_min).bipolarUnitIntervalValue == -1.0)
        #expect(UInt14(4096).bipolarUnitIntervalValue == -0.5)
        #expect(UInt14(_midpoint).bipolarUnitIntervalValue == 0.0)
        #expect(UInt14(12287).bipolarUnitIntervalValue == 0.5 - 0.00006104260774020265) // , accuracy: 0.0001)
        #expect(UInt14(_max).bipolarUnitIntervalValue == 1.0)
    }
    
    @Test
    func bytePair() {
        #expect(UInt14(_min).bytePair.msb == 0x00)
        #expect(UInt14(_min).bytePair.lsb == 0x00)
        
        #expect(UInt14(_midpoint).bytePair.msb == 0x40)
        #expect(UInt14(_midpoint).bytePair.lsb == 0x00)
        
        #expect(UInt14(_max).bytePair.msb == 0x7F)
        #expect(UInt14(_max).bytePair.lsb == 0x7F)
    }
    
    @Test
    func uInt7Pair() {
        #expect(UInt14(_min).midiUInt7Pair.msb == 0x00)
        #expect(UInt14(_min).midiUInt7Pair.lsb == 0x00)
        
        #expect(UInt14(_midpoint).midiUInt7Pair.msb == 0x40)
        #expect(UInt14(_midpoint).midiUInt7Pair.lsb == 0x00)
        
        #expect(UInt14(_max).midiUInt7Pair.msb == 0x7F)
        #expect(UInt14(_max).midiUInt7Pair.lsb == 0x7F)
    }
    
    @Test
    func equatable() {
        #expect(UInt14(0) == UInt14(0))
        #expect(UInt14(1) == UInt14(1))
        #expect(UInt14(_max) == UInt14(_max))
        
        #expect(UInt14(0) != UInt14(1))
    }
    
    @Test
    func comparable() {
        #expect(!(UInt14(0) > UInt14(0)))
        #expect(!(UInt14(1) > UInt14(1)))
        #expect(!(UInt14(_max) > UInt14(_max)))
        
        #expect(UInt14(0) < UInt14(1))
        #expect(UInt14(1) > UInt14(0))
    }
    
    @Test
    func hashable() {
        let set = Set<UInt14>([0, 1, 1, 2])
        
        #expect(set.count == 3)
        #expect(set == [0, 1, 2])
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt14(_max))
        let decoded = try decoder.decode(UInt14.self, from: encoded)
        
        #expect(decoded == UInt14(_max))
    }
    
    // MARK: - Standard library extensions
    
    @Test
    func binaryInteger_UInt14() {
        #expect(10.toUInt14 == 10)
        
        #expect(Int8(10).toUInt14 == 10)
        #expect(UInt8(10).toUInt14 == 10)
        
        #expect(Int16(10).toUInt14 == 10)
        #expect(UInt16(10).toUInt14 == 10)
    }
    
    @Test
    func binaryInteger_UInt14Exactly() {
        #expect(0b000000_00000000.toUInt14Exactly == 0b000000_00000000)
        #expect(0b111111_11111111.toUInt14Exactly == 0b111111_11111111)
        
        #expect(Int8(10).toUInt14Exactly == 10)
        #expect(UInt8(10).toUInt14Exactly == 10)
        
        #expect(Int16(10).toUInt14Exactly == 10)
        #expect(UInt16(10).toUInt14Exactly == 10)
        
        // nil (overflow)
        
        #expect(0b1000000_00000000.toUInt14Exactly == nil)
    }
    
    @Test
    func binaryInteger_Init_UInt14() {
        #expect(Int(10.toUInt14) == 10)
        #expect(Int(exactly: 10.toUInt14) == 10)
        
        #expect(Int(exactly: 0b111111_11111111.toUInt14) == 0b111111_11111111)
        #expect(UInt8(exactly: 0b111111_11111111.toUInt14) == nil)
    }
    
    // MARK: - Operators
    
    @Test
    func operators() {
        #expect(1.toUInt14 + 1 == 2.toUInt14)
        #expect(1 + 1.toUInt14 == 2.toUInt14)
        #expect(1.toUInt14 + 1.toUInt14 == 2)
        
        #expect(2.toUInt14 - 1 == 1.toUInt14)
        #expect(2 - 1.toUInt14 == 1.toUInt14)
        #expect(2.toUInt14 - 1.toUInt14 == 1)
        
        #expect(2.toUInt14 * 2 == 4.toUInt14)
        #expect(2 * 2.toUInt14 == 4.toUInt14)
        #expect(2.toUInt14 * 2.toUInt14 == 4)
        
        #expect(8.toUInt14 / 2 == 4.toUInt14)
        #expect(8 / 2.toUInt14 == 4.toUInt14)
        #expect(8.toUInt14 / 2.toUInt14 == 4)
        
        #expect(8.toUInt14 % 3 == 2.toUInt14)
        #expect(8 % 3.toUInt14 == 2.toUInt14)
        #expect(8.toUInt14 % 3.toUInt14 == 2)
    }
    
    @Test
    func assignmentOperators() {
        var val = UInt14(2)
        
        val += 5
        #expect(val == 7)
        
        val -= 5
        #expect(val == 2)
        
        val *= 3
        #expect(val == 6)
        
        val /= 3
        #expect(val == 2)
    }
}
