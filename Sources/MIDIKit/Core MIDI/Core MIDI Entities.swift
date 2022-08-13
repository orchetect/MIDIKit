//
//  Core MIDI Entities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

@_implementationOnly import CoreMIDI

/// Internal:
/// List of MIDI entities in the system (computed property)
internal func getSystemDevice(
    for entity: CoreMIDI.MIDIEntityRef
) throws -> MIDIDevice? {
    var dev = MIDIDeviceRef()
        
    try MIDIEntityGetDevice(entity, &dev)
        .throwIfOSStatusErr()
        
    guard dev != MIDIDeviceRef() else { return nil }
        
    return MIDIDevice(dev)
}
    
/// Internal:
/// List of source endpoints for the entity (computed property)
internal func getSystemSources(
    for entity: CoreMIDI.MIDIEntityRef
) -> [MIDIOutputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfSources(entity)
        
    var endpoints: [MIDIOutputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
        
    for i in 0 ..< srcCount {
        let endpoint = MIDIEntityGetSource(entity, i)
            
        endpoints.append(.init(endpoint))
    }
        
    return endpoints
}
    
/// Internal:
/// List of destination endpoints for the entity (computed property)
internal func getSystemDestinations(
    for entity: CoreMIDI.MIDIEntityRef
) -> [MIDIInputEndpoint] {
    let srcCount = MIDIEntityGetNumberOfDestinations(entity)
        
    var endpoints: [MIDIInputEndpoint] = []
    endpoints.reserveCapacity(srcCount)
        
    for i in 0 ..< srcCount {
        let endpoint = MIDIEntityGetDestination(entity, i)
            
        endpoints.append(.init(endpoint))
    }
        
    return endpoints
}

#endif
