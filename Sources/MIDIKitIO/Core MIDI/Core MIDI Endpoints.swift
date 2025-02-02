//
//  Core MIDI Endpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

internal import CoreMIDI

// MARK: - Sources
    
/// Internal:
/// List of MIDI endpoints in the system (computed property)
func getSystemSourceEndpoints() -> [MIDIOutputEndpoint] {
    let srcCount = MIDIGetNumberOfSources()
    
    var endpoints: [MIDIOutputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
    
    for i in 0 ..< srcCount {
        let endpoint = MIDIGetSource(i)
    
        endpoints.append(MIDIOutputEndpoint(from: endpoint))
    }
    
    return endpoints
}
    
// MARK: - Destinations
    
/// Internal:
/// Dictionary of destination names & endpoint unique IDs (computed property)
func getSystemDestinationEndpoints() -> [MIDIInputEndpoint] {
    let destCount = MIDIGetNumberOfDestinations()
    
    var endpoints: [MIDIInputEndpoint] = []
    endpoints.reserveCapacity(destCount)
    
    for i in 0 ..< destCount {
        let endpoint = MIDIGetDestination(i)
    
        endpoints.append(MIDIInputEndpoint(from: endpoint))
    }
    
    return endpoints
}

/// Internal:
/// Returns all source `MIDIEndpointRef`s in the system that have a name matching `name`.
///
/// - Parameter name: MIDI port name to search for.
func getSystemSourceEndpoints(
    matching name: String
) -> [CoreMIDI.MIDIEndpointRef] {
    var refs: [MIDIEndpointRef] = []
    
    for i in 0 ..< MIDIGetNumberOfSources() {
        let endpoint = MIDIGetSource(i)
        if (try? getName(of: endpoint)) == name { refs.append(endpoint) }
    }
    
    return refs
}
    
/// Internal:
/// Returns the first source `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`.
/// If not found, returns `nil`.
///
/// - Parameter uniqueID: MIDI port unique ID to search for.
func getSystemSourceEndpoint(
    matching uniqueID: CoreMIDI.MIDIUniqueID
) -> CoreMIDI.MIDIEndpointRef? {
    for i in 0 ..< MIDIGetNumberOfSources() {
        let endpoint = MIDIGetSource(i)
        if getUniqueID(of: endpoint) == uniqueID { return endpoint }
    }
    
    return nil
}

/// Internal:
/// Returns all destination `MIDIEndpointRef`s in the system that have a name matching `name`.
///
/// - Parameter name: MIDI port name to search for.
func getSystemDestinationEndpoints(
    matching name: String
) -> [CoreMIDI.MIDIEndpointRef] {
    var refs: [MIDIEndpointRef] = []
    
    for i in 0 ..< MIDIGetNumberOfDestinations() {
        let endpoint = MIDIGetDestination(i)
        if (try? getName(of: endpoint)) == name { refs.append(endpoint) }
    }
    
    return refs
}
    
/// Internal:
/// Returns the first destination `MIDIEndpointRef` in the system with a unique ID matching
/// `uniqueID`. If not found, returns `nil`.
///
/// - Parameter uniqueID: MIDI port unique ID to search for.
func getSystemDestinationEndpoint(
    matching uniqueID: CoreMIDI.MIDIUniqueID
) -> CoreMIDI.MIDIEndpointRef? {
    for i in 0 ..< MIDIGetNumberOfDestinations() {
        let endpoint = MIDIGetDestination(i)
        if getUniqueID(of: endpoint) == uniqueID { return endpoint }
    }
    
    return nil
}

/// Internal:
/// Returns a ``MIDIEntity`` instance of the endpoint's owning entity.
func getSystemEntity(
    for endpoint: MIDIEndpointRef
) throws -> MIDIEntity {
    var ent = MIDIEntityRef()
    
    try MIDIEndpointGetEntity(endpoint, &ent)
        .throwIfOSStatusErr()
    
    guard ent != MIDIEntityRef() else {
        throw MIDIIOError.internalInconsistency(
            "Error getting entity ID for endpoint ref \(endpoint)"
        )
    }
    
    return MIDIEntity(from: ent)
}

/// Internal:
/// Makes a virtual endpoint in the system invisible to the user.
func hide(endpoint: MIDIEndpointRef) throws {
    try MIDIObjectSetIntegerProperty(endpoint, kMIDIPropertyPrivate, 1)
        .throwIfOSStatusErr()
}

/// Internal:
/// Makes a virtual endpoint in the system visible to the user.
func show(endpoint: MIDIEndpointRef) throws {
    try MIDIObjectSetIntegerProperty(endpoint, kMIDIPropertyPrivate, 0)
        .throwIfOSStatusErr()
}

#endif
