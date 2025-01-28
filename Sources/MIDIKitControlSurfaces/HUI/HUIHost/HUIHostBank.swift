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
@Observable public final class HUIHostBank: Sendable {
    // MARK: - Decoder
    
    @ObservationIgnored
    nonisolated(unsafe)
    var decoder: HUISurfaceEventDecoder!
    
    // MARK: - Handlers
    
    /// HUI core event receive handler.
    public typealias HUIEventHandler = @Sendable (_ event: HUISurfaceEvent) -> Void
    
    /// Event handler that is called when HUI events are received.
    @ObservationIgnored
    public let huiEventHandler: HUIEventHandler?
    
    /// Remote presence state change handler (when pings resume or cease after timeout).
    public typealias PresenceChangedHandler = @Sendable (_ isPresent: Bool) -> Void
    
    /// Called when the remote presence state changes (when pings resume or cease after timeout).
    @ObservationIgnored
    public let remotePresenceChangedHandler: PresenceChangedHandler?
    
    @ObservationIgnored
    nonisolated(unsafe)
    public var midiOutHandler: MIDIOutHandler?
    
    // MARK: - Presence
    
    /// Time duration to wait since the last ping received before transitioning ``isRemotePresent``
    /// to `false`.
    ///
    /// HUI pings are sent from the host to surface(s) every 1 second.
    /// A timeout duration between `2 ... 5` seconds is reasonable depending on desired leeway.
    @ObservationIgnored
    public let remotePresenceTimeout: TimeInterval
    
    @ObservationIgnored
    nonisolated(unsafe)
    var remotePresenceTimer: Task<Void, any Error>?
    
    func restartRemotePresenceTimer() {
        remotePresenceTimer = Task { [weak self] in
            guard let self else { return }
            try await Task.sleep(for: .seconds(remotePresenceTimeout))
            self.isRemotePresent = false
            self.remotePresenceTimer?.cancel()
            self.remotePresenceTimer = nil
        }
    }
    
    /// This property will be `true` while ping messages are being received.
    /// If ping messages are interrupted, this property with transition to `false`.
    /// It will transition back to `true` once received ping messages resume.
    ///
    /// Ping timeout can be set to a custom value by setting the ``remotePresenceTimeout`` property.
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes.
    public internal(set) nonisolated(unsafe) var isRemotePresent: Bool = false
    
    func receivedPing() {
        restartRemotePresenceTimer()
        
        let oldValue = isRemotePresent
        isRemotePresent = true
        guard oldValue != isRemotePresent else { return }
        remotePresenceChangedHandler?(isRemotePresent)
    }
    
    // MARK: - Init
    
    /// Internal: Init.
    init(
        huiEventHandler: HUIEventHandler?,
        midiOutHandler: MIDIOutHandler?,
        remotePresenceTimeout: TimeInterval = 2.0,
        remotePresenceChangedHandler: PresenceChangedHandler? = nil
    ) {
        self.huiEventHandler = huiEventHandler
        self.midiOutHandler = midiOutHandler
        self.remotePresenceTimeout = remotePresenceTimeout.clamped(to: 1.1...)
        self.remotePresenceChangedHandler = remotePresenceChangedHandler
        
        decoder = HUISurfaceEventDecoder { [weak self] huiCoreEvent in
            if case .ping = huiCoreEvent {
                self?.receivedPing()
            }
            
            self?.huiEventHandler?(huiCoreEvent)
        }
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUIHostBank: ReceivesMIDIEvents {
    public func midiIn(event: MIDIEvent) {
        decoder.midiIn(event: event)
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUIHostBank: SendsMIDIEvents {
    // protocol requirements are implemented in class body
}
