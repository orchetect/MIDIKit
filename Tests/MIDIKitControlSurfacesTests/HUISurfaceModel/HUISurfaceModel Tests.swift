//
//  HUISurfaceModel Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct HUISurfaceModelTests {
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func channelStripsValidation() {
        let model = HUISurfaceModel()
        #expect(model.channelStrips.count == 8)
        
        // uses set { }
        model.channelStrips = [.init(), .init()]
        #expect(model.channelStrips.count == 8)
        
        // uses _modify { }
        _ = model.channelStrips.removeLast()
        #expect(model.channelStrips.count == 8)
        
        // uses _modify { }
        model.channelStrips.append(.init())
        #expect(model.channelStrips.count == 8)
    }
}
