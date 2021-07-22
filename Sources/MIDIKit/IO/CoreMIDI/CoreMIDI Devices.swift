//
//  CoreMIDI Devices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDI.IO {
    
    /// (Computed property) List of MIDI devices in the system
    internal static var getSystemDevices: [Device] {
        
        let devCount = MIDIGetNumberOfDevices()
        
        var devices: [Device] = []
        devices.reserveCapacity(devCount)
        
        for i in 0..<devCount {
            let device = MIDIGetDevice(i)
            
            devices += .init(device)
        }
        
        return devices
        
    }
    
}

extension MIDI.IO {
    
    /// (Computed property) List of MIDI entities in the system
    internal static func getSystemEntities(for device: MIDIDeviceRef) -> [Entity] {
        
        let entityCount = MIDIDeviceGetNumberOfEntities(device)
        
        var entities: [Entity] = []
        entities.reserveCapacity(entityCount)
        
        for i in 0..<entityCount {
            let entity = MIDIDeviceGetEntity(device, i)
            
            entities += .init(entity)
        }
        
        return entities
        
    }
    
}
