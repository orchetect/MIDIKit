//
//  Endpoint IDCriteria Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKit

final class EndpointIDCriteriaTests: XCTestCase {
    func testEndpoint_OutputEndpoint() {
        var endpoint = MIDI.IO.OutputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(endpoint)
        
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
        var endpoint = MIDI.IO.InputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(endpoint)
        
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
        var endpoint = MIDI.IO.InputEndpoint(10_000_000)
        endpoint.uniqueID = 10_000_001
        let anyEndpoint = endpoint.asAnyEndpoint()
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(anyEndpoint)
        
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
