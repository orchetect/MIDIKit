//
//  HUIBank.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Object representing a ``HUIHost`` bank (connectable to one HUI device).
public final class HUIBank {
    // MARK: - Parser
    
    var translator: HUISurface.State = .init()
    var parser: HUIParser = .init()
    
    // MARK: - Handlers
    
    public typealias HUIEventHandler = ((_ huiEvent: HUISurface.Event) -> Void)
    
    /// Parser event handler that triggers when HUI events are received.
    public var huiEventHandler: HUIEventHandler?
    
    public var midiOutHandler: MIDIOutHandler?
    
    // MARK: - Presence
    
    var lastPingReceived: Date?
    
    public var isPresent: Bool {
        guard let lastPingReceived = lastPingReceived
        else { return false }
        
        // 0.5sec margin over 1.0 ping time interval
        return Date().timeIntervalSince(lastPingReceived) < 1.5
    }
    
    // MARK: - Init
    
    init(midiOutHandler: MIDIOutHandler?) {
        self.midiOutHandler = midiOutHandler
        
        parser.huiEventHandler = { [weak self] huiCoreEvent in
            if case .ping = huiCoreEvent {
                self?.lastPingReceived = Date()
            }
            
            if let surfaceEvent = self?.translator.updateState(from: huiCoreEvent) {
                self?.huiEventHandler?(surfaceEvent)
            } else {
                Logger.debug("Unhandled HUI event: \(huiCoreEvent)")
            }
        }
    }
}

extension HUIBank: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        parser.midiIn(event: event)
    }
}

extension HUIBank: SendsMIDIEvents { }
