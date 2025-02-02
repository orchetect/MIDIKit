//
//  HUIHostBank.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitIO

internal import MIDIKitInternals

/// Object representing a ``HUIHost`` bank (connectable to one HUI surface over bidirectional MIDI).
///
/// This object is created and managed by ``HUIHost``. Do not instantiate this object directly.
/// Instead, call ``HUIHost/addBank(huiEventHandler:midiOutHandler:remotePresenceTimeout:remotePresenceChangedHandler:)``
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
    
    var remotePresenceTimer: Task<Void, any Error>? {
        get { _remotePresenceTimer.value }
        _modify { yield &_remotePresenceTimer.value }
        set { _remotePresenceTimer.value = newValue }
    }
    @ObservationIgnored
    private nonisolated(unsafe) var _remotePresenceTimer = ThreadSafeAccessValue(value: nil as Task<Void, any Error>?)
    
    func restartRemotePresenceTimer() {
        remotePresenceTimer?.cancel()
        remotePresenceTimer = nil
        
        remotePresenceTimer = Task { [weak self] in
            guard let self else { return }
            try await Task.sleep(for: .seconds(remotePresenceTimeout))
            try Task.checkCancellation()
            self.isRemotePresent = false
            self.remotePresenceTimer?.cancel()
            self.remotePresenceTimer = nil
            remotePresenceChangedHandler?(false)
        }
    }
    
    /// This property will be `true` while ping messages are being received.
    /// If ping messages are interrupted, this property with transition to `false`.
    /// It will transition back to `true` once received ping messages resume.
    ///
    /// Ping timeout can be set to a custom value by setting the ``remotePresenceTimeout`` property.
    ///
    /// This property is observable with Combine/SwiftUI and can trigger UI updates upon changes.
    public internal(set) var isRemotePresent: Bool {
        get { _isRemotePresent.value }
        _modify { yield &_isRemotePresent.value }
        set { _isRemotePresent.value = newValue }
    }
    private nonisolated(unsafe) var _isRemotePresent = ThreadSafeAccessValue(value: false)
    
    private func receivedPing() {
        let oldValue = isRemotePresent
        restartRemotePresenceTimer()
        isRemotePresent = true
        if !oldValue {
            remotePresenceChangedHandler?(true)
        }
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
