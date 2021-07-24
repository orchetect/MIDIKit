//
//  CoreMIDI Endpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDI.IO {
    
    // MARK: sources
    
    /// (Computed property) List of MIDI endpoints in the system
    internal static var getSystemSourceEndpoints: [OutputEndpoint] {
        
        let srcCount = MIDIGetNumberOfSources()
        
        var endpoints: [OutputEndpoint] = []
        endpoints.reserveCapacity(srcCount)
        
        for i in 0..<srcCount {
            let endpoint = MIDIGetSource(i)
            
            endpoints += .init(endpoint)
        }
        
        return endpoints
        
    }
    
    // MARK: destinations
    
    /// (Computed property) Dictionary of destination names & endpoint unique IDs
    internal static var getSystemDestinationEndpoints: [InputEndpoint] {
        
        let destCount = MIDIGetNumberOfDestinations()
        
        var endpoints: [InputEndpoint] = []
        endpoints.reserveCapacity(destCount)
        
        for i in 0..<destCount {
            let endpoint = MIDIGetDestination(i)
            
            endpoints += .init(endpoint)
        }
        
        return endpoints
        
    }
    
}


extension MIDI.IO {
    
    /// Returns all source `MIDIEndpointRef`s in the system that have a name matching `name`.
    /// - Parameter name: MIDI port name to search for.
    internal static func getSystemSourceEndpoints(matching name: String) -> [MIDIEndpointRef] {
        
        var refs: [MIDIEndpointRef] = []
        
        for i in 0..<MIDIGetNumberOfSources() {
            let endpoint = MIDIGetSource(i)
            if (try? MIDI.IO.getName(of: endpoint)) == name { refs.append(endpoint) }
        }
        
        return refs
        
    }
    
    /// Returns the first source `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
    /// - Parameter uniqueID: MIDI port unique ID to search for.
    internal static func getSystemSourceEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
        
        for i in 0..<MIDIGetNumberOfSources() {
            let endpoint = MIDIGetSource(i)
            if MIDI.IO.getUniqueID(of: endpoint) == uniqueID { return endpoint }
        }
        
        return nil
        
    }
    
}

extension MIDI.IO {
    
    /// Returns all destination `MIDIEndpointRef`s in the system that have a name matching `name`.
    /// - Parameter name: MIDI port name to search for.
    internal static func getSystemDestinationEndpoints(matching name: String) -> [MIDIEndpointRef] {
        
        var refs: [MIDIEndpointRef] = []
        
        for i in 0..<MIDIGetNumberOfDestinations() {
            let endpoint = MIDIGetDestination(i)
            if (try? MIDI.IO.getName(of: endpoint)) == name { refs.append(endpoint) }
        }
        
        return refs
        
    }
    
    /// Returns the first destination `MIDIEndpointRef` in the system with a unique ID matching `uniqueID`. If not found, returns `nil`.
    /// - Parameter uniqueID: MIDI port unique ID to search for.
    internal static func getSystemDestinationEndpoint(matching uniqueID: MIDIUniqueID) -> MIDIEndpointRef? {
        
        for i in 0..<MIDIGetNumberOfDestinations() {
            let endpoint = MIDIGetDestination(i)
            if MIDI.IO.getUniqueID(of: endpoint) == uniqueID { return endpoint }
        }
        
        return nil
        
    }
    
}


extension MIDI.IO {
    
    internal static func getSystemEntity(for endpoint: MIDIEndpointRef) throws -> Entity? {
        
        var ent: MIDIEntityRef = MIDIEntityRef()
        
        try MIDIEndpointGetEntity(endpoint, &ent)
            .throwIfOSStatusErr()
        
        guard ent != MIDIEntityRef() else { return nil }
        
        return Entity(ent)
        
    }
    
}
