//
//  MIDIIOObjectCache.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// A temporary storage object for internal MIDI objects.
internal struct MIDIIOObjectCache {
    var devices: [MIDIDevice]
    var inputEndpoints: [MIDIInputEndpoint]
    var outputEndpoints: [MIDIOutputEndpoint]
        
    init(from manager: MIDIManager) {
        devices = manager.devices.devices
        inputEndpoints = manager.endpoints.inputs
        outputEndpoints = manager.endpoints.outputs
    }
}

#endif
