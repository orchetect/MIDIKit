//
//  Endpoint Testing Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKit

extension MIDI.IO.InputEndpoint {
    
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(ref: MIDI.IO.EndpointRef,
                  name: String,
                  displayName: String,
                  uniqueID: MIDI.IO.UniqueID) {
        
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
        
    }
    
}

extension MIDI.IO.OutputEndpoint {
    
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(ref: MIDI.IO.EndpointRef,
                  name: String,
                  displayName: String,
                  uniqueID: MIDI.IO.UniqueID) {
        
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
        
    }
    
}

#endif
