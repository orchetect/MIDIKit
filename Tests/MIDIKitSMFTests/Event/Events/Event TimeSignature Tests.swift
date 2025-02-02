//
//  Event TimeSignature Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_TimeSignature_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes() throws {
        let bytes: [UInt8] = [
            0xFF, 0x58, 0x04, // header
            0x02, // numerator
            0x01, // denominator
            0x18, // midiClocksBetweenMetronomeClicks
            0x08  // numberOf32ndNotesInAQuarterNote
        ]
        
        let event = try MIDIFileEvent.TimeSignature(midi1SMFRawBytes: bytes)
        
        #expect(event.numerator == 2)
        #expect(event.denominator == 1)
        #expect(event.midiClocksBetweenMetronomeClicks == 0x18)
        #expect(event.numberOf32ndNotesInAQuarterNote == 0x08)
    }
    
    @Test
    func midi1SMFRawBytes() {
        let event = MIDIFileEvent.TimeSignature(
            numerator: 2,
            denominator: 1
        )
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xFF, 0x58, 0x04, // header
            0x02, // numerator
            0x01, // denominator
            0x18, // midiClocksBetweenMetronomeClicks
            0x08  // numberOf32ndNotesInAQuarterNote
        ])
    }
}
