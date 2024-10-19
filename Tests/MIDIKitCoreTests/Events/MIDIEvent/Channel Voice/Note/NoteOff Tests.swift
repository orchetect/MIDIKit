//
//  NoteOff Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitCore
import XCTest

final class MIDIEvent_NoteOff_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    typealias NoteOff = MIDIEvent.NoteOff
    
    // MARK: - Standard Note tests
    
    func testMIDI1() {
        for noteNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .noteOff(
                noteNum,
                velocity: .midi1(64),
                attribute: .none,
                channel: 0x1
            )
    
            XCTAssertEqual(
                cc.midi1RawBytes(),
                [0x81, noteNum.uInt8Value, 64]
            )
        }
    }
    
    func testUMP_MIDI1_0() {
        for noteNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .noteOff(
                noteNum,
                velocity: .midi1(64),
                attribute: .none,
                channel: 0x1,
                group: 0x9
            )
    
            XCTAssertEqual(
                cc.umpRawWords(protocol: .midi1_0),
                [[
                    UMPWord(
                        0x29,
                        0x81,
                        noteNum.uInt8Value,
                        64
                    )
                ]]
            )
        }
    }
    
    func testUMP_MIDI2_0() {
        for noteNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .noteOff(
                noteNum,
                velocity: .midi1(64),
                attribute: .none,
                channel: 0x1,
                group: 0x9
            )
    
            XCTAssertEqual(
                cc.umpRawWords(protocol: .midi2_0),
                [[
                    UMPWord(
                        0x49,
                        0x81,
                        noteNum.uInt8Value,
                        0x00
                    ),
                    UMPWord(
                        0x80,
                        0x00,
                        0x00,
                        0x00
                    )
                ]]
            )
        }
    }
    
    func testUMP_MIDI2_0_WithAttribute() {
        for noteNum: UInt7 in 0 ... 127 {
            let cc: MIDIEvent = .noteOff(
                noteNum,
                velocity: .midi1(127),
                attribute: .pitch7_9(
                    coarse: 0b1101100,
                    fine: 0b1_10011110
                ),
                channel: 0x1,
                group: 0x9
            )
    
            XCTAssertEqual(
                cc.umpRawWords(protocol: .midi2_0),
                [[
                    UMPWord(
                        0x49,
                        0x81,
                        noteNum.uInt8Value,
                        0x03
                    ),
                    UMPWord(
                        0xFF,
                        0xFF,
                        0b11011001,
                        0b10011110
                    )
                ]]
            )
        }
    }
}
