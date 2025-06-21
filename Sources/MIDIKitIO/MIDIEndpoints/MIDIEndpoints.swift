//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Manages system MIDI endpoints information cache.
public struct MIDIEndpoints: MIDIEndpointsProtocol {
    public internal(set) var inputs: [MIDIInputEndpoint] = []
    public internal(set) var inputsOwned: [MIDIInputEndpoint] = []
    public internal(set) var inputsUnowned: [MIDIInputEndpoint] = []
    
    public internal(set) var outputs: [MIDIOutputEndpoint] = []
    public internal(set) var outputsOwned: [MIDIOutputEndpoint] = []
    public internal(set) var outputsUnowned: [MIDIOutputEndpoint] = []
    
    init() { }
}

extension MIDIEndpoints {
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public mutating func updateCachedProperties(manager: MIDIManager) {
        let fetched = _fetchProperties(manager: manager)
        
        inputs = fetched.inputs
        
        var inputsOwned = inputs
        inputsOwned.removeAll(where: { fetched.inputsUnowned.contains($0) })
        self.inputsOwned = inputsOwned
        
        self.inputsUnowned = fetched.inputsUnowned
        
        outputs = fetched.outputs
        
        var outputsOwned = outputs
        outputsOwned.removeAll(where: { fetched.outputsUnowned.contains($0) })
        self.outputsOwned = outputsOwned
        
        self.outputsUnowned = fetched.outputsUnowned
    }
}

#endif
