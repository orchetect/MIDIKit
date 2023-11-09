//
//  MIDIEndpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if canImport(Combine)
import Combine
#endif

// this protocol may not be necessary, it was experimental so that the `MIDIManager.endpoints`
// property could be swapped out with a different Endpoints class with Combine support
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

#if canImport(Combine)

/// Manages system MIDI endpoints information cache.
/// Class and properties are published for use in SwiftUI and Combine.
@available(macOS 10.15, macCatalyst 13, iOS 13, /* tvOS 13, watchOS 6, */ *)
public final class MIDIObservableEndpoints: NSObject, ObservableObject, MIDIEndpointsProtocol {
    /// Weak reference to ``MIDIManager``.
    internal weak var manager: MIDIManager?
    
    @Published public internal(set) dynamic var inputs: [MIDIInputEndpoint] = []
    @Published public internal(set) dynamic var inputsUnowned: [MIDIInputEndpoint] = []
    
    @Published public internal(set) dynamic var outputs: [MIDIOutputEndpoint] = []
    @Published public internal(set) dynamic var outputsUnowned: [MIDIOutputEndpoint] = []
    
    override internal init() {
        super.init()
    }
    
    internal init(manager: MIDIManager?) {
        self.manager = manager
        super.init()
    }
    
    public func updateCachedProperties() {
        willChangeValue(for: \.inputs)
        inputs = getSystemDestinationEndpoints()
        
        willChangeValue(for: \.inputsUnowned)
        if let manager = manager {
            let managedInputsIDs = manager.managedInputs.values
                .compactMap { $0.uniqueID }
            
            inputsUnowned = inputs.filter {
                !managedInputsIDs.contains($0.uniqueID)
            }
        } else {
            inputsUnowned = inputs
        }
        
        willChangeValue(for: \.outputs)
        outputs = getSystemSourceEndpoints()
        
        willChangeValue(for: \.outputsUnowned)
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

#endif
