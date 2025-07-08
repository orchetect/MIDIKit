//
//  MIDI File decode Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
import MIDIKitSMF
import Testing

@Suite struct MIDIFileDecodeTests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    /// Test parsing a MIDI file that contains an unrecognized chunk.
    @Test
    func customChunk() throws {
        let midiFile = try MIDIFile(rawData: kMIDIFile.customChunk.data)
        
        try #require(midiFile.chunks.count == 2)
        
        // chunk 1 - track
        
        guard case let .track(track1) = midiFile.chunks[0] else {
            Issue.record()
            return
        }
        
        #expect(track1.events.count == 6)
        
        // chunk 2 - unknown chunk
        
        guard case let .other(unknownChunk) = midiFile.chunks[1] else {
            Issue.record()
            return
        }
        
        #expect(unknownChunk.identifier == "Kdoc")
        
        #expect(unknownChunk.rawData.count == 35)
        #expect(
            unknownChunk.rawData.toUInt8Bytes ==
                [0x0D, 0x00, 0x00, 0x80, 0x3F, 0x10, 0x01, 0x22,
                 0x14, 0x0D, 0x00, 0x00, 0xF0, 0x41, 0x15, 0x00,
                 0x00, 0x48, 0x42, 0x1D, 0x00, 0x00, 0xA0, 0x41,
                 0x25, 0x00, 0x00, 0x20, 0x42, 0x30, 0x02, 0x38,
                 0x16, 0x40, 0x5A]
        )
    }
}
