//
//  MIDIKitSMFTests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSMF

final class MIDIKitSMFTests: XCTestCase {
    // no tests in root class
    
    @available(macOS 13.0, *)
    func testRead() throws {
        let url = URL.homeDirectory.appending(path: "Downloads").appending(path: "ItDoesntMatter.mid")
        let midiFile = try MIDIFile(midiFile: url)
        
        let previewContents = midiFile.description
        
        print(previewContents)
        
        let newFile = MIDIFile(format: midiFile.format,
                               timeBase: midiFile.timeBase,
                               chunks: [.track(midiFile.tracks.first!)])
        let d = try newFile.rawData()
        let outurl = URL.homeDirectory.appending(path: "Downloads").appending(path: "test.mid")
        try d.write(to: outurl)
    }
}

#endif
