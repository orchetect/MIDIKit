//
//  MIDIDevices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Manages system MIDI devices information cache.
///
/// Do not instance this class directly. Instead, access the ``MIDIManager/devices`` property of
/// your central ``MIDIManager`` instance.
public struct MIDIDevices: MIDIDevicesProtocol {
    public internal(set) var devices: [MIDIDevice] = []
    
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public mutating func updateCachedProperties() {
        devices = getSystemDevices()
    }
}

#endif
