//
//  MIDIObjectCache.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// An ephemeral in-memory only cache for MIDI objects held through the lifespan of the `MIDIManager`.
struct MIDIObjectCache {
    var devices: Set<MIDIDevice> = []
    var inputEndpoints: Set<MIDIInputEndpoint> = []
    var outputEndpoints: Set<MIDIOutputEndpoint> = []
    
    init() { }
    
    init(from manager: MIDIManager) {
        update(from: manager)
    }
}

extension MIDIObjectCache {
    /// Updates the cache with new or changed object metadata.
    /// All objects removed from the system will persist in the cache until it is pruned.
    mutating func update(from manager: MIDIManager, prune: Bool = false) {
        if prune {
            devices = []
            inputEndpoints = []
            outputEndpoints = []
        }
        
        // add or replace exiting objects that share the same Core MIDI ref.
        manager.devices.devices
            .filter { $0.uniqueID != .invalidMIDIIdentifier }
            .forEach { devices.update(with: $0) }
        
        manager.endpoints.inputs
            .filter { $0.uniqueID != .invalidMIDIIdentifier }
            .forEach { inputEndpoints.update(with: $0) }
        
        manager.endpoints.outputs
            .filter { $0.uniqueID != .invalidMIDIIdentifier }
            .forEach { outputEndpoints.update(with: $0) }
    }
}

#endif
