//
//  HUIDecoderProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Protocol that all HUI decoders conform to.
public protocol HUIDecoderProtocol: ReceivesMIDIEvents {
    /// The concrete HUI event type returned by the event handler.
    associatedtype Event: HUIEventProtocol
    
    /// Event handler that is called to dispatch HUI events translated from received MIDI events.
    var eventHandler: EventHandler? { get set }
    
    /// Initialize with defaults.
    init()
    
    /// Resets state back to init state. Handlers are unaffected.
    func reset()
}

extension HUIDecoderProtocol {
    public typealias EventHandler = (_ event: Event) -> Void
    
    public init(eventHandler: EventHandler? = nil) {
        self.init()
        self.eventHandler = eventHandler
    }
}

