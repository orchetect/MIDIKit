//
//  Endpoint IDCriteria Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit

final class EndpointIDCriteriaTests: XCTestCase {
    
    func testEndpoint_OutputEndpoint() {
        
        var endpoint = MIDI.IO.OutputEndpoint(10000000)
        endpoint.uniqueID = 10000001
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(endpoint)
        
        switch criteria {
        case .uniqueID(let uID):
            XCTAssertEqual(uID, 10000001)
        default:
            XCTFail()
        }
        
    }
    
    func testEndpoint_InputEndpoint() {
        
        var endpoint = MIDI.IO.InputEndpoint(10000000)
        endpoint.uniqueID = 10000001
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(endpoint)
        
        switch criteria {
        case .uniqueID(let uID):
            XCTAssertEqual(uID, 10000001)
        default:
            XCTFail()
        }
        
    }
    
    func testEndpoint_AnyEndpoint() {
        
        var endpoint = MIDI.IO.InputEndpoint(10000000)
        endpoint.uniqueID = 10000001
        let anyEndpoint = endpoint.asAnyEndpoint()
        
        let criteria = MIDI.IO.EndpointIDCriteria.endpoint(anyEndpoint)
        
        switch criteria {
        case .uniqueID(let uID):
            XCTAssertEqual(uID, 10000001)
        default:
            XCTFail()
        }
        
    }
    
}

#endif
