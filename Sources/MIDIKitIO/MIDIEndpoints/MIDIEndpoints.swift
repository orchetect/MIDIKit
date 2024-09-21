//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if canImport(Combine)
import Combine
#endif

public protocol MIDIEndpointsProtocol where Self: Equatable, Self: Hashable {
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

extension MIDIEndpointsProtocol /* : Equatable */ {
    public static func == (lhs: any MIDIEndpointsProtocol, rhs: any MIDIEndpointsProtocol) -> Bool {
        lhs.inputs == rhs.inputs &&
        lhs.inputsUnowned == rhs.inputsUnowned &&
        lhs.outputs == rhs.outputs &&
        lhs.outputsUnowned == rhs.outputsUnowned
    }
}

extension MIDIEndpointsProtocol /* : Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(inputs)
        hasher.combine(inputsUnowned)
        hasher.combine(outputs)
        hasher.combine(outputsUnowned)
    }
}

extension MIDIEndpointsProtocol {
    internal func _fetchProperties(manager: MIDIManager?) -> (
        inputs: [MIDIInputEndpoint],
        inputsUnowned: [MIDIInputEndpoint],
        outputs: [MIDIOutputEndpoint],
        outputsUnowned: [MIDIOutputEndpoint]
    ) {
        let inputs = getSystemDestinationEndpoints()
        
        let inputsUnowned: [MIDIInputEndpoint]
        if let manager {
            let managedInputsIDs = manager.managedInputs.values
                .compactMap { $0.uniqueID }
            
            inputsUnowned = inputs.filter {
                !managedInputsIDs.contains($0.uniqueID)
            }
        } else {
            inputsUnowned = inputs
        }
        
        let outputs = getSystemSourceEndpoints()
        
        let outputsUnowned: [MIDIOutputEndpoint]
        if let manager {
            let managedOutputsIDs = manager.managedOutputs.values
                .compactMap { $0.uniqueID }
            
            outputsUnowned = outputs.filter {
                !managedOutputsIDs.contains($0.uniqueID)
            }
        } else {
            outputsUnowned = outputs
        }
        
        return (
            inputs: inputs,
            inputsUnowned: inputsUnowned,
            outputs: outputs,
            outputsUnowned: outputsUnowned
        )
    }
}

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
