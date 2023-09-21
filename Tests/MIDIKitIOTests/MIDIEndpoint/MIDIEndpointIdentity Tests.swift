//
//  MIDIEndpointIdentity Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import XCTest

final class MIDIEndpointIdentity_Tests: XCTestCase {
    func testEndpoint_OutputEndpoint() {
        var endpoint = MIDIOutputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
    
        let criteria = MIDIEndpointIdentity.endpoint(endpoint)
    
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
        var endpoint = MIDIInputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
    
        let criteria = MIDIEndpointIdentity.endpoint(endpoint)
    
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
    
    func testEndpoint_asAnyEndpoint() {
        var endpoint = MIDIInputEndpoint(from: 10_000_000)
        endpoint.uniqueID = 10_000_001
        let anyEndpoint = endpoint.asAnyEndpoint()
    
        let criteria = MIDIEndpointIdentity.endpoint(anyEndpoint)
    
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
