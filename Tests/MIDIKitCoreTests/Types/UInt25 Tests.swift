//
//  UInt25 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import Testing

@Suite struct UInt25_Tests {
    fileprivate let _min      = 0b0_00000000_00000000_00000000 // int        0, hex 0x0000000
    fileprivate let _midpoint = 0b1_00000000_00000000_00000000 // int 16777216, hex 0x1000000
    fileprivate let _max      = 0b1_11111111_11111111_11111111 // int 33554431, hex 0x1FFFFFF
    
    @Test
    func init_BinaryInteger() {
        // default
        
        #expect(UInt25().intValue == 0)
        
        // different integer types
        
        #expect(UInt25(0).intValue == 0)
        #expect(UInt25(UInt8(0)).intValue == 0)
        #expect(UInt25(UInt16(0)).intValue == 0)
        
        // values
        
        #expect(UInt25(1).intValue == 1)
        #expect(UInt25(2).intValue == 2)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //     _ = UInt25(0 - 1)
        // }
        //
        // _XCTAssertThrows { [self] in
        //     _ = UInt25(_max + 1)
        // }
    }
    
    @Test
    func init_BinaryInteger_Exactly() {
        // typical
        
        #expect(UInt25(exactly: 0)?.intValue == 0)
        
        #expect(UInt25(exactly: 1)?.intValue == 1)
        
        #expect(UInt25(exactly: _max)?.intValue == _max)
        
        // overflow
        
        #expect(UInt25(exactly: -1) == nil)
        
        #expect(UInt25(exactly: _max + 1) == nil)
    }
    
    @Test
    func init_BinaryInteger_Clamping() {
        // within range
        
        #expect(UInt25(clamping: 0).intValue == 0)
        #expect(UInt25(clamping: 1).intValue == 1)
        #expect(UInt25(clamping: _max).intValue == _max)
        
        // overflow
        
        #expect(UInt25(clamping: -1).intValue == 0)
        #expect(UInt25(clamping: _max + 1).intValue == _max)
    }
    
    @Test
    func init_BinaryFloatingPoint() {
        #expect(UInt25(Double(0)).intValue == 0)
        #expect(UInt25(Double(1)).intValue == 1)
        #expect(UInt25(Double(5.9)).intValue == 5)
        
        #expect(UInt25(Float(0)).intValue == 0)
        #expect(UInt25(Float(1)).intValue == 1)
        #expect(UInt25(Float(5.9)).intValue == 5)
        
        // overflow
        
        // TODO: need to find a pure Swift way to test exceptions
        // removed Obj-C helper calls that enabled catching exceptions
        // so that MIDIKit could be pure Swift
        
        // _XCTAssertThrows {
        //     _ = UInt25(Double(0 - 1))
        //     _ = UInt25(Float(0 - 1))
        // }
        
        // _XCTAssertThrows { [self] in
        //     _ = UInt25(Double(_max + 1))
        //     _ = UInt25(Float(_max + 1))
        // }
    }
    
    @Test
    func init_BinaryFloatingPoint_Exactly() {
        // typical
        
        #expect(UInt25(exactly: 0.0) == 0)
        
        #expect(UInt25(exactly: 1.0) == 1)
        
        #expect(UInt25(exactly: Double(_max))?.intValue == _max)
        
        // overflow
        
        #expect(UInt25(exactly: -1.0) == nil)
        
        #expect(UInt25(exactly: Double(_max) + 1.0) == nil)
    }
    
    @Test
    func testMin() {
        #expect(UInt25.min.intValue == 0)
    }
    
    @Test
    func testMax() {
        #expect(UInt25.max.intValue == _max)
    }
    
    @Test
    func computedProperties() {
        #expect(UInt25(1).intValue == 1)
        #expect(UInt25(1).uInt32Value == 1)
    }
    
    @Test
    func strideable() {
        let min = UInt25(_min)
        let max = UInt25(_max)
        
        let strideBy1 = stride(from: min, through: max, by: 1)
        _ = strideBy1
        // skip this, it takes way too long to compute ...
        // #expect(strideBy1.underestimatedCount == _max + 1)
        // #expect(strideBy1.starts(with: [min]))
        // #expect(strideBy1.suffix(1) == [max])
        
        let range = min ... max
        #expect(range.count == _max + 1)
        #expect(range.lowerBound == min)
        #expect(range.upperBound == max)
    }
    
    @Test
    func equatable() {
        #expect(UInt25(0) == UInt25(0))
        #expect(UInt25(1) == UInt25(1))
        #expect(UInt25(_max) == UInt25(_max))
        
        #expect(UInt25(0) != UInt25(1))
    }
    
    @Test
    func comparable() {
        #expect(!(UInt25(0) > UInt25(0)))
        #expect(!(UInt25(1) > UInt25(1)))
        #expect(!(UInt25(_max) > UInt25(_max)))
        
        #expect(UInt25(0) < UInt25(1))
        #expect(UInt25(1) > UInt25(0))
    }
    
    @Test
    func hashable() {
        let set = Set<UInt25>([0, 1, 1, 2])
        
        #expect(set.count == 3)
        #expect(set == [0, 1, 2])
    }
    
    @Test
    func codable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try encoder.encode(UInt25(_max))
        let decoded = try decoder.decode(UInt25.self, from: encoded)
        
        #expect(decoded == UInt25(_max))
    }
    
    // MARK: - Standard library extensions
    
    @Test
    func binaryInteger_UInt25() {
        #expect(10.toUInt25 == 10)
        
        #expect(Int8(10).toUInt25 == 10)
        #expect(UInt8(10).toUInt25 == 10)
        
        #expect(Int16(10).toUInt25 == 10)
        #expect(UInt16(10).toUInt25 == 10)
    }
    
    @Test
    func binaryInteger_UInt25Exactly() {
        #expect(
            0b0_00000000_00000000_00000000.toUInt25Exactly ==
            0b0_00000000_00000000_00000000
        )
        #expect(
            0b1_11111111_11111111_11111111.toUInt25Exactly ==
            0b1_11111111_11111111_11111111
        )
        
        #expect(Int8(10).toUInt25Exactly == 10)
        #expect(UInt8(10).toUInt25Exactly == 10)
        
        #expect(Int16(10).toUInt25Exactly == 10)
        #expect(UInt16(10).toUInt25Exactly == 10)
        
        // nil (overflow)
        
        #expect(0b10_00000000_00000000_00000000.toUInt25Exactly == nil)
    }
    
    @Test
    func binaryInteger_Init_UInt25() {
        #expect(Int(10.toUInt25) == 10)
        #expect(Int(exactly: 10.toUInt25) == 10)
        
        #expect(
            Int(exactly: 0b1_11111111_11111111_11111111.toUInt25) ==
            0b1_11111111_11111111_11111111
        )
        #expect(UInt8(exactly: 0b1_11111111.toUInt25) == nil)
    }
    
    // MARK: - Operators
    
    @Test
    func operators() {
        #expect(1.toUInt25 + 1 == 2.toUInt25)
        #expect(1 + 1.toUInt25 == 2.toUInt25)
        #expect(1.toUInt25 + 1.toUInt25 == 2)
        
        #expect(2.toUInt25 - 1 == 1.toUInt25)
        #expect(2 - 1.toUInt25 == 1.toUInt25)
        #expect(2.toUInt25 - 1.toUInt25 == 1)
        
        #expect(2.toUInt25 * 2 == 4.toUInt25)
        #expect(2 * 2.toUInt25 == 4.toUInt25)
        #expect(2.toUInt25 * 2.toUInt25 == 4)
        
        #expect(8.toUInt25 / 2 == 4.toUInt25)
        #expect(8 / 2.toUInt25 == 4.toUInt25)
        #expect(8.toUInt25 / 2.toUInt25 == 4)
        
        #expect(8.toUInt25 % 3 == 2.toUInt25)
        #expect(8 % 3.toUInt25 == 2.toUInt25)
        #expect(8.toUInt25 % 3.toUInt25 == 2)
    }
    
    @Test
    func assignmentOperators() {
        var val = UInt25(2)
        
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
