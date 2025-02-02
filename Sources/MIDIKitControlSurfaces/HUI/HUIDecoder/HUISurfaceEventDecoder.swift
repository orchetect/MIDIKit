//
//  HUISurfaceEventDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// ``HUISurfaceEvent`` decoder.
/// Parses received MIDI events and converts them to ``HUISurfaceEvent`` events.
public final class HUISurfaceEventDecoder: HUIDecoder, Sendable {
    // HUIDecoder
    
    public typealias Event = HUISurfaceEvent
    
    public nonisolated(unsafe)
    var eventHandler: EventHandler?
    
    public init() {
        decoder = HUICoreDecoder(role: .surface) { [weak self] coreEvent in
            let huiEvent = Event(from: coreEvent)
            self?.eventHandler?(huiEvent)
        }
    }

    public func reset() {
        decoder.reset()
    }
    
    // MARK: local state variables
    
    nonisolated(unsafe)
    var decoder: HUICoreDecoder!
    
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}
