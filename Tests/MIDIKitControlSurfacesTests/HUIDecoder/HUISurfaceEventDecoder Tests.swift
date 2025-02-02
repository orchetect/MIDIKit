//
//  HUISurfaceEventDecoder Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@testable import MIDIKitControlSurfaces
import Testing

@Suite struct HUISurfaceEventDecoderTests {
    /// Verifies that a HUI event encodes and decodes back to itself.
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func ping() {
        runHUIEventTest(.ping)
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func huiSwitch() {
        runHUIEventTest(
            .switch(huiSwitch: .channelStrip(2, .solo), state: true)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func faderLevel() {
        runHUIEventTest(
            .faderLevel(channelStrip: 2, level: .midpoint)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func levelMeter() {
        runHUIEventTest(
            .levelMeter(channelStrip: 2, side: .right, level: 8)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func vPot() {
        runHUIEventTest(
            .vPot(vPot: .editAssignA, delta: 4)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func jogWheel() {
        runHUIEventTest(
            .jogWheel(delta: -4)
        )
    }
    
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Test
    func systemReset() {
        runHUIEventTest(
            .systemReset
        )
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceEventDecoderTests {
    private final class Receiver: @unchecked Sendable {
        var decodedEvents: [HUISurfaceEvent] = []
    }
    
    func runHUIEventTest(
        _ sourceEvent: HUISurfaceEvent,
        matches outputEvents: [HUISurfaceEvent]? = nil
    ) {
        let receiver = Receiver()
        
        let decoder = HUISurfaceEventDecoder { huiEvent in
            receiver.decodedEvents.append(huiEvent)
        }
        let midiEvents = sourceEvent.encode()
        decoder.midiIn(events: midiEvents)
        
        let eventsToMatch = outputEvents ?? [sourceEvent]
        
        #expect(receiver.decodedEvents == eventsToMatch)
    }
}
