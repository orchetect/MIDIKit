//
//  Timing Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class TimeBase_Tests: XCTestCase {
    func testInitMusical() {
        let timeBase = MIDIFile.TimeBase.musical(ticksPerQuarterNote: 480)
        
        let rawData: [Byte] = [0x01, 0xE0]
        
        XCTAssertEqual(timeBase.rawData.bytes, rawData)
        
        do {
            guard case let .musical(tpq) = MIDIFile
                .TimeBase(rawBytes: rawData)
            else { XCTFail(); return }
            
            XCTAssertEqual(tpq, 480)
        }
        
        do {
            guard case let .musical(tpq) = MIDIFile
                .TimeBase(rawData: rawData.data)
            else { XCTFail(); return }
            
            XCTAssertEqual(tpq, 480)
        }
    }
    
    func testInitTimecode() {
        let timeBase = MIDIFile.TimeBase.timecode(smpteFormat: ._25fps, ticksPerFrame: 80)
        
        let rawData: [Byte] = [0b11100111, 0x50]
        
        XCTAssertEqual(timeBase.rawData.bytes, rawData)
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.TimeBase(rawBytes: rawData)
            else { XCTFail(); return }
            
            XCTAssertEqual(smpteFormat, ._25fps)
            XCTAssertEqual(ticksPerFrame, 80)
        }
        
        do {
            guard case let .timecode(
                smpteFormat,
                ticksPerFrame
            ) = MIDIFile.TimeBase(rawData: rawData.data)
            else { XCTFail(); return }
            
            XCTAssertEqual(smpteFormat, ._25fps)
            XCTAssertEqual(ticksPerFrame, 80)
        }
    }
}

#endif
