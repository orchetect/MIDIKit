//
//  MIDIOSStatus Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import MIDIKitIO
import Testing

@Suite struct Errors_MIDIOSStatus_Tests {
    @Test
    func rawValue() {
        // spot check: known constant
		
        #expect(
            MIDIOSStatus(rawValue: -10830) ==
                .invalidClient
        )
		
        #expect(
            MIDIOSStatus.invalidClient.rawValue ==
                -10830
        )
		
        // other
		
        #expect(
            MIDIOSStatus(rawValue: 7777) ==
                .other(7777)
        )
		
        #expect(
            MIDIOSStatus.other(7777).rawValue ==
                7777
        )
    }
	
    @Test
    func customStringConvertible() {
        // spot check expected output
        
        let desc = "\(MIDIOSStatus.invalidClient))"
        // print(desc)
        #expect(desc.contains("invalidClient"))
    }
    
    @Test
    func localizedDescription() {
        // spot check expected output
        
        let desc = MIDIOSStatus.invalidClient.localizedDescription
        // print(desc)
        #expect(desc.contains("kMIDIInvalidClient"))
    }
}

#endif
