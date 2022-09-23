//
//  HUIHostEventDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// ``HUIHostEvent`` decoder.
/// Parses received MIDI events and converts them to ``HUIHostEvent`` events.
public final class HUIHostEventDecoder: HUIDecoderProtocol {
    // HUIDecoderProtocol
    public typealias Event = HUIHostEvent
    public var eventHandler: EventHandler?
    public init() {
        decoder = HUIDecoder(role: .host) { [weak self] coreEvent in
            let huiEvent = Event(from: coreEvent)
            self?.eventHandler?(huiEvent)
        }
    }
    public func reset() {
        decoder.reset()
    }
    
    // MARK: local state variables
    
    var decoder: HUIDecoder!
    
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}
