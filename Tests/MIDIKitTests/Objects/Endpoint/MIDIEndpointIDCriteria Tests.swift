//
//  MIDIEndpointIDCriteria Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKit

final class MIDIEndpointIDCriteria_Tests: XCTestCase {
    func testEndpoint_OutputEndpoint() {
        var endpoint = MIDIOutputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDIEndpointIDCriteria.endpoint(endpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            XCTAssertEqual(uID, 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            XCTAssertEqual(uID, 10_000_001)
            
        default:
            XCTFail()
        }
    }
    
    func testEndpoint_InputEndpoint() {
        var endpoint = MIDIInputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDIEndpointIDCriteria.endpoint(endpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            XCTAssertEqual(uID, 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            XCTAssertEqual(uID, 10_000_001)
            
        default:
            XCTFail()
        }
    }
    
    func testEndpoint_AnyEndpoint() {
        var endpoint = MIDIInputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        let anyEndpoint = endpoint.asAnyEndpoint()
        
        let criteria = MIDIEndpointIDCriteria.endpoint(anyEndpoint)
        
        switch criteria {
        case let .uniqueID(uID):
            XCTAssertEqual(uID, 10_000_001)
            
        case .uniqueIDWithFallback(
            id: let uID,
            fallbackDisplayName: _
        ):
            XCTAssertEqual(uID, 10_000_001)
            
        default:
            XCTFail()
        }
    }
}

#endif
