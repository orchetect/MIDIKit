//
//  Note Off Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class MIDIEventNoteOff_Tests: XCTestCase {
    
    typealias NoteOff = MIDI.Event.Note.Off
    
    // MARK: - Standard Note tests
    
    func testMIDI1() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOff(noteNum,
                                          velocity: .midi1(64),
                                          attribute: .none,
                                          channel: 0x1)
            
            XCTAssertEqual(cc.midi1RawBytes(),
                           [0x81, noteNum.uInt8Value, 64])
            
        }
        
    }
    
    func testUMP_MIDI1_0() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOff(noteNum,
                                          velocity: .midi1(64),
                                          attribute: .none,
                                          channel: 0x1,
                                          group: 0x9)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._1_0),
                           [[
                            MIDI.UMPWord(0x29,
                                         0x81,
                                         noteNum.uInt8Value,
                                         64)
                           ]])
            
        }
        
    }
    
    func testUMP_MIDI2_0() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOff(noteNum,
                                          velocity: .midi1(64),
                                          attribute: .none,
                                          channel: 0x1,
                                          group: 0x9)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x49,
                                         0x81,
                                         noteNum.uInt8Value,
                                         0x00),
                            MIDI.UMPWord(0x80, 0x00,
                                         0x00, 0x00)
                           ]])
            
        }
        
    }
    
    func testUMP_MIDI2_0_WithAttribute() {
        
        for noteNum: MIDI.UInt7 in 0...127 {
            
            let cc: MIDI.Event = .noteOff(noteNum,
                                          velocity: .midi1(127),
                                          attribute: .pitch7_9(coarse: 0b110_1100,
                                                               fine: 0b1_1001_1110),
                                          channel: 0x1,
                                          group: 0x9)
            
            XCTAssertEqual(cc.umpRawWords(protocol: ._2_0),
                           [[
                            MIDI.UMPWord(0x49,
                                         0x81,
                                         noteNum.uInt8Value,
                                         0x03),
                            MIDI.UMPWord(0xFF, 0xFF,
                                         0b110_1100_1, 0b1001_1110)
                           ]])
            
        }
    
    }
    
}

#endif
