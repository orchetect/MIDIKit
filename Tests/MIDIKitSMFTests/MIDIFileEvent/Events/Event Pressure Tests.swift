//
//  Event Pressure Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_Pressure_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1FileRawBytes_A() async throws {
        let bytes: [UInt8] = [0xD0, 0x40]
        
        let event = try MIDIFileEvent.Pressure(midi1FileRawBytes: bytes)
        
        #expect(event.amount == .midi1(0x40))
        #expect(event.channel == 0)
    }
    
    @Test
    func midi1FileRawBytes_A() async {
        let event = MIDIFileEvent.Pressure(
            amount: .midi1(0x40),
            channel: 0
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xD0, 0x40])
    }
    
    @Test
    func init_midi1FileRawBytes_B() async throws {
        let bytes: [UInt8] = [0xD1, 0x7F]
        
        let event = try MIDIFileEvent.Pressure(midi1FileRawBytes: bytes)
        
        #expect(event.amount == .midi1(0x7F))
        #expect(event.channel == 1)
    }
    
    @Test
    func midi1FileRawBytes_B() async {
        let event = MIDIFileEvent.Pressure(
            amount: .midi1(0x7F),
            channel: 1
        )
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xD1, 0x7F])
    }
}
