//
//  UInt4 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct UInt4_Tests {
    private let _min      = 0b0000 // int  0, hex 0x0
    private let _midpoint = 0b1000 // int  8, hex 0x8
    private let _max      = 0b1111 // int 15, hex 0xF
    
    @Test
    func init_BinaryInteger() {
        // default
        
        #expect(UInt4().intValue == 0)
        
        // different integer types
        
        #expect(UInt4(0).intValue == 0)
        #expect(UInt4(UInt8(0)).intValue == 0)
        #expect(UInt4(UInt16(0)).intValue == 0)
        
        // values
        
        #expect(UInt4(1).intValue == 1)
        #expect(UInt4(2).intValue == 2)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows { [self] in
        //     _ = UInt4(_min - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt4(_max + 1)
        // }
    }
    
    @Test
    func init_BinaryInteger_Exactly() {
        // typical
        
        #expect(UInt4(exactly: 0)?.intValue == 0)
        
        #expect(UInt4(exactly: 1)?.intValue == 1)
        
        #expect(UInt4(exactly: _max)?.intValue == _max)
        
        // overflow
        
        #expect(UInt4(exactly: -1) == nil)
        
        #expect(UInt4(exactly: _max + 1) == nil)
    }
    
    @Test
    func initBinaryInteger_Clamping() {
        // within range
        
        #expect(UInt4(clamping: 0).intValue == 0)
        #expect(UInt4(clamping: 1).intValue == 1)
        #expect(UInt4(clamping: _max).intValue == _max)
        
        // overflow
        
        #expect(UInt4(clamping: -1).intValue == 0)
        #expect(UInt4(clamping: _max + 1).intValue == _max)
    }
    
    @Test
    func init_BinaryFloatingPoint() {
        #expect(UInt4(Double(0)).intValue == 0)
        #expect(UInt4(Double(1)).intValue == 1)
        #expect(UInt4(Double(5.9)).intValue == 5)
        
        #expect(UInt4(Float(0)).intValue == 0)
        #expect(UInt4(Float(1)).intValue == 1)
        #expect(UInt4(Float(5.9)).intValue == 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //     _ = UInt4(Double(0 - 1))
        //     _ = UInt4(Float(0 - 1))
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt4(Double(_max + 1))
        //     _ = UInt4(Float(_max + 1))
        // }
    }
    
    @Test
    func init_BinaryFloatingPoint_Exactly() {
        // typical
        
        #expect(UInt4(exactly: 0.0) == 0)
        
        #expect(UInt4(exactly: 1.0) == 1)
        
        #expect(UInt4(exactly: Double(_max))?.intValue == _max)
        
        // overflow
        
        #expect(UInt4(exactly: -1.0) == nil)
        
        #expect(UInt4(exactly: Double(_max) + 1.0) == nil)
    }
    
    @Test
    func testMin() {
        #expect(UInt4.min.intValue == _min)
    }
    
    @Test
    func testMax() {
        #expect(UInt4.max.intValue == _max)
    }
    
    @Test
    func computedProperties() {
        #expect(UInt4(1).intValue == 1)
        #expect(UInt4(1).uInt8Value == 1)
    }
    
    @Test
    func strideable() {
        let min = UInt4(_min)
        let max = UInt4(_max)
        
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
        #expect(UInt4(0) == UInt4(0))
        #expect(UInt4(1) == UInt4(1))
        #expect(UInt4(_max) == UInt4(_max))
        
        #expect(UInt4(0) != UInt4(1))
    }
    
    @Test
    func comparable() {
        #expect(!(UInt4(0) > UInt4(0)))
        #expect(!(UInt4(1) > UInt4(1)))
        #expect(!(UInt4(_max) > UInt4(_max)))
        
        #expect(UInt4(0) < UInt4(1))
        #expect(UInt4(1) > UInt4(0))
    }
    
    @Test
    func hashable() {
        let set = Set<UInt4>([0, 1, 1, 2])
        
        #expect(set.count == 3)
        #expect(set == [0, 1, 2])
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt4(_max))
        let decoded = try decoder.decode(UInt4.self, from: encoded)
        
        #expect(decoded == UInt4(_max))
    }
    
    // MARK: - Standard library extensions
    
    @Test
    func binaryInteger_UInt4() {
        #expect(10.toUInt4 == 10)
        
        #expect(Int8(10).toUInt4 == 10)
        #expect(UInt8(10).toUInt4 == 10)
        
        #expect(Int16(10).toUInt4 == 10)
        #expect(UInt16(10).toUInt4 == 10)
    }
    
    @Test
    func binaryInteger_UInt4Exactly() {
        #expect(0b0000.toUInt4Exactly == 0b0000)
        #expect(0b1111.toUInt4Exactly == 0b1111)
        
        #expect(Int8(10).toUInt4Exactly == 10)
        #expect(UInt8(10).toUInt4Exactly == 10)
        
        #expect(Int16(10).toUInt4Exactly == 10)
        #expect(UInt16(10).toUInt4Exactly == 10)
        
        // nil (overflow)
        
        #expect(0b10000.toUInt4Exactly == nil)
    }
    
    @Test
    func binaryInteger_Init_UInt4() {
        #expect(Int(10.toUInt4) == 10)
        #expect(Int(exactly: 10.toUInt4) == 10)
        
        // no BinaryInteger-conforming type in the Swift standard library
        // is smaller than 8 bits, so we can't really test .init(exactly:)
        // producing nil because it always succeeds (?)
        #expect(Int(exactly: 0b1111.toUInt4) == 0b1111)
    }
    
    // MARK: - Operators
    
    @Test
    func operators() {
        #expect(1.toUInt4 + 1 == 2.toUInt4)
        #expect(1 + 1.toUInt4 == 2.toUInt4)
        #expect(1.toUInt4 + 1.toUInt4 == 2)
        
        #expect(2.toUInt4 - 1 == 1.toUInt4)
        #expect(2 - 1.toUInt4 == 1.toUInt4)
        #expect(2.toUInt4 - 1.toUInt4 == 1)
        
        #expect(2.toUInt4 * 2 == 4.toUInt4)
        #expect(2 * 2.toUInt4 == 4.toUInt4)
        #expect(2.toUInt4 * 2.toUInt4 == 4)
        
        #expect(8.toUInt4 / 2 == 4.toUInt4)
        #expect(8 / 2.toUInt4 == 4.toUInt4)
        #expect(8.toUInt4 / 2.toUInt4 == 4)
        
        #expect(8.toUInt4 % 3 == 2.toUInt4)
        #expect(8 % 3.toUInt4 == 2.toUInt4)
        #expect(8.toUInt4 % 3.toUInt4 == 2)
    }
    
    @Test
    func assignmentOperators() {
        var val = UInt4(2)
        
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
