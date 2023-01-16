//
//  Endpoint Testing Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO

extension MIDIInputEndpoint {
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    internal init(
        ref: CoreMIDIEndpointRef,
        name: String,
        displayName: String,
        uniqueID: MIDIIdentifier
    ) {
        self.init(from: ref)
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
        self.init(from: ref)
        self.name = name
        self.displayName = displayName
        self.uniqueID = uniqueID
    }
}

#endif
