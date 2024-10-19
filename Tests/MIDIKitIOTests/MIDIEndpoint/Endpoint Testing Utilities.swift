//
//  Endpoint Testing Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO

extension MIDIInputEndpoint {
    /// Unit testing only:
    /// Manually mock an endpoint with custom name, display name, and unique ID.
    init(
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
    init(
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
