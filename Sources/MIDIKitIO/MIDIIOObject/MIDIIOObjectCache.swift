//
//  MIDIIOObjectCache.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// A temporary storage object for internal MIDI objects.
struct MIDIIOObjectCache {
    let devices: [MIDIDevice]
    let inputEndpoints: [MIDIInputEndpoint]
    let outputEndpoints: [MIDIOutputEndpoint]
    
    init(from manager: MIDIManager) {
        devices = manager.devices.devices
        inputEndpoints = manager.endpoints.inputs
        outputEndpoints = manager.endpoints.outputs
    }
}

#endif
