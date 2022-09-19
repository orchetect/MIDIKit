//
//  HUIHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Object representing a HUI host which can provide one or more HUI banks.
/// Each bank can service a single HUI device and requires a MIDI input and output for each bank.
public class HUIHost {
    /// HUI Banks that are configured for this HUI host instance.
    public internal(set) var banks: [HUIBank] = []
    
    internal var pingTimer: Timer?
    
    // MARK: - Init
    
    public init() {
        startPingTimer()
    }
    
    deinit {
        pingTimer?.invalidate()
    }
    
    // MARK: - Ping
    
    /// Creates and starts the ping timer. Is called once on class init.
    func startPingTimer() {
        DispatchQueue.global().async { [self] in
            pingTimer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.banks.forEach {
                    $0.midiOut(HUIConstants.kMIDI.kPingToClientMessage)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    /// Add a HUI bank that can interface with a single HUI device.
    public func addBank(midiOutHandler: SendsMIDIEvents.MIDIOutHandler? = nil) {
        banks.append(HUIBank(midiOutHandler: midiOutHandler))
    }
    
    /// Remove the HUI bank at the given index.
    public func removeBank(atIndex index: Int) {
        if banks.indices.contains(index) {
            banks.remove(at: index)
        }
    }
    
    /// Remove all HUI banks.
    public func removeAllBanks() {
        banks.removeAll()
    }
}
