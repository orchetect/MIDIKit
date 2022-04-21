//
//  Endpoint Testing Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

@testable import MIDIKit

extension MIDI.IO.InputEndpoint {
    
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(ref: MIDI.IO.CoreMIDIEndpointRef,
                  name: String,
                  displayName: String,
                  uniqueID: UniqueID) {
        
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
        
    }
    
}

extension MIDI.IO.OutputEndpoint {
    
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(ref: MIDI.IO.CoreMIDIEndpointRef,
                  name: String,
                  displayName: String,
                  uniqueID: UniqueID) {
        
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
        
    }
    
}

#endif
