//
//  Event XMFPatchTypePrefix Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSMF
import Testing

@Suite struct Event_XMFPatchTypePrefix_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    
    @Test
    func init_midi1SMFRawBytes_A() throws {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x01        // param
        ]
        
        let event = try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        #expect(event.patchSet == .generalMIDI1)
    }
    
    @Test
    func midi1SMFRawBytes_A() {
        let event = MIDIFileEvent.XMFPatchTypePrefix(patchSet: .generalMIDI1)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x01        // param
        ])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() throws {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x02        // param
        ]
        
        let event = try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        
        #expect(event.patchSet == .generalMIDI2)
    }
    
    @Test
    func midi1SMFRawBytes_B() {
        let event = MIDIFileEvent.XMFPatchTypePrefix(patchSet: .generalMIDI2)
        
        let bytes: [UInt8] = event.midi1SMFRawBytes()
        
        #expect(bytes == [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x02       // param
        ])
    }
    
    // MARK: - Edge Cases
    
    @Test
    func undefinedParam() {
        let bytes: [UInt8] = [
            0xFF, 0x60, // header
            0x01,       // length (always 1)
            0x20        // param (undefined)
        ]
        
        #expect(throws: (any Error).self) {
            try MIDIFileEvent.XMFPatchTypePrefix(midi1SMFRawBytes: bytes)
        }
    }
}
