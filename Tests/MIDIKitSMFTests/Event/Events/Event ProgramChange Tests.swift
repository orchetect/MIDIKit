//
//  Event ProgramChange Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_ProgramChange_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xC0, 0x40]
        
        let event = try MIDIFileEvent.ProgramChange(midi1SMFRawBytes: bytes)
        
        #expect(event.program == 0x40)
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.ProgramChange(
            program: 0x40,
            bank: .noBankSelect,
            channel: 0
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xC0, 0x40])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xC1, 0x7F]
        
        let event = try MIDIFileEvent.ProgramChange(midi1SMFRawBytes: bytes)
        
        #expect(event.program == 0x7F)
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.ProgramChange(
            program: 0x7F,
            bank: .noBankSelect,
            channel: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xC1, 0x7F])
    }
}
