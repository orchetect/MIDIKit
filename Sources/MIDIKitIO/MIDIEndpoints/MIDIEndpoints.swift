//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDIManager.endpoints`
// property could be swapped out with a different Endpoints class with Combine support
public protocol MIDIEndpointsProtocol {
    /// List of MIDI input endpoints in the system.
    var inputs: [MIDIInputEndpoint] { get }
    
    /// List of MIDI input endpoints in the system omitting virtual endpoints owned by the
    /// ``MIDIManager`` instance.
    var inputsUnowned: [MIDIInputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system.
    var outputs: [MIDIOutputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system omitting virtual endpoints owned by the
    /// ``MIDIManager`` instance.
    var outputsUnowned: [MIDIOutputEndpoint] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is called automatically by the
    /// ``MIDIManager`` when MIDI system endpoints change.
    mutating func updateCachedProperties()
}

/// Manages system MIDI endpoints information cache.
public final class MIDIEndpoints: NSObject, MIDIEndpointsProtocol {
    /// Weak reference to ``MIDIManager``.
    weak var manager: MIDIManager?
    
    public internal(set) dynamic var inputs: [MIDIInputEndpoint] = []
    public internal(set) dynamic var inputsUnowned: [MIDIInputEndpoint] = []
    
    public internal(set) dynamic var outputs: [MIDIOutputEndpoint] = []
    public internal(set) dynamic var outputsUnowned: [MIDIOutputEndpoint] = []
    
    override init() {
        super.init()
    }
    
    init(manager: MIDIManager) {
        self.manager = manager
        super.init()
    }
    
    public func updateCachedProperties() {
        inputs = getSystemDestinationEndpoints()
    
        if let manager {
            let managedInputsIDs = manager.managedInputs.values
                .compactMap { $0.uniqueID }
    
            inputsUnowned = inputs.filter {
                !managedInputsIDs.contains($0.uniqueID)
            }
        } else {
            inputsUnowned = inputs
        }
    
        outputs = getSystemSourceEndpoints()
    
        if let manager {
            let managedOutputsIDs = manager.managedOutputs.values
                .compactMap { $0.uniqueID }
    
            outputsUnowned = outputs.filter {
                !managedOutputsIDs.contains($0.uniqueID)
            }
        } else {
            outputsUnowned = outputs
        }
    }
}

#endif
