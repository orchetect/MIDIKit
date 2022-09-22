//
//  HUI Encode Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitControlSurfaces

final class HUIEncodeUtilitiesTests: XCTestCase {
    func testPing_toHost() {
        let midiEvent = encodeHUIPing(to: .host)
        
        XCTAssertEqual(
            midiEvent,
            .noteOn(0, velocity: .midi1(0x7F), channel: 0)
        )
    }
    
    func testPing_toSurface() {
        let midiEvent = encodeHUIPing(to: .surface)
        
        XCTAssertEqual(
            midiEvent,
            .noteOn(0, velocity: .midi1(0x00), channel: 0)
        )
    }
    
    func testSwitch_ZonePort_toHost() {
        let midiEvents = encodeHUISwitch(zone: 0x08, port: 0x1, state: true, to: .host)
        
        XCTAssertEqual(
            midiEvents,
            [
                .cc(0x0F, value: .midi1(0x08), channel: 0),
                .cc(0x2F, value: .midi1(UInt7(0x1 + 0x40)), channel: 0)
            ]
        )
    }
    
    func testSwitch_ZonePort_toSurface() {
        let midiEvents = encodeHUISwitch(zone: 0x08, port: 0x1, state: false, to: .surface)
        
        XCTAssertEqual(
            midiEvents,
            [
                .cc(0x0C, value: .midi1(0x08), channel: 0),
                .cc(0x2C, value: .midi1(UInt7(0x1)), channel: 0)
            ]
        )
    }
    
    func testSwitch_toHost() {
        let midiEvents = encodeHUISwitch(.hotKey(.shift), state: true, to: .host)
        
        XCTAssertEqual(
            midiEvents,
            [
                .cc(0x0F, value: .midi1(0x08), channel: 0),
                .cc(0x2F, value: .midi1(UInt7(0x1 + 0x40)), channel: 0)
            ]
        )
    }
    
    func testSwitch_toSurface() {
        let midiEvents = encodeHUISwitch(.hotKey(.shift), state: false, to: .surface)
        
        XCTAssertEqual(
            midiEvents,
            [
                .cc(0x0C, value: .midi1(0x08), channel: 0),
                .cc(0x2C, value: .midi1(UInt7(0x1)), channel: 0)
            ]
        )
    }
    
    /// Encoding is identical to host or to surface.
    func testFaderLevel() {
        let midiEvents = encodeHUIFader(level: .midpoint, channel: 2)
        // UInt14 midpoint msb, lsb: 0x40, 0x00
        
        XCTAssertEqual(
            midiEvents,
            [
                .cc(2, value: .midi1(0x40), channel: 0),
                .cc(UInt7(2 + 0x20), value: .midi1(0x00), channel: 0)
            ]
        )
    }
    
    /// Message is only valid being sent to host.
    func testFaderTouched() {
        XCTAssertEqual(
            encodeHUIFader(isTouched: true, channel: 2),
            [
                .cc(0x0F, value: .midi1(2), channel: 0),
                .cc(0x2F, value: .midi1(UInt7(0x40)), channel: 0)
            ]
        )
        
        XCTAssertEqual(
            encodeHUIFader(isTouched: false, channel: 3),
            [
                .cc(0x0F, value: .midi1(3), channel: 0),
                .cc(0x2F, value: .midi1(UInt7(0x00)), channel: 0)
            ]
        )
    }
    
    /// Message is only valid being sent to surface.
    func testLevelMeter() {
        XCTAssertEqual(
            encodeHUILevelMeter(channel: 2, side: .left, level: 0),
            .notePressure(note: 2, amount: .midi1(0x00), channel: 0)
        )
        
        XCTAssertEqual(
            encodeHUILevelMeter(channel: 3, side: .right, level: 0xB),
            .notePressure(note: 3, amount: .midi1(0x1B), channel: 0)
        )
    }
    
    /// Encoding is identical to host or to surface.
    func testVPotValue() {
        let midiEvent = encodeHUIVPotValue(for: .editAssignA, delta: 3)
        
        XCTAssertEqual(
            midiEvent,
            .cc(0x18, value: .midi1(3), channel: 0)
        )
    }
    
    /// Message is only valid being sent to surface.
    func testLargeDisplay() {
        let midiEvent = encodeHUILargeDisplay(sliceIndex: 1, text: [
            .A, .B, .C, .D, .E,
            .F, .G, .H, .I, .J
        ])
        
        XCTAssertEqual(
            midiEvent,
            .sysEx7(
                manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                data: [
                    0x05, 0x00, // subID1, subID2
                    0x12, // large display ID
                    0x01, // slice index
                    0x41, 0x42, 0x43, 0x44, 0x45, // ABCDE
                    0x46, 0x47, 0x48, 0x49, 0x4A  // FGHIJ
                ]
            )
        )
    }
    
    /// Message is only valid being sent to surface.
    func testTimeDisplay() {
        let midiEvent = encodeHUITimeDisplay(text: .init(lossy: "12345678"))
        
        XCTAssertEqual(
            midiEvent,
            .sysEx7(
                manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                data: [
                    0x05, 0x00, // subID1, subID2
                    0x11, // time display ID
                    0x08, 0x07, 0x06, 0x05, // 8765
                    0x04, 0x03, 0x02, 0x01  // 4321
                ]
            )
        )
    }
    
    /// Message is only valid being sent to surface.
    func testSmallDisplay() {
        let midiEvent = encodeHUISmallDisplay(for: .selectAssign,
                                              text: .init(lossy: "1234"))
        
        XCTAssertEqual(
            midiEvent,
            .sysEx7(
                manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                data: [
                    0x05, 0x00, // subID1, subID2
                    0x10, // small display ID
                    0x08, // Select Assign display ID
                    0x31, 0x32, 0x33, 0x34  // 1234
                ]
            )
        )
    }
}

#endif
