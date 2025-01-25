//
//  MIDIEndpointIdentity Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite struct MIDIEndpointIdentity_Tests {
    @Test
    func endpoint_OutputEndpoint() {
        var endpoint = MIDIOutputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDIEndpointIdentity.endpoint(endpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            #expect(uID == 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            #expect(uID == 10_000_001)
            
        default:
            Issue.record()
        }
    }
    
    @Test
    func endpoint_InputEndpoint() {
        var endpoint = MIDIInputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDIEndpointIdentity.endpoint(endpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            #expect(uID == 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            #expect(uID == 10_000_001)
            
        default:
            Issue.record()
        }
    }
    
    @Test
    func endpoint_asAnyEndpoint() {
        var endpoint = MIDIInputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
        let anyEndpoint = endpoint.asAnyEndpoint()
        
        let criteria = MIDIEndpointIdentity.endpoint(anyEndpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            #expect(uID == 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            #expect(uID == 10_000_001)
            
        default:
            Issue.record()
        }
    }
}

#endif
