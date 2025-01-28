//
//  Core MIDI Devices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

internal import CoreMIDI

/// Internal:
/// List of MIDI devices in the system.
func getSystemDevices() -> [MIDIDevice] {
    let devCount = MIDIGetNumberOfDevices()
    
    var devices: [MIDIDevice] = []
    devices.reserveCapacity(devCount)
    
    for i in 0 ..< devCount {
        let device = MIDIGetDevice(i)
    
        devices.append(MIDIDevice(from: device))
    }
    
    return devices
}

/// Internal:
/// List of MIDI entities in the system.
func getSystemEntities(for device: CoreMIDI.MIDIDeviceRef) -> [MIDIEntity] {
    let entityCount = MIDIDeviceGetNumberOfEntities(device)
    
    var entities: [MIDIEntity] = []
    entities.reserveCapacity(entityCount)
    
    for i in 0 ..< entityCount {
        let entity = MIDIDeviceGetEntity(device, i)
    
        entities.append(MIDIEntity(from: entity))
    }
    
    return entities
}

#endif
