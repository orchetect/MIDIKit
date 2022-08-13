//
//  UMPWord Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class UMPWord_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    func testInit_Four_Bytes() {
        let word = UMPWord(0x12, 0x34, 0x56, 0x78)
        
        XCTAssertEqual(word, 0x1234_5678)
    }
    
    func testInit_Two_UInt16() {
        let word = UMPWord(0x1234, 0x5678)
        
        XCTAssertEqual(word, 0x1234_5678)
    }
    
    func testUMPWordsToBytes_Empty() {
        let words: [UMPWord] = []
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [])
    }
    
    func testUMPWordsToBytes_OneWord() {
        let words: [UMPWord] = [0x1234_5678]
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [0x12, 0x34, 0x56, 0x78])
    }
    
    func testUMPWordsToBytes_TwoWords() {
        let words: [UMPWord] = [0x1234_5678, 0x89AB_CDEF]
        
        let bytes = words.umpWordsToBytes()
        
        XCTAssertEqual(bytes, [0x12, 0x34, 0x56, 0x78,
                               0x89, 0xAB, 0xCD, 0xEF])
    }
}

#endif
