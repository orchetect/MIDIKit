//
//  HUIHostBank.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

#if compiler(>=6.0)
internal import MIDIKitInternals
#else
@_implementationOnly import MIDIKitInternals
#endif

/// Object representing a ``HUIHost`` bank (connectable to one HUI surface over bidirectional MIDI).
///
/// This object is created and managed by ``HUIHost``. Do not instantiate this object directly.
/// Instead, call ``HUIHost/addBank(huiEventHandler:midiOutHandler:remotePresenceChangedHandler:)``
/// to add banks to your ``HUIHost`` instance.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class HUIHostBank {
    // MARK: - Decoder
    
    @ObservationIgnored
    var decoder: HUISurfaceEventDecoder!
    
    // MARK: - Handlers
    
    /// HUI core event receive handler.
    public typealias HUIEventHandler = ((_ event: HUISurfaceEvent) -> Void)
    
    /// Event handler that is called when HUI events are received.
    @ObservationIgnored
    public var huiEventHandler: HUIEventHandler?
    
    /// Remote presence state change handler (when pings resume or cease after timeout).
    public typealias PresenceChangedHandler = (_ isPresent: Bool) -> Void
    
    /// Called when the remote presence state changes (when pings resume or cease after timeout).
    public var remotePresenceChangedHandler: PresenceChangedHandler?
    
    @ObservationIgnored
    public var midiOutHandler: MIDIOutHandler?
    
    // MARK: - Presence
    
    /// Time duration to wait since the last ping received before transitioning ``isRemotePresent``
    /// to `false`.
    ///
    /// HUI pings are sent from the host to surface(s) every 1 second.
    /// A timeout duration between `2 ... 5` seconds is reasonable depending on desired leeway.
    public var remotePresenceTimeout: TimeInterval = 2.0 {
        didSet {
            // validate
            if remotePresenceTimeout < 1.1 { remotePresenceTimeout = 1.1 }
            // update timer interval
            Task {
                await remotePresenceTimer?.setRate(.seconds(remotePresenceTimeout))
                await remotePresenceTimer?.restart()
            }
        }
    }
    
    @ObservationIgnored
    var remotePresenceTimer: SafeDispatchTimer?
    
    func setupRemotePresenceTimer() {
        guard remotePresenceTimer == nil else { return }
        
        remotePresenceTimer = .init(
            rate: .seconds(remotePresenceTimeout),
            leeway: .milliseconds(50),
            eventHandler: { [weak self] in
                self?.isRemotePresent = false
                Task { await self?.remotePresenceTimer?.stop() }
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
        didSet {
            guard oldValue != isRemotePresent else { return }
            remotePresenceChangedHandler?(isRemotePresent)
        }
    }
    
    func receivedPing() {
        Task { await remotePresenceTimer?.restart(firingNow: false) }
        isRemotePresent = true
    }
    
    // MARK: - Init
    
    /// Internal: Init.
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUIHostBank: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUIHostBank: SendsMIDIEvents { }
