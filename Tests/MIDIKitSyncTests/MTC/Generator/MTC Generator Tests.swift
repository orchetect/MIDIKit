//
//  MTC Generator Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitSync
@testable import MIDIKitInternals
import Testing
import TimecodeKitCore

@Suite struct MTC_Generator_Generator_Tests {
    private final class Sandbox: Sendable {
        func foo() {
            let mtcGen = MTCGenerator()
            mtcGen.setMIDIOutHandler { [weak self] midiMessage in
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
    
    @Test
    func mtcGenerator_Default() async {
        // just testing variations on syntax
        
        let sandbox = Sandbox()
        sandbox.foo()
    }
}
