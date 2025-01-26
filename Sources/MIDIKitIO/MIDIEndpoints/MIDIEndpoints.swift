//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Manages system MIDI endpoints information cache.
public struct MIDIEndpoints: MIDIEndpointsProtocol {
    /// Weak reference to ``MIDIManager``.
    weak var manager: MIDIManager?
    
    public internal(set) var inputs: [MIDIInputEndpoint] = []
    public internal(set) var inputsUnowned: [MIDIInputEndpoint] = []
    
    public internal(set) var outputs: [MIDIOutputEndpoint] = []
    public internal(set) var outputsUnowned: [MIDIOutputEndpoint] = []
    
    init(manager: MIDIManager?) {
        self.manager = manager
    }
}

extension MIDIEndpoints {
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public mutating func updateCachedProperties() {
        let fetched = _fetchProperties(manager: manager)
        
        inputs = fetched.inputs
        inputsUnowned = fetched.inputsUnowned
        outputs = fetched.outputs
        outputsUnowned = fetched.outputsUnowned
    }
}

#endif
