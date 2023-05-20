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
    
    func testLoadFile() throws {
        let url = FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Downloads")
            .appendingPathComponent("RUSH_E_FINAL.mid")
        let midiFile = try MIDIFile(midiFile: url)
        print(midiFile.tracks.count)
    }
}

#endif
