//
//  MTC Generator Tests.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKitSync
import TimecodeKit
import OTCore

final class MTC_Generator_Generator_Tests: XCTestCase {
    func testMTC_Generator_Default() {
        // just testing variations on syntax
        
        let mtcGen1 = MIDI.MTCGenerator()
        mtcGen1.midiOutHandler = { [weak self] (midiMessage) in
            _ = self
            _ = midiMessage
        }
        
        _ = MIDI.MTCGenerator { [weak self] (midiMessage) in
            _ = self
            _ = midiMessage
        }
        
        _ = MIDI.MTCGenerator(midiOutHandler: { (midiMessage) in
            _ = midiMessage
        })
        
        _ = MIDI.MTCGenerator { (midiMessage) in
            _ = midiMessage
        }
    }
}

#endif
