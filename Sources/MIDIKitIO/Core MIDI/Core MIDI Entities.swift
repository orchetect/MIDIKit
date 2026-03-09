//
//  Core MIDI Entities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

/// Internal:
/// Return the owning device of the entity.
func getSystemDevice(
    forEntity entityRef: CoreMIDI.MIDIEntityRef
) throws(MIDIIOError) -> MIDIDevice? {
    let refPtr: UnsafeMutablePointer<MIDIDeviceRef>? = nil
    
    try MIDIEntityGetDevice(entityRef, refPtr)
        .throwIfOSStatusErr()
    
    guard let refPtr else { return nil }
    guard refPtr.pointee != MIDIDeviceRef() else { return nil }
    
    return MIDIDevice(from: refPtr.pointee)
}
    
/// Internal:
/// List of source endpoints for the entity (computed property)
func getSystemSourceEndpoints(
    forEntity entityRef: CoreMIDI.MIDIEntityRef
) -> [MIDIOutputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfSources(entityRef)
    
    var endpoints: [MIDIOutputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
    
    for i in 0 ..< srcCount {
        let endpointRef = MIDIEntityGetSource(entityRef, i)
        let endpoint = MIDIOutputEndpoint(from: endpointRef)
        guard endpoint.uniqueID != .invalidMIDIIdentifier else { continue }
        endpoints.append(endpoint)
    }
    
    return endpoints
}
    
/// Internal:
/// List of destination endpoints for the entity (computed property)
func getSystemDestinationEndpoints(
    forEntity entityRef: CoreMIDI.MIDIEntityRef
) -> [MIDIInputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfDestinations(entityRef)
    
    var endpoints: [MIDIInputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
    
    for i in 0 ..< srcCount {
        let endpointRef = MIDIEntityGetDestination(entityRef, i)
        let endpoint = MIDIInputEndpoint(from: endpointRef)
        guard endpoint.uniqueID != .invalidMIDIIdentifier else { continue }
        endpoints.append(endpoint)
    }
    
    return endpoints
}

#endif
