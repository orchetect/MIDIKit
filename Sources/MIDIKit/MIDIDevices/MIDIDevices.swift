//
//  MIDIDevices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDIManager.devices` property could be swapped out with a different Devices class with Combine support
public protocol MIDIIODevicesProtocol {
    /// List of MIDI devices in the system
    var devices: [MIDIDevice] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is handled internally when MIDI system endpoints change.
    func update()
}

/// Manages system MIDI devices information cache.
///
/// Do not instance this class directly. Instead, access the `devices` property of your global `MIDIManager` instance.
public class MIDIDevices: NSObject, MIDIIODevicesProtocol {
    public internal(set) dynamic var devices: [MIDIDevice] = []
        
    override internal init() {
        super.init()
    }
        
    /// Manually update the locally cached contents from the system.
    public func update() {
        devices = getSystemDevices()
    }
}

#endif
