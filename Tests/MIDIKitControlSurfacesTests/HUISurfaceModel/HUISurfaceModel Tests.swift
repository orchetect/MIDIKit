//
//  HUISurfaceModel Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import XCTest

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
final class HUISurfaceModelTests: XCTestCase {
    func testChannelStripsValidation() {
        let model = HUISurfaceModel()
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses set { }
        model.channelStrips = [.init(), .init()]
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses _modify { }
        _ = model.channelStrips.removeLast()
        XCTAssertEqual(model.channelStrips.count, 8)
        
        // uses _modify { }
        model.channelStrips.append(.init())
        XCTAssertEqual(model.channelStrips.count, 8)
    }
}
