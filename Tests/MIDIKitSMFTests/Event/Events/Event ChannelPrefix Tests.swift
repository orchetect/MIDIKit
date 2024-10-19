//
//  Event ChannelPrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import XCTest

final class Event_ChannelPrefix_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    func testInit_midi1SMFRawBytes() throws {
        let bytes: [UInt8] = [0xFF, 0x20, 0x01, 0x02]
        
        let event = try MIDIFileEvent.ChannelPrefix(midi1SMFRawBytes: bytes)
        
        XCTAssertEqual(event.channel, 2)
    }
    
    func testMIDI1SMFRawBytes() {
        let event = MIDIFileEvent.ChannelPrefix(channel: 2)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        XCTAssertEqual(bytes, [0xFF, 0x20, 0x01, 0x02])
    }
}
