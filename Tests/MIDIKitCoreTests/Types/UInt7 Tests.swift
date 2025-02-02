//
//  UInt7 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct UInt7_Tests {
    private let _min      = 0b0000000 // int   0, hex 0x00
    private let _midpoint = 0b1000000 // int  64, hex 0x40
    private let _max      = 0b1111111 // int 127, hex 0x7F
    
    @Test
    func init_BinaryInteger() {
        // default
        
        #expect(UInt7().intValue == 0)
        
        // different integer types
        
        #expect(UInt7(0).intValue == 0)
        #expect(UInt7(UInt8(0)).intValue == 0)
        #expect(UInt7(UInt16(0)).intValue == 0)
        
        // values
        
        #expect(UInt7(1).intValue == 1)
        #expect(UInt7(2).intValue == 2)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows { [self] in
        //     _ = UInt7(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt7(_max + 1)
        // }
    }
    
    @Test
    func init_BinaryInteger_Exactly() {
        // typical
        
        #expect(UInt7(exactly: 0)?.intValue == 0)
        
        #expect(UInt7(exactly: 1)?.intValue == 1)
        
        #expect(UInt7(exactly: _max)?.intValue == _max)
        
        // overflow
        
        #expect(UInt7(exactly: -1) == nil)
        
        #expect(UInt7(exactly: _max + 1) == nil)
    }
    
    @Test
    func init_BinaryInteger_Clamping() {
        // within range
        
        #expect(UInt7(clamping: 0).intValue == 0)
        #expect(UInt7(clamping: 1).intValue == 1)
        #expect(UInt7(clamping: _max).intValue == _max)
        
        // overflow
        
        #expect(UInt7(clamping: -1).intValue == 0)
        #expect(UInt7(clamping: _max + 1).intValue == _max)
    }
    
    @Test
    func init_BinaryFloatingPoint() {
        #expect(UInt7(Double(0)).intValue == 0)
        #expect(UInt7(Double(1)).intValue == 1)
        #expect(UInt7(Double(5.9)).intValue == 5)
        
        #expect(UInt7(Float(0)).intValue == 0)
        #expect(UInt7(Float(1)).intValue == 1)
        #expect(UInt7(Float(5.9)).intValue == 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //     _ = UInt7(Double(0 - 1))
        //     _ = UInt7(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt7(Double(_max + 1))
        //     _ = UInt7(Float(_max + 1))
        // }
    }
    
    @Test
    func init_BinaryFloatingPoint_Exactly() {
        // typical
        
        #expect(UInt7(exactly: 0.0) == 0)
        
        #expect(UInt7(exactly: 1.0) == 1)
        
        #expect(UInt7(exactly: Double(_max))?.intValue == _max)
        
        // overflow
        
        #expect(UInt7(exactly: -1.0) == nil)
        
        #expect(UInt7(exactly: Double(_max) + 1.0) == nil)
    }
    
    @Test
    func testMin() {
        #expect(UInt7.min.intValue == _min)
    }
    
    @Test
    func testMax() {
        #expect(UInt7.max.intValue == _max)
    }
    
    @Test
    func computedProperties() {
        #expect(UInt7(1).intValue == 1)
        #expect(UInt7(1).uInt8Value == 1)
    }
    
    @Test
    func strideable() {
        let min = UInt7(_min)
        let max = UInt7(_max)
        
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
        #expect(UInt7(0) == UInt7(0))
        #expect(UInt7(1) == UInt7(1))
        #expect(UInt7(_max) == UInt7(_max))
        
        #expect(UInt7(0) != UInt7(1))
    }
    
    @Test
    func comparable() {
        #expect(!(UInt7(0) > UInt7(0)))
        #expect(!(UInt7(1) > UInt7(1)))
        #expect(!(UInt7(_max) > UInt7(_max)))
        
        #expect(UInt7(0) < UInt7(1))
        #expect(UInt7(1) > UInt7(0))
    }
    
    @Test
    func hashable() {
        let set = Set<UInt7>([0, 1, 1, 2])
        
        #expect(set.count == 3)
        #expect(set == [0, 1, 2])
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt7(_max))
        let decoded = try decoder.decode(UInt7.self, from: encoded)
        
        #expect(decoded == UInt7(_max))
    }
    
    // MARK: - Standard library extensions
    
    @Test
    func binaryInteger_UInt7() {
        #expect(10.toUInt7 == 10)
        
        #expect(Int8(10).toUInt7 == 10)
        #expect(UInt8(10).toUInt7 == 10)
        
        #expect(Int16(10).toUInt7 == 10)
        #expect(UInt16(10).toUInt7 == 10)
    }
    
    @Test
    func binaryInteger_UInt7Exactly() {
        #expect(0b0000000.toUInt7Exactly == 0b0000000)
        #expect(0b1111111.toUInt7Exactly == 0b1111111)
        
        #expect(Int8(10).toUInt7Exactly == 10)
        #expect(UInt8(10).toUInt7Exactly == 10)
        
        #expect(Int16(10).toUInt7Exactly == 10)
        #expect(UInt16(10).toUInt7Exactly == 10)
        
        // nil (overflow)
        
        #expect(0b10000000.toUInt7Exactly == nil)
    }
    
    @Test
    func binaryInteger_Init_UInt7() {
        #expect(Int(10.toUInt7) == 10)
        #expect(Int(exactly: 10.toUInt7) == 10)
        
        // no BinaryInteger-conforming type in the Swift standard library
        // is smaller than 8 bits, so we can't really test .init(exactly:)
        // producing nil because it always succeeds (?)
        #expect(Int(exactly: 0b1111111.toUInt7) == 0b1111111)
    }
    
    // MARK: - Operators
    
    @Test
    func operators() {
        #expect(1.toUInt7 + 1 == 2.toUInt7)
        #expect(1 + 1.toUInt7 == 2.toUInt7)
        #expect(1.toUInt7 + 1.toUInt7 == 2)
        
        #expect(2.toUInt7 - 1 == 1.toUInt7)
        #expect(2 - 1.toUInt7 == 1.toUInt7)
        #expect(2.toUInt7 - 1.toUInt7 == 1)
        
        #expect(2.toUInt7 * 2 == 4.toUInt7)
        #expect(2 * 2.toUInt7 == 4.toUInt7)
        #expect(2.toUInt7 * 2.toUInt7 == 4)
        
        #expect(8.toUInt7 / 2 == 4.toUInt7)
        #expect(8 / 2.toUInt7 == 4.toUInt7)
        #expect(8.toUInt7 / 2.toUInt7 == 4)
        
        #expect(8.toUInt7 % 3 == 2.toUInt7)
        #expect(8 % 3.toUInt7 == 2.toUInt7)
        #expect(8.toUInt7 % 3.toUInt7 == 2)
    }
    
    @Test
    func assignmentOperators() {
        var val = UInt7(2)
        
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
