//
//  Event CC Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_CC_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() async throws {
        let bytes: [UInt8] = [0xB0, 0x01, 0x40]
        
        let event = try MIDIFileTrackEvent.CC(midi1SMFRawBytes: bytes)
        
        #expect(event.controller == .modWheel) // CC 1
        #expect(event.value == .midi1(0x40))
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1SMFRawBytes_A() async {
        let event = MIDIFileTrackEvent.CC(
            controller: .modWheel,
            value: .midi1(0x40),
            channel: 0
        )
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xB0, 0x01, 0x40])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() async throws {
        let bytes: [UInt8] = [0xB1, 0x0B, 0x7F]
        
        let event = try MIDIFileTrackEvent.CC(midi1SMFRawBytes: bytes)
        
        #expect(event.controller == .expression) // CC 11
        #expect(event.value == .midi1(0x7F))
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1SMFRawBytes_B() async {
        let event = MIDIFileTrackEvent.CC(
            controller: .expression,
            value: .midi1(0x7F),
            channel: 1
        )
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xB1, 0x0B, 0x7F])
    }
}
