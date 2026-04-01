//
//  MusicalMIDIFile+Decoding Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitInternals
import MIDIKitSMF
import Testing

@Suite struct MusicalMIDIFile_Decoding_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets spacearoundoperators
    // swiftformat:options --maxwidth none
    
    /// Test parsing using NON-ASYNC method.
    /// Just ensure file parses successfully. Not testing contents in-depth.
    @Test
    func midiFileParse_NonAsync() /* NOT ASYNC! */ throws {
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MusicalMIDIFile(data: kMIDIFile.dp8Markers)
        
        try #require(midiFile.chunks.count == 3)
        
        let encodedData = try /* NOT AWAIT! */ midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.dp8Markers)
    }
    
    /// Test parsing using ASYNC method.
    /// Just ensure file parses successfully. Not testing contents in-depth.
    @Test
    func midiFileParse_Async() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.dp8Markers)
        
        try #require(midiFile.chunks.count == 3)
        
        let encodedData = try await midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.dp8Markers)
    }
    
    /// Test parsing using AsyncSequence method.
    /// Just ensure file parses successfully. Not testing contents in-depth.
    @Test
    func midiFileParse_AsyncSequence() async throws {
        actor Receiver {
            var chunks: [Int: MusicalMIDIFile.AnyChunk] = [:]
            func addChunk(index: Int, chunk: MusicalMIDIFile.AnyChunk) { chunks[index] = chunk }
            init() { }
        }
        let receiver = Receiver()
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.dp8Markers) { fileHeader, chunkIndex, chunkCount, result in
            // check header info
            #expect(fileHeader.format == .multipleTracksSynchronous)
            #expect(fileHeader.timebase == .musical(ticksPerQuarterNote: 480))
            
            // check chunk count
            #expect(chunkCount == 3)
            
            // collect parsed track
            do {
                let chunk = try result.get()
                Task { await receiver.addChunk(index: chunkIndex, chunk: chunk) }
            } catch {
                Issue.record("\(error.localizedDescription)")
            }
        }
        
        // wait for all tracks to be received asynchronously
        await wait(expect: { await receiver.chunks.count == 3 }, timeout: 10.0)
        
        // ensure tracks are also stored in the `MIDIFile` as usual
        try #require(midiFile.chunks.count == 3)
        
        // this also ensures tracks stored within the `MIDIFile` are in the correct order
        let encodedData = try await midiFile.rawData()
        #expect(encodedData.toUInt8Bytes() == kMIDIFile.dp8Markers)
    }
    
    /// Test parsing a MIDI file that contains an undefined chunk.
    @Test
    func customChunk() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.customChunk)
        
        try #require(midiFile.chunks.count == 2)
        
        // chunk 1 - track
        
        guard case let .track(track1) = midiFile.chunks[0] else {
            Issue.record()
            return
        }
        
        #expect(track1.events.count == 6)
        
        // chunk 2 - unknown chunk
        
        guard case let .undefined(unknownChunk) = midiFile.chunks[1] else {
            Issue.record()
            return
        }
        
        #expect(unknownChunk.identifier.string == "Kdoc")
        
        #expect(unknownChunk.rawData.count == 35)
        #expect(
            unknownChunk.rawData.toUInt8Bytes() ==
                [0x0D, 0x00, 0x00, 0x80, 0x3F, 0x10, 0x01, 0x22,
                 0x14, 0x0D, 0x00, 0x00, 0xF0, 0x41, 0x15, 0x00,
                 0x00, 0x48, 0x42, 0x1D, 0x00, 0x00, 0xA0, 0x41,
                 0x25, 0x00, 0x00, 0x20, 0x42, 0x30, 0x02, 0x38,
                 0x16, 0x40, 0x5A]
        )
    }
    
    // MARK: - DecodeOptions & Predicate
    
    /// Test that when the `allowMultiTrackFormat0` decode option is enabled, that all chunks are parsed
    /// regardless of the reported track count in the header.
    @Test
    func decodeOptions_allowMultiTrackFormat0() async throws {
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0, // timebase
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x41, 0x42, 0x43, 0x44, // ABCD
                                0x00, 0x00, 0x00, 0x02, // length: 2 bytes to follow
                                0x01, 0x02,             // data bytes
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x04, // length: 4 bytes to follow
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // flag disabled
        await #expect(throws: MIDIFileDecodeError.self) {
            let options = MIDIFileDecodeOptions(allowMultiTrackFormat0: false)
            let _ = try await MusicalMIDIFile(data: rawData, options: options)
        }
        
        // flag enabled
        do {
            let options = MIDIFileDecodeOptions(allowMultiTrackFormat0: true)
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 3)
            #expect(midiFile.tracks.count == 2)
        }
    }
    
    @Test
    func chunkDecodeOptions_errorStrategy_malformedEvent_invalidStatusByte() async throws {
        let track1 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0),
            .cc(delta: .ticks(240), controller: 0x0B, value: .midi1(0x14), channel: 1)
        ])
        
        let partialTrack2 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0)
            // a malformed status byte here means that track decoding can't continue, so all remaining events are lost
        ])
        
        let track3 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3D, velocity: .midi1(0x41), channel: 2),
        ])
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x03, // track count
                                0x02, 0xD0, // timebase
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x0D, // length: 13 bytes to follow
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xB1, 0x0B, 0x14,       // cc event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x11, // length: 17 bytes to follow
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xF0, 0x0B, 0x14,       // cc event -- ❌ but with an invalid status byte 0xF0
                                0x0F,                   // delta time
                                0xB1, 0x0C, 0x15,       // cc event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x08, // length: 8 bytes to follow
                                0x00,                   // delta time
                                0x92, 0x3D, 0x41,       // note on event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // throwOnError
        await #expect(throws: MIDIFileDecodeError.self) {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .throwOnError))
            let _ = try await MusicalMIDIFile(data: rawData, options: options)
        }
        
        // discardTracksWithErrors
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .discardTracksWithErrors))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 2)
            #expect(midiFile.tracks.count == 2)
            #expect(midiFile.tracks[0] == track1)
            #expect(midiFile.tracks[1] == track3)
        }
        
        // allowLossyRecovery
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .allowLossyRecovery))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 3)
            #expect(midiFile.tracks.count == 3)
            #expect(midiFile.tracks[0] == track1)
            #expect(midiFile.tracks[1] == partialTrack2)
            #expect(midiFile.tracks[2] == track3)
        }
    }
    
    @Test
    func chunkDecodeOptions_errorStrategy_malformedEvent_invalidDataByte() async throws {
        let track1 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0),
            .cc(delta: .ticks(240), controller: 0x0B, value: .midi1(0x14), channel: 1)
        ])
        
        let partialTrack2 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0),
            // < malformed CC event skipped over here >
            .cc(delta: .ticks(15), controller: 0x0C, value: .midi1(0x15), channel: 1)
        ])
        
        let track3 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3D, velocity: .midi1(0x41), channel: 2),
        ])
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x03, // track count
                                0x02, 0xD0, // timebase
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x0D, // length: 13 bytes to follow
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xB1, 0x0B, 0x14,       // cc event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x11, // length: 17 bytes to follow
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xB0, 0x82, 0x14,       // cc event -- ❌ but with an invalid controller number byte 0x82
                                0x0F,                   // delta time
                                0xB1, 0x0C, 0x15,       // cc event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x08, // length: 8 bytes to follow
                                0x00,                   // delta time
                                0x92, 0x3D, 0x41,       // note on event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00        // chunk end
        ]
        
        // throwOnError
        await #expect(throws: MIDIFileDecodeError.self) {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .throwOnError))
            let _ = try await MusicalMIDIFile(data: rawData, options: options)
        }
        
        // discardTracksWithErrors
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .discardTracksWithErrors))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 2)
            #expect(midiFile.tracks.count == 2)
            #expect(midiFile.tracks[0] == track1)
            #expect(midiFile.tracks[1] == track3)
        }
        
        // allowLossyRecovery
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .allowLossyRecovery))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 3)
            #expect(midiFile.tracks.count == 3)
            #expect(midiFile.tracks[0] == track1)
            #expect(midiFile.tracks[1] == partialTrack2)
            #expect(midiFile.tracks[2] == track3)
        }
    }
    
    @Test
    func chunkDecodeOptions_errorStrategy_truncatedTrack() async throws {
        let track1 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0),
            .cc(delta: .ticks(240), controller: 0x0B, value: .midi1(0x14), channel: 1)
        ])
        
        let partialTrack2 = MusicalMIDIFile.TrackChunk(events: [
            .noteOn(delta: .none, note: 0x3C, velocity: .midi1(0x40), channel: 0),
            .cc(delta: .ticks(240), controller: 0x0C, value: .midi1(0x24), channel: 0)
        ])
        
        let rawData: [UInt8] = [0x4D, 0x54, 0x68, 0x64, // MThd header
                                0x00, 0x00, 0x00, 0x06, // length
                                0x00, 0x00, // format
                                0x00, 0x02, // track count
                                0x02, 0xD0, // timebase
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x0D, // length: 13 bytes to follow
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xB1, 0x0B, 0x14,       // cc event
                                0x00,                   // delta time prior to chunk end
                                0xFF, 0x2F, 0x00,       // chunk end
                                
                                0x4D, 0x54, 0x72, 0x6B, // MTrk
                                0x00, 0x00, 0x00, 0x70, // length: 106 bytes to follow ❌ <-- we will truncate data early though
                                0x00,                   // delta time
                                0x90, 0x3C, 0x40,       // note on event
                                0x81, 0x70,             // delta time
                                0xB0, 0x0C, 0x24,       // cc event
                                0x00,                   // delta time
                                0x92                    // note on event, ❌ but only status byte; missing data bytes
                                // (track is now "truncated" -- missing the remainder of the track data)
                                
        ]
        
        // throwOnError
        await #expect(throws: MIDIFileDecodeError.self) {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .throwOnError))
            let _ = try await MusicalMIDIFile(data: rawData, options: options)
        }
        
        // discardTracksWithErrors
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .discardTracksWithErrors))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 1)
            #expect(midiFile.tracks.count == 1)
            #expect(midiFile.tracks[0] == track1)
        }
        
        // allowLossyRecovery
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(errorStrategy: .allowLossyRecovery))
            let midiFile = try await MusicalMIDIFile(data: rawData, options: options)
            
            #expect(midiFile.format == .singleTrack)
            #expect(midiFile.timebase == .musical(ticksPerQuarterNote: 720))
            #expect(midiFile.chunks.count == 2)
            #expect(midiFile.tracks.count == 2)
            #expect(midiFile.tracks[0] == track1)
            #expect(midiFile.tracks[1] == partialTrack2)
        }
    }
    
    @Test
    func decodeOptions_maxTrackEventCount() /* NOT ASYNC! */ throws {
        let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(maxEventCount: 1))
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MusicalMIDIFile(data: kMIDIFile.dp8Markers, options: options)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        for track in midiFile.tracks {
            #expect(track.events.count == 1)
        }
    }
    
    @Test
    func decodeOptions_maxTrackEventCount_async() async throws {
        let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(maxEventCount: 1))
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.dp8Markers, options: options)
        try #require(midiFile.chunks.count == 3)
        try #require(midiFile.tracks.count == 3)
        for track in midiFile.tracks {
            #expect(track.events.count == 1)
        }
    }
    
    @Test
    func predicate() /* NOT ASYNC! */ throws {
        // Note: It's ok if this throws a deprecation warning. We need to test this specific method.
        let midiFile = try /* NOT AWAIT! */ MusicalMIDIFile(data: kMIDIFile.dp8Markers) { identifier, chunkIndex in
            identifier == .track && chunkIndex == 1
        }
        try #require(midiFile.chunks.count == 1)
        let track = midiFile.tracks[0]
        #expect(track.events.count == 3) // check if the correct track was included
    }
    
    @Test
    func predicate_async() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.dp8Markers) { identifier, chunkIndex in
            identifier == .track && chunkIndex == 1
        }
        try #require(midiFile.chunks.count == 1)
        let track = midiFile.tracks[0]
        #expect(track.events.count == 3) // check if the correct track was included
    }
    
    @Test
    func decodeOptions_bundleRPNAndNRPNEvents() async throws {
        let rpnPayload = MIDIEvent.RPN(
            .raw(parameter: .init(msb: 0x05, lsb: 0x10), dataEntryMSB: 0x08, dataEntryLSB: 0x07),
            channel: 2
        )
        let event: MusicalMIDIFile.TrackChunk.Event = .init(delta: .none, event: .rpn(rpnPayload))
        let events: [MusicalMIDIFile.TrackChunk.Event] = [event]
        
        let track = MusicalMIDIFile.TrackChunk(events: events)
        let midiFile = MusicalMIDIFile(chunks: [.track(track)])
        
        let rawData = try await midiFile.rawData()
        
        // decode without bundleRPNAndNRPNEvents
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(bundleRPNAndNRPNEvents: false))
            let decodedMIDIFile = try await MusicalMIDIFile(data: rawData, options: options)
            #expect(decodedMIDIFile.tracks.count == 1)
            let decodedTrack = decodedMIDIFile.tracks[0]
            #expect(decodedTrack.events.count == 4)
            #expect(decodedTrack.events == [
                .cc(delta: .none, controller: .rpnMSB, value: .midi1(0x05), channel: 2),
                .cc(delta: .none, controller: .rpnLSB, value: .midi1(0x10), channel: 2),
                .cc(delta: .none, controller: .dataEntry, value: .midi1(0x08), channel: 2),
                .cc(delta: .none, controller: .lsb(for: .dataEntry), value: .midi1(0x07), channel: 2)
            ])
        }
        
        // decode with bundleRPNAndNRPNEvents
        do {
            let options = MIDIFileDecodeOptions(chunkDecodeOptions: .init(bundleRPNAndNRPNEvents: true))
            let decodedMIDIFile = try await MusicalMIDIFile(data: rawData, options: options)
            #expect(decodedMIDIFile.tracks.count == 1)
            let decodedTrack = decodedMIDIFile.tracks[0]
            #expect(decodedTrack.events.count == 1)
            #expect(decodedTrack.events == events)
        }
    }
    
    /// This test ensures the `ignoreBytesPastEOF` decoding option successfully ignores unexpected trailing bytes.
    @Test
    func decodeSpuriousBytesPastEOF_allowLossyRecovery() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.customChunk)
        let baseRawData: [UInt8] = try await midiFile.rawData(as: [UInt8].self)
        
        let garbageChunk: MusicalMIDIFile.AnyChunk = .undefined(identifier: "\u{43}\u{12}\u{01}\u{78}", data: Data())!
        var salvagedMIDIFile = try await MusicalMIDIFile(data: kMIDIFile.customChunk)
        salvagedMIDIFile.chunks.append(garbageChunk)
        
        // test with various trailing byte sequences - CR/LF, whitespace/newlines, etc.
        
        // ignoring spurious trailing bytes
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: true, chunkDecodeOptions: .init(errorStrategy: .allowLossyRecovery))
            
            let rawDataCR = baseRawData + [0x0D]
            #expect(try await MusicalMIDIFile(data: rawDataCR, options: options) == midiFile)
            
            let rawDataLF = baseRawData + [0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataLF, options: options) == midiFile)
            
            let rawDataCRLF = baseRawData + [0x0D, 0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataCRLF, options: options) == midiFile)
            
            let rawDataCRLF_CRLF = baseRawData + [0x0D, 0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataCRLF_CRLF, options: options) == midiFile)
            
            let rawDataSpace = baseRawData + [0x20] // space char
            #expect(try await MusicalMIDIFile(data: rawDataSpace, options: options) == midiFile)
            
            let rawData4Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78]
            #expect(try await MusicalMIDIFile(data: rawData4Bytes, options: options) == midiFile)
            
            let rawData8Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78, 0x00, 0x09, 0x10, 0x58]
            #expect(try await MusicalMIDIFile(data: rawData8Bytes, options: options) == salvagedMIDIFile)
        }
        
        // NOT ignoring spurious trailing bytes
        // (throwing error if spurious trailing bytes are encountered)
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: false, chunkDecodeOptions: .init(errorStrategy: .allowLossyRecovery))
            
            let rawDataCR = baseRawData + [0x0D]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCR, options: options) }
            
            let rawDataLF = baseRawData + [0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataLF, options: options) }
            
            let rawDataCRLF = baseRawData + [0x0D, 0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCRLF, options: options) }
            
            let rawDataCRLF_CRLF = baseRawData + [0x0D, 0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCRLF_CRLF, options: options) }
            
            let rawDataSpace = baseRawData + [0x20] // space char
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataSpace, options: options) }
            
            let rawData4Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawData4Bytes, options: options) }
            
            let rawData8Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78, 0x00, 0x09, 0x10, 0x58]
            #expect(try await MusicalMIDIFile(data: rawData8Bytes, options: options) == salvagedMIDIFile)
        }
    }
    
    /// This test ensures the `ignoreBytesPastEOF` decoding option successfully ignores unexpected trailing bytes.
    @Test
    func decodeSpuriousBytesPastEOF_throwOnError() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.customChunk)
        let baseRawData: [UInt8] = try await midiFile.rawData(as: [UInt8].self)
        
        // test with various trailing byte sequences - CR/LF, whitespace/newlines, etc.
        
        // ignoring spurious trailing bytes
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: true, chunkDecodeOptions: .init(errorStrategy: .throwOnError))
            
            let rawDataCR = baseRawData + [0x0D]
            #expect(try await MusicalMIDIFile(data: rawDataCR, options: options) == midiFile)
            
            let rawDataLF = baseRawData + [0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataLF, options: options) == midiFile)
            
            let rawDataCRLF = baseRawData + [0x0D, 0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataCRLF, options: options) == midiFile)
            
            let rawDataCRLF_CRLF = baseRawData + [0x0D, 0x0A]
            #expect(try await MusicalMIDIFile(data: rawDataCRLF_CRLF, options: options) == midiFile)
            
            let rawDataSpace = baseRawData + [0x20] // space char
            #expect(try await MusicalMIDIFile(data: rawDataSpace, options: options) == midiFile)
            
            let rawData4Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78]
            #expect(try await MusicalMIDIFile(data: rawData4Bytes, options: options) == midiFile)
            
            let rawData8Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78, 0x00, 0x09, 0x10, 0x58]
            #expect(try await MusicalMIDIFile(data: rawData8Bytes, options: options) == midiFile)
        }
        
        // NOT ignoring spurious trailing bytes
        // (throwing error if spurious trailing bytes are encountered)
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: false, chunkDecodeOptions: .init(errorStrategy: .throwOnError))
            
            let rawDataCR = baseRawData + [0x0D]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCR, options: options) }
            
            let rawDataLF = baseRawData + [0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataLF, options: options) }
            
            let rawDataCRLF = baseRawData + [0x0D, 0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCRLF, options: options) }
            
            let rawDataCRLF_CRLF = baseRawData + [0x0D, 0x0A]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataCRLF_CRLF, options: options) }
            
            let rawDataSpace = baseRawData + [0x20] // space char
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawDataSpace, options: options) }
            
            let rawData4Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawData4Bytes, options: options) }
            
            let rawData8Bytes = baseRawData + [0x43, 0x12, 0x01, 0x78, 0x00, 0x09, 0x10, 0x58]
            await #expect(throws: (any Error).self) { try await MusicalMIDIFile(data: rawData8Bytes, options: options) }
        }
    }
    
    /// This test ensures the `ignoreBytesPastEOF` decoding option only takes effect if malformed bytes are found.
    /// If unexpected, but valid, chunk(s) are present past the end of the expected file data, parse them.
    @Test
    func decodeMoreTracksThanSpecifiedInHeader() async throws {
        let midiFile = try await MusicalMIDIFile(data: kMIDIFile.customChunk)
        let baseRawData: [UInt8] = try await midiFile.rawData(as: [UInt8].self)
        
        let extraTrack = MusicalMIDIFile.TrackChunk(events: [
            .cc(delta: .none, controller: .breath, value: .midi1(42), channel: 0)
        ])
        let extraTrackRawData = try extraTrack.midi1SMFRawBytes(as: [UInt8].self, using: midiFile.timebase)
        let rawDataExtraTrack = baseRawData + extraTrackRawData
        
        // ignoring spurious trailing bytes
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: true)
            let decodedMIDIFile = try await MusicalMIDIFile(data: rawDataExtraTrack, options: options)
            
            #expect(decodedMIDIFile.chunks.count == 3)
            #expect(decodedMIDIFile.chunks == midiFile.chunks + [.track(extraTrack)])
            
            #expect(decodedMIDIFile.tracks.count == 2)
            #expect(decodedMIDIFile.tracks == midiFile.tracks + [extraTrack])
        }
        
        // NOT ignoring spurious trailing bytes
        // (won't throw an error since the unexpected trailing data is a valid chunk)
        do {
            let options = MIDIFileDecodeOptions(ignoreBytesPastEOF: false)
            let decodedMIDIFile = try await MusicalMIDIFile(data: rawDataExtraTrack, options: options)
            
            #expect(decodedMIDIFile.chunks.count == 3)
            #expect(decodedMIDIFile.chunks == midiFile.chunks + [.track(extraTrack)])
            
            #expect(decodedMIDIFile.tracks.count == 2)
            #expect(decodedMIDIFile.tracks == midiFile.tracks + [extraTrack])
        }
    }
}
