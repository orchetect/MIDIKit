//
//  Endpoints.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation

// this protocol may not be necessary, it was experimental so that the `MIDI.IO.Manager.endpoints` property could be swapped out with a different Endpoints class with Combine support
public protocol MIDIIOEndpointsProtocol {
    
    /// List of MIDI input endpoints in the system.
    var inputs: [MIDI.IO.InputEndpoint] { get }
    
    /// List of MIDI input endpoints in the system omitting virtual endpoints owned by this `Manager` instance.
    var inputsUnowned: [MIDI.IO.InputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system.
    var outputs: [MIDI.IO.OutputEndpoint] { get }
    
    /// List of MIDI output endpoints in the system omitting virtual endpoints owned by this `Manager` instance.
    var outputsUnowned: [MIDI.IO.OutputEndpoint] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is called automatically by the `Manager` when MIDI system endpoints change.
    mutating func update()
    
}

extension MIDI.IO {
    
    /// Manages system MIDI endpoints information cache.
    public class Endpoints: NSObject, MIDIIOEndpointsProtocol {
        
        /// Weak reference to `Manager`.
        internal weak var manager: MIDI.IO.Manager? = nil
        
        public internal(set) dynamic var inputs: [InputEndpoint] = []
        public internal(set) dynamic var inputsUnowned: [InputEndpoint] = []
        
        public internal(set) dynamic var outputs: [OutputEndpoint] = []
        public internal(set) dynamic var outputsUnowned: [OutputEndpoint] = []
        
        internal override init() {
            
            super.init()
            
        }
        
        internal init(manager: Manager) {
            
            self.manager = manager
            super.init()
            
        }
        
        public func update() {
            
            inputs = MIDI.IO.getSystemDestinationEndpoints
            
            if let manager = manager {
                let managedInputsIDs = manager.managedInputs.values
                    .compactMap { $0.uniqueID }
                
                inputsUnowned = inputs.filter {
                    !managedInputsIDs.contains($0.uniqueID)
                }
            } else {
                inputsUnowned = inputs
            }
            
            outputs = MIDI.IO.getSystemSourceEndpoints
            
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
    
}

#endif
