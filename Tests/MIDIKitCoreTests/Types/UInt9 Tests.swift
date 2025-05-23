//
//  UInt9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct UInt9_Tests {
    private let _min      = 0b0_00000000 // int   0, hex 0x000
    private let _midpoint = 0b1_00000000 // int 256, hex 0x0FF
    private let _max      = 0b1_11111111 // int 511, hex 0x1FF
    
    @Test
    func init_BinaryInteger() {
        // default
        
        #expect(UInt9().intValue == 0)
        
        // different integer types
        
        #expect(UInt9(0).intValue == 0)
        #expect(UInt9(UInt8(0)).intValue == 0)
        #expect(UInt9(UInt16(0)).intValue == 0)
        
        // values
        
        #expect(UInt9(1).intValue == 1)
        #expect(UInt9(2).intValue == 2)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows { [self] in
        //     _ = UInt9(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt9(_max + 1)
        // }
    }
    
    @Test
    func init_BinaryInteger_Exactly() {
        // typical
        
        #expect(UInt9(exactly: 0)?.intValue == 0)
        
        #expect(UInt9(exactly: 1)?.intValue == 1)
        
        #expect(UInt9(exactly: _max)?.intValue == _max)
        
        // overflow
        
        #expect(UInt9(exactly: -1) == nil)
        
        #expect(UInt9(exactly: _max + 1) == nil)
    }
    
    @Test
    func init_BinaryInteger_Clamping() {
        // within range
        
        #expect(UInt9(clamping: 0).intValue == 0)
        #expect(UInt9(clamping: 1).intValue == 1)
        #expect(UInt9(clamping: _max).intValue == _max)
        
        // overflow
        
        #expect(UInt9(clamping: -1).intValue == 0)
        #expect(UInt9(clamping: _max + 1).intValue == _max)
    }
    
    @Test
    func init_BinaryFloatingPoint() {
        #expect(UInt9(Double(0)).intValue == 0)
        #expect(UInt9(Double(1)).intValue == 1)
        #expect(UInt9(Double(5.9)).intValue == 5)
        
        #expect(UInt9(Float(0)).intValue == 0)
        #expect(UInt9(Float(1)).intValue == 1)
        #expect(UInt9(Float(5.9)).intValue == 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //    _ = UInt9(Double(0 - 1))
        //    _ = UInt9(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //    _ = UInt9(Double(_max + 1))
        //    _ = UInt9(Float(_max + 1))
        // }
    }
    
    @Test
    func init_BinaryFloatingPoint_Exactly() {
        // typical
        
        #expect(UInt9(exactly: 0.0) == 0)
        
        #expect(UInt9(exactly: 1.0) == 1)
        
        #expect(UInt9(exactly: Double(_max))?.intValue == _max)
        
        // overflow
        
        #expect(UInt9(exactly: -1.0) == nil)
        
        #expect(UInt9(exactly: Double(_max) + 1.0) == nil)
    }
    
    @Test
    func testMin() {
        #expect(UInt9.min.intValue == _min)
    }
    
    @Test
    func testMax() {
        #expect(UInt9.max.intValue == _max)
    }
    
    @Test
    func computedProperties() {
        #expect(UInt9(1).intValue == 1)
        #expect(UInt9(1).uInt16Value == 1)
    }
    
    @Test
    func strideable() {
        let min = UInt9(_min)
        let max = UInt9(_max)
        
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
    func equatable() {
        #expect(UInt9(0) == UInt9(0))
        #expect(UInt9(1) == UInt9(1))
        #expect(UInt9(_max) == UInt9(_max))
        
        #expect(UInt9(0) != UInt9(1))
    }
    
    @Test
    func comparable() {
        #expect(!(UInt9(0) > UInt9(0)))
        #expect(!(UInt9(1) > UInt9(1)))
        #expect(!(UInt9(_max) > UInt9(_max)))
        
        #expect(UInt9(0) < UInt9(1))
        #expect(UInt9(1) > UInt9(0))
    }
    
    @Test
    func hashable() {
        let set = Set<UInt9>([0, 1, 1, 2])
        
        #expect(set.count == 3)
        #expect(set == [0, 1, 2])
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt9(_max))
        let decoded = try decoder.decode(UInt9.self, from: encoded)
        
        #expect(decoded == UInt9(_max))
    }
    
    // MARK: - Standard library extensions
    
    @Test
    func binaryInteger_UInt9() {
        #expect(10.toUInt9 == 10)
        
        #expect(Int8(10).toUInt9 == 10)
        #expect(UInt8(10).toUInt9 == 10)
        
        #expect(Int16(10).toUInt9 == 10)
        #expect(UInt16(10).toUInt9 == 10)
    }
    
    @Test
    func binaryInteger_UInt9Exactly() {
        #expect(0b0_00000000.toUInt9Exactly == 0b0_00000000)
        #expect(0b1_11111111.toUInt9Exactly == 0b1_11111111)
        
        #expect(Int8(10).toUInt9Exactly == 10)
        #expect(UInt8(10).toUInt9Exactly == 10)
        
        #expect(Int16(10).toUInt9Exactly == 10)
        #expect(UInt16(10).toUInt9Exactly == 10)
        
        // nil (overflow)
        
        #expect(0b10_00000000.toUInt9Exactly == nil)
    }
    
    @Test
    func binaryInteger_Init_UInt9() {
        #expect(Int(10.toUInt9) == 10)
        #expect(Int(exactly: 10.toUInt9) == 10)
        
        #expect(Int(exactly: 0b1_11111111.toUInt9) == 0b1_11111111)
        #expect(UInt8(exactly: 0b1_11111111.toUInt9) == nil)
    }
    
    // MARK: - Operators
    
    @Test
    func operators() {
        #expect(1.toUInt9 + 1 == 2.toUInt9)
        #expect(1 + 1.toUInt9 == 2.toUInt9)
        #expect(1.toUInt9 + 1.toUInt9 == 2)
        
        #expect(2.toUInt9 - 1 == 1.toUInt9)
        #expect(2 - 1.toUInt9 == 1.toUInt9)
        #expect(2.toUInt9 - 1.toUInt9 == 1)
        
        #expect(2.toUInt9 * 2 == 4.toUInt9)
        #expect(2 * 2.toUInt9 == 4.toUInt9)
        #expect(2.toUInt9 * 2.toUInt9 == 4)
        
        #expect(8.toUInt9 / 2 == 4.toUInt9)
        #expect(8 / 2.toUInt9 == 4.toUInt9)
        #expect(8.toUInt9 / 2.toUInt9 == 4)
        
        #expect(8.toUInt9 % 3 == 2.toUInt9)
        #expect(8 % 3.toUInt9 == 2.toUInt9)
        #expect(8.toUInt9 % 3.toUInt9 == 2)
    }
    
    @Test
    func assignmentOperators() {
        var val = UInt9(2)
        
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
