//
//  UMPWord Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import XCTestExtensions

final class UMPWord_Tests: XCTestCase {
    
    func testInit_Four_Bytes() {
        
        let word = MIDI.UMPWord(0x12, 0x34, 0x56, 0x78)
        
        XCTAssertEqual(word, 0x12345678)
        
    }
    
    func testInit_Two_UInt16() {
        
        let word = MIDI.UMPWord(0x1234, 0x5678)
        
        XCTAssertEqual(word, 0x12345678)
        
    }
    
    func testUMPWordsToBytes_Empty() {
        
        let words: [MIDI.UMPWord] = []
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [])
        
    }
    
    func testUMPWordsToBytes_OneWord() {
        
        let words: [MIDI.UMPWord] = [0x12345678]
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [0x12, 0x34, 0x56, 0x78])
        
    }
    
    func testUMPWordsToBytes_TwoWords() {
        
        let words: [MIDI.UMPWord] = [0x12345678, 0x89ABCDEF]
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [0x12, 0x34, 0x56, 0x78,
                               0x89, 0xAB, 0xCD, 0xEF])
        
    }
    
}

#endif
