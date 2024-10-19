//
//  MIDIEndpointFilter Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import XCTest

final class MIDIEndpointFilter_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    // swiftformat:options --maxwidth none
    
    // MARK: - test data
    
    let ownedInputEndpoints: [MIDIInputEndpoint] = [
        .init(ref: 1000, name: "Virtual Input A", displayName: "My Virtual Input A",  uniqueID: -1000),
        .init(ref: 1001, name: "Virtual Input B", displayName: "My Virtual Input B",  uniqueID: -1001)
    ]
    
    let unownedInputEndpoints: [MIDIInputEndpoint] = [
        .init(ref: 2000, name: "Input B", displayName: "Unowned Input B", uniqueID: -2000),
        .init(ref: 2003, name: "Input A", displayName: "Unowned Input A", uniqueID: -2003),
        .init(ref: 2001, name: "Input C", displayName: "Unowned Input C", uniqueID: -2001),
        .init(ref: 2002, name: "Input A", displayName: "Unowned Input A", uniqueID: -2002),
        .init(ref: 2004, name: "Input D", displayName: "Unowned Input D", uniqueID: -2004)
    ]
    
    var systemInputEndpoints: [MIDIInputEndpoint] { unownedInputEndpoints + ownedInputEndpoints }
    
    let ownedOutputEndpoints: [MIDIOutputEndpoint] = [
        .init(ref: 3000, name: "Virtual Output A", displayName: "My Virtual Output A", uniqueID: -3000),
        .init(ref: 3001, name: "Virtual Output B", displayName: "My Virtual Output B", uniqueID: -3001)
    ]
    
    let unownedOutputEndpoints: [MIDIOutputEndpoint] = [
        .init(ref: 4000, name: "Output B", displayName: "Unowned Output B", uniqueID: -4000),
        .init(ref: 4003, name: "Output A", displayName: "Unowned Output A", uniqueID: -4003),
        .init(ref: 4001, name: "Output C", displayName: "Unowned Output C", uniqueID: -4001),
        .init(ref: 4002, name: "Output A", displayName: "Unowned Output A", uniqueID: -4002),
        .init(ref: 4004, name: "Output D", displayName: "Unowned Output D", uniqueID: -4004)
    ]
    
    var systemOutputEndpoints: [MIDIOutputEndpoint] { unownedOutputEndpoints + ownedOutputEndpoints }
    
    func testMaskedFilter_Inputs() throws {
        // only owned
        XCTAssertEqual(
            systemInputEndpoints.filter(
                .owned(),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            ownedInputEndpoints
        )
        
        // drop owned
        XCTAssertEqual(
            systemInputEndpoints.filter(
                dropping: .owned(),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            unownedInputEndpoints
        )
        
        // only specific endpoints, both owned and unowned
        XCTAssertEqual(
            systemInputEndpoints.filter(
                MIDIEndpointFilter(owned: false, criteria: [.uniqueID(-2000), .uniqueID(-2004), .uniqueID(-1001)]),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            [
                .init(ref: 2000, name: "Input B", displayName: "Unowned Input B", uniqueID: -2000),
                .init(ref: 2004, name: "Input D", displayName: "Unowned Input D", uniqueID: -2004),
                .init(ref: 1001, name: "Virtual Input B", displayName: "My Virtual Input B",  uniqueID: -1001)
            ]
        )
        
        // drop specific endpoints, both owned and unowned
        XCTAssertEqual(
            systemInputEndpoints.filter(
                dropping: MIDIEndpointFilter(owned: false, criteria: [.uniqueID(-2000), .uniqueID(-2004), .uniqueID(-1001)]),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            [
                .init(ref: 2003, name: "Input A", displayName: "Unowned Input A", uniqueID: -2003),
                .init(ref: 2001, name: "Input C", displayName: "Unowned Input C", uniqueID: -2001),
                .init(ref: 2002, name: "Input A", displayName: "Unowned Input A", uniqueID: -2002),
                .init(ref: 1000, name: "Virtual Input A", displayName: "My Virtual Input A",  uniqueID: -1000)
            ]
        )
    }
    
    func testMaskedFilter_Outputs() throws {
        // only owned
        XCTAssertEqual(
            systemOutputEndpoints.filter(
                .owned(),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            ownedOutputEndpoints
        )
        
        // drop owned
        XCTAssertEqual(
            systemOutputEndpoints.filter(
                dropping: .owned(),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            unownedOutputEndpoints
        )
        
        // only specific endpoints, both owned and unowned
        XCTAssertEqual(
            systemOutputEndpoints.filter(
                MIDIEndpointFilter(owned: false, criteria: [.uniqueID(-4000), .uniqueID(-4004), .uniqueID(-3001)]),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            [
                .init(ref: 4000, name: "Output B", displayName: "Unowned Output B", uniqueID: -4000),
                .init(ref: 4004, name: "Output D", displayName: "Unowned Output D", uniqueID: -4004),
                .init(ref: 3001, name: "Virtual Output B", displayName: "My Virtual Output B",  uniqueID: -3001)
            ]
        )
        
        // drop specific endpoints, both owned and unowned
        XCTAssertEqual(
            systemOutputEndpoints.filter(
                dropping: MIDIEndpointFilter(owned: false, criteria: [.uniqueID(-4000), .uniqueID(-4004), .uniqueID(-3001)]),
                ownedInputEndpoints: ownedInputEndpoints,
                ownedOutputEndpoints: ownedOutputEndpoints
            ),
            [
                .init(ref: 4003, name: "Output A", displayName: "Unowned Output A", uniqueID: -4003),
                .init(ref: 4001, name: "Output C", displayName: "Unowned Output C", uniqueID: -4001),
                .init(ref: 4002, name: "Output A", displayName: "Unowned Output A", uniqueID: -4002),
                .init(ref: 3000, name: "Virtual Output A", displayName: "My Virtual Output A",  uniqueID: -3000)
            ]
        )
    }
}

#endif
