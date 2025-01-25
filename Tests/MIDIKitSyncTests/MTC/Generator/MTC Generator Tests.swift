//
//  MTC Generator Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
import Testing
import TimecodeKitCore

@Suite class MTC_Generator_Generator_Tests {
    @Test
    func mtcGenerator_Default() async {
        // just testing variations on syntax
        
        let mtcGen1 = MTCGenerator()
        await mtcGen1.setMIDIOutHandler { [weak self] (midiMessage) in
            _ = self
            _ = midiMessage
        }
        
        _ = MTCGenerator { [weak self] (midiMessage) in
            _ = self
            _ = midiMessage
        }
        
        _ = MTCGenerator(midiOutHandler: { (midiMessage) in
            _ = midiMessage
        })
        
        _ = MTCGenerator { (midiMessage) in
            _ = midiMessage
        }
    }
}
