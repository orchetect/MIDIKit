//
//  HUISurface.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitInternals

/// Object representing a single HUI control surface device.
///
/// _Human User Interface for Digital Audio Workstations_ is a DAW control surface protocol developed by Mackie that uses MIDI events as its underlying encoding.
///
/// References:
/// - [HUI Hardware Reference Guide](https://loudaudio.netx.net/portals/loud-public/#asset/9795)
public final class HUISurface {
    // MARK: - State
    
    /// HUI control surface state model.
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes.
    public internal(set) var state: State {
        willSet {
            if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *) {
                objectWillChange.send()
            }
        }
    }
    
    // MARK: - Parser
    
    internal var parser: HUIParser!
    
    // MARK: - Handlers
    
    /// HUI event receive handler.
    public typealias HUIEventHandler = ((_ huiEvent: Event) -> Void)
    
    /// Parser event handler that triggers when HUI events are received.
    public var huiEventHandler: HUIEventHandler?
    
    /// Remote presence state change handler (when pings resume or cease after timeout).
    public typealias PresenceChangedHandler = (_ isPresent: Bool) -> Void
    
    /// Called when the remote presence state changes (when pings resume or cease after timeout).
    public var remotePresenceChangedHandler: PresenceChangedHandler?
    
    public var midiOutHandler: MIDIOutHandler?
    
    // MARK: - Presence
    
    /// Time duration to wait since the last ping received before transitioning ``isRemotePresent`` to `false`.
    ///
    /// HUI pings are sent from the host to surface(s) every 1 second. A timeout duration between 2 ... 5 seconds is reasonable depending on desired leeway.
    public var remotePresenceTimeout: TimeInterval = 2.0 {
        didSet {
            // validate
            if remotePresenceTimeout < 1.1 { remotePresenceTimeout = 1.1 }
            // update timer interval
            remotePresenceTimer?.setRate(.seconds(remotePresenceTimeout))
            remotePresenceTimer?.restart()
        }
    }
    
    var remotePresenceTimer: SafeDispatchTimer?
    
    func setupRemotePresenceTimer() {
        guard remotePresenceTimer == nil else { return }
        
        remotePresenceTimer = .init(
            rate: .seconds(remotePresenceTimeout),
            queue: .global(),
            leeway: .milliseconds(50),
            eventHandler: { [weak self] in
                
                self?.isRemotePresent = false
                self?.remotePresenceTimer?.stop()
            }
        )
    }
    
    /// This property will be `true` while ping messages are being received.
    /// If ping messages are interrupted, this property with transition to `false`.
    /// It will transition back to `true` once received ping messages resume.
    ///
    /// Ping timeout can be set to a custom value by setting the ``remotePresenceTimeout`` property.
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes.
    public internal(set) var isRemotePresent: Bool = false {
        willSet {
            guard isRemotePresent != newValue else { return }
            
            if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *) {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
        didSet {
            guard oldValue != isRemotePresent else { return }
            remotePresenceChangedHandler?(isRemotePresent)
        }
    }
    
    func receivedPing() {
        remotePresenceTimer?.restart(firingNow: false)
        isRemotePresent = true
        
        // send ping-reply if ping request is received
        transmitPing()
    }
        
    // MARK: - Init
        
    public init(
        huiEventHandler: HUIEventHandler? = nil,
        remotePresenceChangedHandler: PresenceChangedHandler? = nil,
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        self.huiEventHandler = huiEventHandler
        self.midiOutHandler = midiOutHandler
            
        state = State()
            
        parser = HUIParser(
            role: .surface,
            huiEventHandler: { [weak self] huiCoreEvent in
                if case .ping = huiCoreEvent {
                    self?.receivedPing()
                }
                
                // process event
                if let surfaceEvent = self?.state.updateState(from: huiCoreEvent) {
                    self?.huiEventHandler?(surfaceEvent)
                } else {
                    Logger.debug("Unhandled HUI event: \(huiCoreEvent)")
                }
            }
        )
        
        // presence timer
        setupRemotePresenceTimer()
        
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
