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
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xB0, 0x01, 0x40]
        
        let event = try MIDIFileEvent.CC(midi1SMFRawBytes: bytes)
        
        #expect(event.controller == .modWheel) // CC 1
        #expect(event.value == .midi1(0x40))
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.CC(
            controller: .modWheel,
            value: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xB0, 0x01, 0x40])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xB1, 0x0B, 0x7F]
        
        let event = try MIDIFileEvent.CC(midi1SMFRawBytes: bytes)
        
        #expect(event.controller == .expression) // CC 11
        #expect(event.value == .midi1(0x7F))
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.CC(
            controller: .expression,
            value: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xB1, 0x0B, 0x7F])
    }
}
