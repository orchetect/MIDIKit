//
//  Event Note Off Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_NoteOff_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0x80, 0x01, 0x40]
        
        let event = try MIDIFileEvent.NoteOff(midi1SMFRawBytes: bytes)
        
        #expect(event.note.number == 1)
        #expect(event.velocity == .midi1(0x40))
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.NoteOff(
            note: 1,
            velocity: .midi1(0x40),
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0x80, 0x01, 0x40])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0x81, 0x3C, 0x7F]
        
        let event = try MIDIFileEvent.NoteOff(midi1SMFRawBytes: bytes)
        
        #expect(event.note.number == 60)
        #expect(event.velocity == .midi1(0x7F))
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.NoteOff(
            note: 60,
            velocity: .midi1(0x7F),
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0x81, 0x3C, 0x7F])
    }
}
