//
//  HUIHostEventDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// ``HUIHostEvent`` decoder.
/// Parses received MIDI events and converts them to ``HUIHostEvent`` events.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public final class HUIHostEventDecoder: HUIDecoder {
    // HUIDecoder
    
    public typealias Event = HUIHostEvent
    
    public var eventHandler: EventHandler?
    
    public init() {
        decoder = HUICoreDecoder(role: .host) { [weak self] coreEvent in
            let huiEvent = Event(from: coreEvent)
            self?.eventHandler?(huiEvent)
        }
    }

    public func reset() {
        decoder.reset()
    }
    
    // MARK: local state variables
    
    var decoder: HUICoreDecoder!
    
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}
