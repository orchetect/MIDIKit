//
//  MTC Generator Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitInternals
@testable import MIDIKitSync
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
            
            _ = MTCGenerator { [weak self] midiMessage in
                _ = self
                _ = midiMessage
            }
            
            _ = MTCGenerator(midiOutHandler: { midiMessage in
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
