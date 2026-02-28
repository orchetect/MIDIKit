//
//  Core MIDI Devices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
        let deviceRef = MIDIGetDevice(i)
        let device = MIDIDevice(from: deviceRef)
        guard device.uniqueID != .invalidMIDIIdentifier else { continue }
        devices.append(device)
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
        let entityRef = MIDIDeviceGetEntity(device, i)
        let entity = MIDIEntity(from: entityRef)
        guard entity.uniqueID != .invalidMIDIIdentifier else { continue }
        entities.append(entity)
    }
    
    return entities
}

#endif
