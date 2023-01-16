//
//  MIDIDevices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDIManager.devices`
// property could be swapped out with a different Devices class with Combine support
public protocol MIDIDevicesProtocol {
    /// List of MIDI devices in the system
    var devices: [MIDIDevice] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is handled internally when MIDI
    /// system endpoints change.
    func updateCachedProperties()
}

/// Manages system MIDI devices information cache.
///
/// Do not instance this class directly. Instead, access the ``MIDIManager/devices`` property of
/// your central ``MIDIManager`` instance.
public final class MIDIDevices: NSObject, MIDIDevicesProtocol {
    public internal(set) dynamic var devices: [MIDIDevice] = []
    
    override internal init() {
        super.init()
    }
    
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public func updateCachedProperties() {
        devices = getSystemDevices()
    }
}

#endif
