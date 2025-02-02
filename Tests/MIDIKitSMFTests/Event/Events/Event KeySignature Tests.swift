//
//  Event KeySignature Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_KeySignature_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 4, 0x00]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        #expect(event.flatsOrSharps == 4)
        #expect(event.majorKey == true)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.KeySignature(flatsOrSharps: 4, majorKey: true)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x59, 0x02, 4, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 0xFD, 0x01]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        #expect(event.flatsOrSharps == -3)
        #expect(event.majorKey == false)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.KeySignature(flatsOrSharps: -3, majorKey: false)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x59, 0x02, 0xFD, 0x01])
    }
}
