//
//  HUISurface.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Object representing a single HUI control surface device.
/// (Human User Interface) for Digital Audio Workstations.
///
/// A DAW control surface protocol developed by Mackie that uses MIDI 1.0 as a transport.
///
/// References:
/// - [HUI Hardware Reference Guide](https://loudaudio.netx.net/portals/loud-public/#asset/9795)
public class HUISurface {
    // MARK: - State
        
    public internal(set) var state: State {
        willSet {
            if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *) {
                objectWillChange.send()
            }
        }
    }
        
    // MARK: - Parser
        
    internal var parser: HUIParser
        
    // MARK: - Handlers
        
    public typealias HUIEventHandler = ((_ huiEvent: Event) -> Void)
        
    /// Parser event handler that triggers when HUI events are received.
    public var huiEventHandler: HUIEventHandler?
        
    /// Called when a HUI MIDI message needs transmitting.
    public var midiOutHandler: MIDIOutHandler?
        
    // MARK: - init
        
    public init(
        huiEventHandler: HUIEventHandler? = nil,
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        self.huiEventHandler = huiEventHandler
        self.midiOutHandler = midiOutHandler
            
        state = State()
            
        parser = HUIParser()
            
        parser.huiEventHandler = { [weak self] huiCoreEvent in
            // send ping-reply if ping request is received
            if case .ping = huiCoreEvent {
                self?.transmitPing()
            }
                
            // process event
            if let surfaceEvent = self?.state.updateState(from: huiCoreEvent) {
                self?.huiEventHandler?(surfaceEvent)
            } else {
                Logger.debug("Unhandled HUI event: \(huiCoreEvent)")
            }
        }
            
        // HUI control surfaces send a System Reset message when they are powered on
        transmitSystemReset()
    }
        
    deinit {
        // HUI control surfaces send a System Reset message when they are powered off
        transmitSystemReset()
    }
        
    // MARK: - Methods
        
    /// Resets state back to init state. Handlers are unaffected.
    public func reset() {
        state = State()
        parser.reset()
    }
}

extension HUISurface: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        parser.midiIn(event: event)
    }
}

extension HUISurface: SendsMIDIEvents { }

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *)
extension HUISurface: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
