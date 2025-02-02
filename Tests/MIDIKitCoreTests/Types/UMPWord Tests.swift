//
//  UMPWord Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitCore
import Testing

@Suite struct UMPWord_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    @Test
    func init_Four_Bytes() {
        let word = UMPWord(0x12, 0x34, 0x56, 0x78)
        
        #expect(word == 0x1234_5678)
    }
    
    @Test
    func init_Two_UInt16() {
        let word = UMPWord(0x1234, 0x5678)
        
        #expect(word == 0x1234_5678)
    }
    
    @Test
    func umpWordsToBytes_Empty() {
        let words: [UMPWord] = []
        
        let bytes = words.umpWordsToBytes()
        
        #expect(bytes == [])
    }
    
    @Test
    func umpWordsToBytes_OneWord() {
        let words: [UMPWord] = [0x1234_5678]
        
        let bytes = words.umpWordsToBytes()
        
        #expect(bytes == [0x12, 0x34, 0x56, 0x78])
    }
    
    @Test
    func umpWordsToBytes_TwoWords() {
        let words: [UMPWord] = [0x1234_5678, 0x89AB_CDEF]
        
        let bytes = words.umpWordsToBytes()
        
        #expect(bytes == [0x12, 0x34, 0x56, 0x78,
                          0x89, 0xAB, 0xCD, 0xEF])
    }
}
