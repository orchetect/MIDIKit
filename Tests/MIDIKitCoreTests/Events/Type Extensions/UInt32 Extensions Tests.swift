//
//  UInt32 Extensions Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import Testing

@Suite struct UInt32Extensions_Tests {
    fileprivate let _min: UInt32      = 0x0000_0000
    fileprivate let _midpoint: UInt32 = 0x8000_0000
    fileprivate let _max: UInt32      = 0xFFFF_FFFF
    
    @Test
    func initBipolarUnitInterval_Float() {
        #expect(UInt32(bipolarUnitInterval: Float(-1.0)) == UInt32(_min))
        #expect(UInt32(bipolarUnitInterval: Float(-0.5)) == UInt32(0x4000_0000))
        #expect(UInt32(bipolarUnitInterval: Float(0.0)) == UInt32(_midpoint))
        #expect(UInt32(bipolarUnitInterval: Float(0.5)) == UInt32(0xBFFF_FFFF))
        #expect(UInt32(bipolarUnitInterval: Float(1.0)) == UInt32(_max))
    }
    
    @Test
    func initBipolarUnitInterval_Double() {
        #expect(UInt32(bipolarUnitInterval: -1.0) == UInt32(_min))
        #expect(UInt32(bipolarUnitInterval: -0.5) == UInt32(0x4000_0000))
        #expect(UInt32(bipolarUnitInterval:  0.0) == UInt32(_midpoint))
        #expect(UInt32(bipolarUnitInterval:  0.5) == UInt32(0xBFFF_FFFF))
        #expect(UInt32(bipolarUnitInterval:  1.0) == UInt32(_max))
    }
    
    @Test
    func bipolarUnitIntervalValue() {
        #expect(UInt32(_min).bipolarUnitIntervalValue == -1.0)
        #expect(UInt32(0x4000_0000).bipolarUnitIntervalValue == -0.5)
        #expect(UInt32(_midpoint).bipolarUnitIntervalValue == 0.0)
        #expect(UInt32(0xBFFF_FFFF).bipolarUnitIntervalValue == 0.5 - 0.00000000023283064365) // , accuracy: 0.000000001)
        #expect(UInt32(_max).bipolarUnitIntervalValue == 1.0)
    }
}
