//
//  Note Attribute Pitch7_9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit

final class NoteAttribute_Pitch7_9_Tests: XCTestCase {
    typealias Pitch7_9 = MIDIEvent.Note.Attribute.Pitch7_9
    
    func testInit() {
        XCTAssertEqual(Pitch7_9(coarse:   0, fine:   0).coarse, 0)
        XCTAssertEqual(Pitch7_9(coarse:   0, fine:   0).fine,   0)
        
        XCTAssertEqual(Pitch7_9(coarse: 127, fine: 511).coarse, 127)
        XCTAssertEqual(Pitch7_9(coarse: 127, fine: 511).fine,   511)
    }
    
    // MARK: - BytePair
    
    func testInit_BytePair() {
        let pitchA = Pitch7_9(BytePair(msb: 0b0000_0000, lsb: 0b0000_0000))
        XCTAssertEqual(pitchA.coarse, 0)
        XCTAssertEqual(pitchA.fine, 0)
        
        let pitchB = Pitch7_9(BytePair(msb: 0b0000_0010, lsb: 0b0000_0001))
        XCTAssertEqual(pitchB.coarse, 1)
        XCTAssertEqual(pitchB.fine, 1)
        
        let pitchC = Pitch7_9(BytePair(msb: 0b1111_1111, lsb: 0b1111_1111))
        XCTAssertEqual(pitchC.coarse, 127)
        XCTAssertEqual(pitchC.fine, 511)
    }
    
    func testBytePair() {
        XCTAssertEqual(
            Pitch7_9(coarse: 0, fine: 0).bytePair,
            .init(msb: 0b0000_0000, lsb: 0b0000_0000)
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 1, fine: 1).bytePair,
            .init(msb: 0b0000_0010, lsb: 0b0000_0001)
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 511).bytePair,
            .init(msb: 0b1111_1111, lsb: 0b1111_1111)
        )
    }
    
    // MARK: - UInt16
    
    func testInit_UInt16() {
        let pitchA = Pitch7_9(UInt16(0b0000_0000_0000_0000))
        XCTAssertEqual(pitchA.coarse, 0)
        XCTAssertEqual(pitchA.fine, 0)
        
        let pitchB = Pitch7_9(UInt16(0b0000_0010_0000_0001))
        XCTAssertEqual(pitchB.coarse, 1)
        XCTAssertEqual(pitchB.fine, 1)
        
        let pitchC = Pitch7_9(UInt16(0b1111_1111_1111_1111))
        XCTAssertEqual(pitchC.coarse, 127)
        XCTAssertEqual(pitchC.fine, 511)
    }
    
    func testUInt16() {
        XCTAssertEqual(
            Pitch7_9(coarse:   0, fine:   0).uInt16Value,
            0b0000_0000_0000_0000
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse:   1, fine:   1).uInt16Value,
            0b0000_0010_0000_0001
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 511).uInt16Value,
            0b1111_1111_1111_1111
        )
    }
    
    // MARK: - Double
    
    func testInit_Double() {
        XCTAssertEqual(Pitch7_9(-1.5).coarse, 0)
        XCTAssertEqual(Pitch7_9(-1.5).fine, 0)
        
        XCTAssertEqual(Pitch7_9(0.0).coarse, 0)
        XCTAssertEqual(Pitch7_9(0.0).fine, 0)
        
        XCTAssertEqual(Pitch7_9(1.5).coarse, 1)
        XCTAssertEqual(Pitch7_9(1.5).fine, 256)
        
        XCTAssertEqual(Pitch7_9(127.0).coarse, 127)
        XCTAssertEqual(Pitch7_9(127.0).fine, 0)
        
        XCTAssertEqual(Pitch7_9(127.999999999999999999).coarse, 127)
        XCTAssertEqual(Pitch7_9(127.999999999999999999).fine, 511)
        
        XCTAssertEqual(Pitch7_9(128.0).coarse, 127)
        XCTAssertEqual(Pitch7_9(128.0).fine, 511)
    }
    
    func testDouble() {
        XCTAssertEqual(
            Pitch7_9(coarse: 0, fine: 0).doubleValue,
            0.0
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 1, fine: 256).doubleValue,
            1.5
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 0).doubleValue,
            127.0
        )
        
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 511).doubleValue,
            127.998046875
        )
    }
}

#endif
