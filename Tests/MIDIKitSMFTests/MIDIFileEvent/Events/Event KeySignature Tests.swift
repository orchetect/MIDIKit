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
    func init_midi1SMFRawBytes_A() async throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 0x04, 0x00]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        #expect(event.flatsOrSharps == 4)
        #expect(event.isMajor)
    }
    
    @Test
    func midi1SMFRawBytes_A() async throws {
        let event = try #require(MIDIFileEvent.KeySignature(flatsOrSharps: 4, isMajor: true))
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x59, 0x02, 0x04, 0x00])
    }
    
    @Test
    func init_midi1SMFRawBytes_B() async throws {
        let bytes: [UInt8] = [0xFF, 0x59, 0x02, 0xFD, 0x01]
        
        let event = try MIDIFileEvent.KeySignature(midi1SMFRawBytes: bytes)
        
        #expect(event.flatsOrSharps == -3)
        #expect(!event.isMajor)
    }
    
    @Test
    func midi1SMFRawBytes_B() async throws {
        let event = try #require(MIDIFileEvent.KeySignature(flatsOrSharps: -3, isMajor: false))
        
        let bytes = event.midi1SMFRawBytes(as: [UInt8].self)
        
        #expect(bytes == [0xFF, 0x59, 0x02, 0xFD, 0x01])
    }
    
    /// Ensure all enum cases have unique set of properties and there are no duplicates.
    @Test
    func checkUniqueProperties() async throws {
        let allCases = MIDIFileEvent.KeySignature.allCases
        let allCasesCount = allCases.count
        
        // check total possible cases
        #expect(allCasesCount == (-7 ... 7).count * 2)
        
        // ensure all cases have unique string values
        #expect(Set(allCases.map(\.stringValue)).count == allCasesCount)
        
        // ensure all cases have unique flatsOrSharps/isMajor value pairs
        #expect(Set(allCases.map { "\($0.flatsOrSharps)\($0.isMajor ? "M" : "m")" }).count == allCasesCount)
    }
    
    @Test
    func propertySetters() async throws {
        var sig: MIDIFileEvent.KeySignature = .cMajor
        
        sig.flatsOrSharps = -8 // invalid, silently fails
        #expect(sig == .cMajor)
        
        sig.flatsOrSharps = 8 // invalid, silently fails
        #expect(sig == .cMajor)
        
        sig.flatsOrSharps = 0 // already 0, no change
        #expect(sig == .cMajor)
        
        sig.flatsOrSharps = 1
        #expect(sig == .gMajor)
        
        sig.isMajor = false
        #expect(sig == .eMinor) // switches to relative minor, because it has 1 sharp
    }
}
