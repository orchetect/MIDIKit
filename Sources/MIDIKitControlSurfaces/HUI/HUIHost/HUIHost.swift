//
//  HUIHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitIO
internal import MIDIKitInternals

/// Object representing a HUI host which can provide one or more HUI banks.
/// Each bank can service a single HUI device and requires a MIDI input and output for each bank.
///
/// This object would typically be used by a desktop application such as a DAW (Digital Audio
/// Workstation) which is the host. Remote HUI devices (physical HUI hardware or iPad apps that
/// emulate HUI, for example) can then connect to the host through bidirectional MIDI (input and
/// output).
///
/// > HUI (_Human User Interface for Digital Audio Workstations_) is a DAW control surface protocol
/// > developed by Mackie that uses MIDI events as its underlying encoding.
/// >
/// > References:
/// > - [HUI Hardware Reference Guide](https://loudaudio.netx.net/portals/loud-public/#asset/9795)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class HUIHost: Sendable {
    /// HUI banks that are configured for this HUI host instance.
    public internal(set) var banks: [HUIHostBank] {
        get { accessQueue.sync { _banks } }
        set { accessQueue.sync { _banks = newValue } }
    }
    private nonisolated(unsafe) var _banks: [HUIHostBank] = []
    
    /// A HUI host transmits a ping message every 1 second to each of the remote surfaces that are
    /// configured to connect to it. So each bank will receive pings individually. HUI surfaces
    /// should respond with a ping-reply after each ping so that the host can maintain connection
    /// presence.
    @ObservationIgnored
    nonisolated(unsafe)
    var pingTimer: SafeDispatchTimer!
    
    @ObservationIgnored
    let accessQueue = DispatchQueue(label: "HUIHost", target: .global())
    
    // MARK: - Init
    
    /// Initialize with defaults.
    public init() {
        pingTimer = SafeDispatchTimer(
            rate: .seconds(1.0),
            leeway: .milliseconds(500),
            queue: nil
        ) { [weak self] in
                self?.pingTimerFired()
            }
        pingTimer.start()
    }
    
    deinit {
        pingTimer.stop()
    }
    
    // MARK: - Ping
    
    func pingTimerFired() {
        let event = encodeHUIPing(to: .surface)
        for bank in banks {
            bank.midiOut(event)
        }
    }
    
    // MARK: - Methods
    
    /// Add a HUI bank that can interface with a single HUI device.
    public func addBank(
        huiEventHandler: HUIHostBank.HUIEventHandler?,
        midiOutHandler: SendsMIDIEvents.MIDIOutHandler? = nil,
        remotePresenceTimeout: TimeInterval = 2.0,
        remotePresenceChangedHandler: HUIHostBank.PresenceChangedHandler? = nil
    ) {
        banks.append(
            HUIHostBank(
                huiEventHandler: huiEventHandler,
                midiOutHandler: midiOutHandler,
                remotePresenceTimeout: remotePresenceTimeout,
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
