//
//  Core MIDI Entities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Internal:
    /// List of MIDI entities in the system (computed property)
    internal static func getSystemDevice(for entity: MIDIEntityRef) throws -> Device? {
        
        var dev: MIDIDeviceRef = MIDIDeviceRef()
        
        try MIDIEntityGetDevice(entity, &dev)
            .throwIfOSStatusErr()
        
        guard dev != MIDIDeviceRef() else { return nil }
        
        return Device(dev)
        
    }
    
    /// Internal:
    /// List of source endpoints for the entity (computed property)
    internal static func getSystemSources(for entity: MIDIEntityRef) -> [OutputEndpoint] {
        
        let srcCount = MIDIEntityGetNumberOfSources(entity)
        
        var endpoints: [OutputEndpoint] = []
        endpoints.reserveCapacity(srcCount)
        
        for i in 0..<srcCount {
            let endpoint = MIDIEntityGetSource(entity, i)
            
            endpoints.append(.init(endpoint))
        }
        
        return endpoints
        
    }
    
    /// Internal:
    /// List of destination endpoints for the entity (computed property)
    internal static func getSystemDestinations(for entity: MIDIEntityRef) -> [InputEndpoint] {
        
        let srcCount = MIDIEntityGetNumberOfDestinations(entity)
        
        var endpoints: [InputEndpoint] = []
        endpoints.reserveCapacity(srcCount)
        
        for i in 0..<srcCount {
            let endpoint = MIDIEntityGetDestination(entity, i)
            
            endpoints.append(.init(endpoint))
        }
        
        return endpoints
        
    }
    
}

#endif
