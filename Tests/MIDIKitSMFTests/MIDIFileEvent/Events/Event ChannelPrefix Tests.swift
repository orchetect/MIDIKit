//
//  Event ChannelPrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_ChannelPrefix_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1FileRawBytes() async throws {
        let bytes: [UInt8] = [0xFF, 0x20, 0x01, 0x02]
        
        let event = try MIDIFileEvent.ChannelPrefix(midi1FileRawBytes: bytes)
        
        #expect(event.channel == 2)
    }
    
    @Test
    func midi1FileRawBytes() async {
        let event = MIDIFileEvent.ChannelPrefix(channel: 2)
        
        let bytes = event.midi1FileRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x20, 0x01, 0x02])
    }
}
