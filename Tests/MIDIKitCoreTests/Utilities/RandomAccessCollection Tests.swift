//
//  RandomAccessCollection Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitInternals

class Utilities_RandomAccessCollectionTests: XCTestCase {
    func testRangeOfOffsets() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        XCTAssertEqual(sourceArray.range(ofOffsets: 0 ... 5), 0 ... 5)
        
        let subArray = sourceArray[2 ... 7]
        XCTAssertEqual(subArray.range(ofOffsets: 0 ... 5), 2 ... 7)
        
        let subSubArray = subArray[3 ... 5]
        XCTAssertEqual(subSubArray.range(ofOffsets: 0 ... 2), 3 ... 5)
    }
    
    func testSubscriptAtOffsets() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[2 ... 7]
        
        // standard behavior
        XCTAssertEqual(subArray[2], 2)
        
        // atOffsets
        XCTAssertEqual(subArray[atOffsets: 0 ... 5], [2, 3, 4, 5, 6, 7])
    }
    
    func testSubscriptAtOffsets_IdenticalIndices() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        var subArray = sourceArray[atOffsets: 0 ... 9]
        XCTAssert(subArray.elementsEqual(sourceArray))
        
        subArray = subArray[0 ... 9]
        XCTAssert(subArray.elementsEqual(sourceArray))
    }
    
    func testSubscriptAtOffsets_SingleIndexRange() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[atOffsets: 2 ... 2]
        XCTAssertEqual(subArray, [2])
    }
    
    func testSubscriptAtOffset() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        let subArray = sourceArray[2 ... 7]
        
        // standard behavior
        XCTAssertEqual(subArray[2], 2)
        
        // atOffset
        XCTAssertEqual(subArray[atOffset: 0], 2)
        XCTAssertEqual(subArray[atOffset: 5], 7)
    }
    
    func testSubscriptAtOffsetEdgeCases() {
        let sourceArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        XCTAssertEqual(sourceArray[atOffset: 0], 0)
        
        let subArray = sourceArray[0 ... 9]
        XCTAssertEqual(subArray[atOffset: 0], 0)
    }
}

#endif
