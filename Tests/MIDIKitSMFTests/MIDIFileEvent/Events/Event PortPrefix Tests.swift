//
//  Event PortPrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_PortPrefix_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1FileRawBytes() async throws {
        let bytes: [UInt8] = [0xFF, 0x21, 0x01, 0x02]
        
        let event = try MIDIFileEvent.PortPrefix(midi1FileRawBytes: bytes)
        
        #expect(event.port == 2)
    }
    
    @Test
    func midi1FileRawBytes() async {
        let event = MIDIFileEvent.PortPrefix(port: 2)
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x21, 0x01, 0x02])
    }
}
