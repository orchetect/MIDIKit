//
//  HUIHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitInternals

/// Object representing a HUI host which can provide one or more HUI banks.
/// Each bank can service a single HUI device and requires a MIDI input and output for each bank.
public final class HUIHost {
    /// HUI Banks that are configured for this HUI host instance.
    public internal(set) var banks: [HUIHostBank] = []
    
    internal var pingTimer: SafeDispatchTimer?
    
    // MARK: - Init
    
    public init() {
        startPingTimer()
    }
    
    deinit {
        pingTimer?.stop()
    }
    
    // MARK: - Ping
    
    /// Creates and starts the ping timer.
    /// This should be called once on class init.
    func startPingTimer() {
        guard pingTimer == nil else { return }
        
        pingTimer = .init(
            rate: .seconds(1.0),
            queue: .global(),
            leeway: .milliseconds(50)
        ) { [weak self] in
            let event = encodeHUIPing(to: .surface)
            self?.banks.forEach {
                $0.midiOut(event)
            }
        }
        
        pingTimer?.start()
    }
    
    // MARK: - Methods
    
    /// Add a HUI bank that can interface with a single HUI device.
    public func addBank(
        huiEventHandler: HUIHostBank.HUIEventHandler?,
        midiOutHandler: SendsMIDIEvents.MIDIOutHandler? = nil,
        remotePresenceChangedHandler: HUIHostBank.PresenceChangedHandler? = nil
    ) {
        banks.append(
            HUIHostBank(
                huiEventHandler: huiEventHandler,
                midiOutHandler: midiOutHandler,
                remotePresenceChangedHandler: remotePresenceChangedHandler
            )
        )
    }
    
    /// Remove the HUI bank at the given index.
    public func removeBank(atIndex index: Int) {
        if banks.indices.contains(index) {
            banks.remove(at: index)
        }
    }
    
    /// Remove all HUI banks.
    public func removeAllBanks() {
        guard !banks.isEmpty else { return }
        banks.removeAll()
    }
}
