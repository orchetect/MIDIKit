//
//  HUIHostEventDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// ``HUIHostEvent`` decoder.
/// Parses received MIDI events and converts them to ``HUIHostEvent`` events.
public final class HUIHostEventDecoder: HUIDecoder {
    // HUIDecoder
    
    public typealias Event = HUIHostEvent
    
    nonisolated(unsafe)
    public var eventHandler: EventHandler?
    
    public init() {
        decoder = HUICoreDecoder(role: .host) { [weak self] coreEvent in
            let huiEvent = Event(from: coreEvent)
            self?.eventHandler?(huiEvent)
        }
    }
    
    public convenience init(eventHandler: EventHandler?) {
        self.init()
        self.eventHandler = eventHandler
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
