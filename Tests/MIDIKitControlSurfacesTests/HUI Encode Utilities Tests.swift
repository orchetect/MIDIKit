//
//  HUI Encode Utilities Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct HUIEncodeUtilitiesTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func ping_toHost() {
        let midiEvent = encodeHUIPing(to: .host)
        
        #expect(
            midiEvent ==
                .noteOn(0, velocity: .midi1(0x7F), channel: 0)
        )
    }
    
    @Test
    func ping_toSurface() {
        let midiEvent = encodeHUIPing(to: .surface)
        
        #expect(
            midiEvent ==
                .noteOn(0, velocity: .midi1(0x00), channel: 0)
        )
    }
    
    @Test
    func switch_ZonePort_toHost() {
        let midiEvents = encodeHUISwitch(zone: 0x08, port: 0x1, state: true, to: .host)
        
        #expect(
            midiEvents ==
                [
                    .cc(0x0F, value: .midi1(0x08), channel: 0),
                    .cc(0x2F, value: .midi1(UInt7(0x1 + 0x40)), channel: 0)
                ]
        )
    }
    
    @Test
    func switch_ZonePort_toSurface() {
        let midiEvents = encodeHUISwitch(zone: 0x08, port: 0x1, state: false, to: .surface)
        
        #expect(
            midiEvents ==
                [
                    .cc(0x0C, value: .midi1(0x08), channel: 0),
                    .cc(0x2C, value: .midi1(UInt7(0x1)), channel: 0)
                ]
        )
    }
    
    @Test
    func switch_toHost() {
        let midiEvents = encodeHUISwitch(.hotKey(.shift), state: true, to: .host)
        
        #expect(
            midiEvents ==
                [
                    .cc(0x0F, value: .midi1(0x08), channel: 0),
                    .cc(0x2F, value: .midi1(UInt7(0x1 + 0x40)), channel: 0)
                ]
        )
    }
    
    @Test
    func switch_toSurface() {
        let midiEvents = encodeHUISwitch(.hotKey(.shift), state: false, to: .surface)
        
        #expect(
            midiEvents ==
                [
                    .cc(0x0C, value: .midi1(0x08), channel: 0),
                    .cc(0x2C, value: .midi1(UInt7(0x1)), channel: 0)
                ]
        )
    }
    
    /// Encoding is identical to host or to surface.
    @Test
    func faderLevel() {
        let midiEvents = encodeHUIFader(level: .midpoint, channel: 2)
        // UInt14 midpoint msb, lsb: 0x40, 0x00
        
        #expect(
            midiEvents ==
                [
                    .cc(2, value: .midi1(0x40), channel: 0),
                    .cc(UInt7(2 + 0x20), value: .midi1(0x00), channel: 0)
                ]
        )
    }
    
    /// Message is only valid being sent to host.
    @Test
    func faderTouched() {
        #expect(
            encodeHUIFader(isTouched: true, channel: 2) ==
                [
                    .cc(0x0F, value: .midi1(2), channel: 0),
                    .cc(0x2F, value: .midi1(UInt7(0x40)), channel: 0)
                ]
        )
        
        #expect(
            encodeHUIFader(isTouched: false, channel: 3) ==
                [
                    .cc(0x0F, value: .midi1(3), channel: 0),
                    .cc(0x2F, value: .midi1(UInt7(0x00)), channel: 0)
                ]
        )
    }
    
    /// Message is only valid being sent to surface.
    @Test
    func levelMeter() {
        #expect(
            encodeHUILevelMeter(channel: 2, side: .left, level: 0) ==
                .notePressure(note: 2, amount: .midi1(0x00), channel: 0)
        )
        
        #expect(
            encodeHUILevelMeter(channel: 3, side: .right, level: 0xB) ==
                .notePressure(note: 3, amount: .midi1(0x1B), channel: 0)
        )
    }
    
    /// Encoding is identical to host or to surface.
    @Test
    func vPot_RawValue() {
        let midiEvent = encodeHUIVPot(rawValue: 3, for: .editAssignA, to: .surface)
        
        #expect(
            midiEvent ==
                .cc(0x18, value: .midi1(3), channel: 0)
        )
    }
    
    /// Message is only valid being sent to surface.
    @Test
    func vPot_Display() {
        let midiEvent = encodeHUIVPot(
            display: .init(leds: .center(to: .L5), lowerLED: false),
            for: .editAssignA
        )
        
        #expect(
            midiEvent ==
                .cc(0x18, value: .midi1(0x11), channel: 0)
        )
    }
    
    /// Message is only valid being sent to host.
    @Test
    func vPot_Delta() {
        #expect(
            encodeHUIVPot(delta: 63, for: .editAssignA) ==
                .cc(0x48, value: .midi1(0b1111111), channel: 0)
        )
        
        #expect(
            encodeHUIVPot(delta: 1, for: .editAssignA) ==
                .cc(0x48, value: .midi1(0b1000001), channel: 0)
        )
        
        #expect(
            encodeHUIVPot(delta: -1, for: .editAssignA) ==
                .cc(0x48, value: .midi1(0b0000001), channel: 0)
        )
        
        #expect(
            encodeHUIVPot(delta: -63, for: .editAssignA) ==
                .cc(0x48, value: .midi1(0b0111111), channel: 0)
        )
    }
    
    /// Message is only valid being sent to surface.
    @Test
    func largeDisplay_OneEntireSlice() throws {
        let midiEvent = encodeHUILargeDisplay(sliceIndex: 1, text: [
            .A, .B, .C, .D, .E,
            .F, .G, .H, .I, .J
        ])
        
        #expect(
            try midiEvent ==
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
    @Test
    func largeDisplay_OneChar() throws {
        let midiEvent = encodeHUILargeDisplay(sliceIndex: 2, text: [
            .A
        ])
        
        #expect(
            try midiEvent ==
                .sysEx7(
                    manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                    data: [
                        0x05, 0x00, // subID1, subID2
                        0x12, // large display ID
                        0x02, // slice index
                        0x41  // A
                    ]
                )
        )
    }
    
    /// Message is only valid being sent to surface.
    @Test
    func largeDisplay_TwoChar2() throws {
        let midiEvent = encodeHUILargeDisplay(sliceIndex: 2, text: [
            .A, .B
        ])
        
        #expect(
            try midiEvent ==
                .sysEx7(
                    manufacturer: .threeByte(byte2: 0x00, byte3: 0x66),
                    data: [
                        0x05, 0x00, // subID1, subID2
                        0x12,       // large display ID
                        0x02,       // slice index
                        0x41, 0x42  // AB
                    ]
                )
        )
    }
    
    /// Message is only valid being sent to surface.
    @Test
    func timeDisplay() throws {
        let midiEvent = encodeHUITimeDisplay(text: .init(lossy: "12345678"))
        
        #expect(
            try midiEvent ==
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
    @Test
    func smallDisplay() throws {
        let midiEvent = encodeHUISmallDisplay(
            for: .selectAssign,
            text: .init(lossy: "1234")
        )
        
        #expect(
            try midiEvent ==
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
