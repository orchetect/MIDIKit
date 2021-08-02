//
//  CoreMIDI Devices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// (Computed property) List of MIDI devices in the system
    internal static var getSystemDevices: [Device] {
        
        let devCount = MIDIGetNumberOfDevices()
        
        var devices: [Device] = []
        devices.reserveCapacity(devCount)
        
        for i in 0..<devCount {
            let device = MIDIGetDevice(i)
            
            devices.append(.init(device))
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
            
            entities.append(.init(entity))
        }
        
        return entities
        
    }
    
}
