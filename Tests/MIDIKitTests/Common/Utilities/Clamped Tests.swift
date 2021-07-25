//
//  Clamped Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//



/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------
/// Borrowed from [OTCore 1.1.8](https://github.com/orchetect/OTCore) under MIT license.
/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------



#if !os(watchOS)

import XCTest
@testable import MIDIKit

class Utilities_ClampedTests: XCTestCase {
    
    func testNumberClampedToRanges() {
        
        // .clamped(ClosedRange)
        
        XCTAssertEqual(    5.clamped(to: 7...10),         7  )
        XCTAssertEqual(    8.clamped(to: 7...10),         8  )
        XCTAssertEqual(   20.clamped(to: 7...10),        10  )
        
        XCTAssertEqual(  5.0.clamped(to: 7.0...10.0),     7.0)
        XCTAssertEqual(  8.0.clamped(to: 7.0...10.0),     8.0)
        XCTAssertEqual( 20.0.clamped(to: 7.0...10.0),    10.0)
        
        XCTAssertEqual(  "a".clamped(to: "b"..."h"),    "b"  )
        XCTAssertEqual(  "c".clamped(to: "b"..."h"),    "c"  )
        XCTAssertEqual(  "k".clamped(to: "b"..."h"),    "h"  )
        
        // .clamped(Range)
        
        XCTAssertEqual(    5.clamped(to: 7..<10),         7  )
        XCTAssertEqual(    8.clamped(to: 7..<10),         8  )
        XCTAssertEqual(   20.clamped(to: 7..<10),         9  )
        
        // .clamped(PartialRangeFrom)
        
        XCTAssertEqual(    5.clamped(to: 300...),       300  )
        XCTAssertEqual(  400.clamped(to: 300...),       400  )
        
        XCTAssertEqual(  5.0.clamped(to: 300.00...),    300.0)
        XCTAssertEqual(400.0.clamped(to: 300.00...),    400.0)
        
        XCTAssertEqual(  "a".clamped(to: "b"...),       "b"  )
        XCTAssertEqual(  "g".clamped(to: "b"...),       "g"  )
        
        // .clamped(PartialRangeThrough)
        
        XCTAssertEqual(200  .clamped(to: ...300),       200  )
        XCTAssertEqual(400  .clamped(to: ...300),       300  )
        
        XCTAssertEqual(200.0.clamped(to: ...300.0),     200.0)
        XCTAssertEqual(400.0.clamped(to: ...300.0),     300.0)
        
        XCTAssertEqual(  "a".clamped(to: ..."h"),       "a"  )
        XCTAssertEqual(  "k".clamped(to: ..."h"),       "h"  )
        
        // .clamped(PartialRangeUpTo)
        
        XCTAssertEqual(200  .clamped(to: ..<300),       200  )
        XCTAssertEqual(400  .clamped(to: ..<300),       299  )
        
    }
    
}
#endif
