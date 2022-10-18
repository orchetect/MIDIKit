//
//  NoteAttribute Pitch7_9 Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKitCore

final class MIDIEvent_NoteAttribute_Pitch7_9_Tests: XCTestCase {
    typealias Pitch7_9 = MIDIEvent.NoteAttribute.Pitch7_9
    
    func testInit() {
        XCTAssertEqual(Pitch7_9(coarse:   0, fine:   0).coarse, 0)
        XCTAssertEqual(Pitch7_9(coarse:   0, fine:   0).fine,   0)
    
        XCTAssertEqual(Pitch7_9(coarse: 127, fine: 511).coarse, 127)
        XCTAssertEqual(Pitch7_9(coarse: 127, fine: 511).fine,   511)
    }
    
    // MARK: - BytePair
    
    func testInit_BytePair() {
        let pitchA = Pitch7_9(BytePair(msb: 0b00000000, lsb: 0b00000000))
        XCTAssertEqual(pitchA.coarse, 0)
        XCTAssertEqual(pitchA.fine, 0)
    
        let pitchB = Pitch7_9(BytePair(msb: 0b00000010, lsb: 0b00000001))
        XCTAssertEqual(pitchB.coarse, 1)
        XCTAssertEqual(pitchB.fine, 1)
    
        let pitchC = Pitch7_9(BytePair(msb: 0b11111111, lsb: 0b11111111))
        XCTAssertEqual(pitchC.coarse, 127)
        XCTAssertEqual(pitchC.fine, 511)
    }
    
    func testBytePair() {
        XCTAssertEqual(
            Pitch7_9(coarse: 0, fine: 0).bytePair,
            .init(msb: 0b00000000, lsb: 0b00000000)
        )
    
        XCTAssertEqual(
            Pitch7_9(coarse: 1, fine: 1).bytePair,
            .init(msb: 0b00000010, lsb: 0b00000001)
        )
    
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 511).bytePair,
            .init(msb: 0b11111111, lsb: 0b11111111)
        )
    }
    
    // MARK: - UInt16
    
    func testInit_UInt16() {
        let pitchA = Pitch7_9(UInt16(0b00000000_00000000))
        XCTAssertEqual(pitchA.coarse, 0)
        XCTAssertEqual(pitchA.fine, 0)
    
        let pitchB = Pitch7_9(UInt16(0b00000010_00000001))
        XCTAssertEqual(pitchB.coarse, 1)
        XCTAssertEqual(pitchB.fine, 1)
    
        let pitchC = Pitch7_9(UInt16(0b11111111_11111111))
        XCTAssertEqual(pitchC.coarse, 127)
        XCTAssertEqual(pitchC.fine, 511)
    }
    
    func testUInt16() {
        XCTAssertEqual(
            Pitch7_9(coarse:   0, fine:   0).uInt16Value,
            0b00000000_00000000
        )
    
        XCTAssertEqual(
            Pitch7_9(coarse:   1, fine:   1).uInt16Value,
            0b00000010_00000001
        )
    
        XCTAssertEqual(
            Pitch7_9(coarse: 127, fine: 511).uInt16Value,
            0b11111111_11111111
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
