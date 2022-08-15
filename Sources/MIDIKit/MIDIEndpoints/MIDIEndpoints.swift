//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDIManager.endpoints` property could be swapped out with a different Endpoints class with Combine support
public protocol MIDIIOEndpointsProtocol {
    /// List of MIDI input endpoints in the system.
    var inputs: [MIDIInputEndpoint] { get }
    
    /// List of MIDI input endpoints in the system omitting virtual endpoints owned by this `MIDIManager` instance.
    var inputsUnowned: [MIDIInputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system.
    var outputs: [MIDIOutputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system omitting virtual endpoints owned by this `MIDIManager` instance.
    var outputsUnowned: [MIDIOutputEndpoint] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is called automatically by the `MIDIManager` when MIDI system endpoints change.
    mutating func update()
}

/// Manages system MIDI endpoints information cache.
public final class MIDIEndpoints: NSObject, MIDIIOEndpointsProtocol {
    /// Weak reference to `MIDIManager`.
    internal weak var manager: MIDIManager?
    
    public internal(set) dynamic var inputs: [MIDIInputEndpoint] = []
    public internal(set) dynamic var inputsUnowned: [MIDIInputEndpoint] = []
    
    public internal(set) dynamic var outputs: [MIDIOutputEndpoint] = []
    public internal(set) dynamic var outputsUnowned: [MIDIOutputEndpoint] = []
    
    override internal init() {
        super.init()
    }
    
    internal init(manager: MIDIManager) {
        self.manager = manager
        super.init()
    }
    
    public func update() {
        inputs = getSystemDestinationEndpoints()
    
        if let manager = manager {
            let managedInputsIDs = manager.managedInputs.values
                .compactMap { $0.uniqueID }
    
            inputsUnowned = inputs.filter {
                !managedInputsIDs.contains($0.uniqueID)
            }
        } else {
            inputsUnowned = inputs
        }
    
        outputs = getSystemSourceEndpoints()
    
        if let manager = manager {
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
