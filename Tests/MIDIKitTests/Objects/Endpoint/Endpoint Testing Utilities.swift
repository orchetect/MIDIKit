//
//  Endpoint Testing Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKit

extension MIDIInputEndpoint {
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(
        ref: CoreMIDIEndpointRef,
        name: String,
        displayName: String,
        uniqueID: MIDIIdentifier
    ) {
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
    }
}

extension MIDIOutputEndpoint {
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(
        ref: CoreMIDIEndpointRef,
        name: String,
        displayName: String,
        uniqueID: MIDIIdentifier
    ) {
        self.init(ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
    }
}

#endif
