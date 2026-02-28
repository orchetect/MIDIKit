//
//  Core MIDI Entities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

/// Internal:
/// List of MIDI entities in the system (computed property)
func getSystemDevice(
    for entity: CoreMIDI.MIDIEntityRef
) throws(MIDIIOError) -> MIDIDevice? {
    var dev = MIDIDeviceRef()
    
    try MIDIEntityGetDevice(entity, &dev)
        .throwIfOSStatusErr()
    
    guard dev != MIDIDeviceRef() else { return nil }
    
    return MIDIDevice(from: dev)
}
    
/// Internal:
/// List of source endpoints for the entity (computed property)
func getSystemSources(
    for entity: CoreMIDI.MIDIEntityRef
) -> [MIDIOutputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfSources(entity)
    
    var endpoints: [MIDIOutputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
    
    for i in 0 ..< srcCount {
        let endpointRef = MIDIEntityGetSource(entity, i)
        let endpoint = MIDIOutputEndpoint(from: endpointRef)
        guard endpoint.uniqueID != .invalidMIDIIdentifier else { continue }
        endpoints.append(endpoint)
    }
    
    return endpoints
}
    
/// Internal:
/// List of destination endpoints for the entity (computed property)
func getSystemDestinations(
    for entity: CoreMIDI.MIDIEntityRef
) -> [MIDIInputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfDestinations(entity)
    
    var endpoints: [MIDIInputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
    
    for i in 0 ..< srcCount {
        let endpointRef = MIDIEntityGetDestination(entity, i)
        let endpoint = MIDIInputEndpoint(from: endpointRef)
        guard endpoint.uniqueID != .invalidMIDIIdentifier else { continue }
        endpoints.append(endpoint)
    }
    
    return endpoints
}

#endif
