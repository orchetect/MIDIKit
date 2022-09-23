//
//  HUIHostBank.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitInternals

/// Object representing a ``HUIHost`` bank (connectable to one HUI device).
public final class HUIHostBank {
    // MARK: - Decoder
    
    var decoder: HUISurfaceEventDecoder!
    
    // MARK: - Handlers
    
    /// HUI core event receive handler.
    public typealias HUIEventHandler = ((_ event: HUISurfaceEvent) -> Void)
    
    /// Event handler that is called when HUI events are received.
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
    }
    
    // MARK: - Init
    
    init(
        huiEventHandler: HUIEventHandler?,
        midiOutHandler: MIDIOutHandler?,
        remotePresenceChangedHandler: PresenceChangedHandler? = nil
    ) {
        self.huiEventHandler = huiEventHandler
        self.midiOutHandler = midiOutHandler
        self.remotePresenceChangedHandler = remotePresenceChangedHandler
        
        decoder = HUISurfaceEventDecoder { [weak self] huiCoreEvent in
            if case .ping = huiCoreEvent {
                self?.receivedPing()
            }
            
            self?.huiEventHandler?(huiCoreEvent)
        }
        
        // presence timer
        setupRemotePresenceTimer()
    }
}

extension HUIHostBank: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}

extension HUIHostBank: SendsMIDIEvents { }

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *)
extension HUIHostBank: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
