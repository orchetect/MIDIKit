//
//  RandomAccessCollection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitInternals
import Testing

@Suite struct Utilities_RandomAccessCollectionTests {
    @Test
    func rangeOfOffsets() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        #expect(sourceArray.range(ofOffsets: 0 ... 5) == 0 ... 5)
        
        let subArray = sourceArray[2 ... 7]
        #expect(subArray.range(ofOffsets: 0 ... 5) == 2 ... 7)
        
        let subSubArray = subArray[3 ... 5]
        #expect(subSubArray.range(ofOffsets: 0 ... 2) == 3 ... 5)
    }
    
    @Test
    func subscriptAtOffsets() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[2 ... 7]
        
        // standard behavior
        #expect(subArray[2] == 2)
        
        // atOffsets
        #expect(subArray[atOffsets: 0 ... 5] == [2, 3, 4, 5, 6, 7])
    }
    
    @Test
    func subscriptAtOffsets_IdenticalIndices() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        var subArray = sourceArray[atOffsets: 0 ... 9]
        #expect(subArray.elementsEqual(sourceArray))
        
        subArray = subArray[0 ... 9]
        #expect(subArray.elementsEqual(sourceArray))
    }
    
    @Test
    func subscriptAtOffsets_SingleIndexRange() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[atOffsets: 2 ... 2]
        #expect(subArray == [2])
    }
    
    @Test
    func subscriptAtOffset() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[2 ... 7]
        
        // standard behavior
        #expect(subArray[2] == 2)
        
        // atOffset
        #expect(subArray[atOffset: 0] == 2)
        #expect(subArray[atOffset: 5] == 7)
    }
    
    @Test
    func subscriptAtOffsetEdgeCases() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        #expect(sourceArray[atOffset: 0] == 0)
        
        let subArray = sourceArray[0 ... 9]
        #expect(subArray[atOffset: 0] == 0)
    }
}
