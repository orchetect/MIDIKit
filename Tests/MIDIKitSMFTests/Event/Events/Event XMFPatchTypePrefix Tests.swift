//
//  Event XMFPatchTypePrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSMF
import XCTest

final class Event_XMFPatchTypePrefix_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x01        // param
        ]
        
        let event = try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.patchSet, .generalMIDI1)
    }
    
    func testMIDI1SMFRawBytes_A() {
        let event = MIDIFileEvent.XMFPatchTypePrefix(patchSet: .generalMIDI1)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x01        // param
        ])
    }
    
    func testInit_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x02        // param
        ]
        
        let event = try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.patchSet, .generalMIDI2)
    }
    
    func testMIDI1SMFRawBytes_B() {
        let event = MIDIFileEvent.XMFPatchTypePrefix(patchSet: .generalMIDI2)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x02       // param
        ])
    }
    
    // MARK: - Edge Cases
    
    func testUndefinedParam() {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x20        // param (undefined)
        ]
        
        XCTAssertThrowsError(
            try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        )
    }
}

#endif
