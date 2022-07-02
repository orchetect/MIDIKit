//
//  Devices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDI.IO.Manager.devices` property could be swapped out with a different Devices class with Combine support
public protocol MIDIIODevicesProtocol {
    
    /// List of MIDI devices in the system
    var devices: [MIDI.IO.Device] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is handled internally when MIDI system endpoints change.
    func update()
    
}

extension MIDI.IO {
    
    /// Manages system MIDI devices information cache.
    public class Devices: NSObject, MIDIIODevicesProtocol {
        
        public internal(set) dynamic var devices: [Device] = []
        
        internal override init() {
            
            super.init()
            
        }
        
        /// Manually update the locally cached contents from the system.
        public func update() {
            
            devices = MIDI.IO.getSystemDevices
            
        }
        
    }
    
}

#endif
