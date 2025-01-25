//
//  Event PortPrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_PortPrefix_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes() throws {
        let bytes: [UInt8] = [0xFF, 0x21, 0x01, 0x02]
        
        let event = try MIDIFileEvent.PortPrefix(midi1SMFRawBytes: bytes)
        
        #expect(event.port == 2)
    }
    
    @Test
    func midi1SMFRawBytes() {
        let event = MIDIFileEvent.PortPrefix(port: 2)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [0xFF, 0x21, 0x01, 0x02])
    }
}
