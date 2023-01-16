//
//  HUIHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import MIDIKitInternals

/// Object representing a HUI host which can provide one or more HUI banks.
/// Each bank can service a single HUI device and requires a MIDI input and output for each bank.
///
/// This object would typically be used by a desktop application such as a DAW (Digital Audio
/// Workstation) which is the host. Remote HUI devices (physical HUI hardware or iPad apps that
/// emulate HUI, for example) can then connect to the host through bidirectional MIDI (input and
/// output).
///
/// > HUI (_Human User Interface for Digital Audio Workstations_) is a DAW control surface protocol
/// developed by Mackie that uses MIDI events as its underlying encoding.
/// >
/// > References:
/// > - [HUI Hardware Reference Guide](https://loudaudio.netx.net/portals/loud-public/#asset/9795)
public final class HUIHost {
    /// HUI banks that are configured for this HUI host instance.
    public internal(set) var banks: [HUIHostBank] = []
    
    /// A HUI host transmits a ping message every 1 second to each of the remote surfaces that are
    /// configured to connect to it. So each bank will receive pings individually. HUI surfaces
    /// should respond with a ping-reply after each ping so that the host can maintain connection
    /// presence.
    internal var pingTimer: SafeDispatchTimer?
    
    // MARK: - Init
    
    /// Initialize with defaults.
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
