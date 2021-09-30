//
//  AnyEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// Type-erased box that can contain `MIDI.IO.InputEndpoint` or `MIDI.IO.OutputEndpoint`.
    public struct AnyEndpoint: _MIDIIOEndpointProtocol {
        
        public let endpointType: MIDI.IO.EndpointType
        
        public let coreMIDIObjectRef: MIDI.IO.CoreMIDIEndpointRef
        
        public let name: String
        
        public var uniqueID: UniqueID
        
        internal init<T: _MIDIIOEndpointProtocol>(_ other: T) {
            switch other {
            case is MIDI.IO.InputEndpoint:
                endpointType = .input
                
            case is MIDI.IO.OutputEndpoint:
                endpointType = .output
                
            case let otherCast as Self:
                endpointType = otherCast.endpointType
                
            default:
                preconditionFailure("Unexpected MIDIIOEndpointProtocol type: \(other)")
            }
            
            self.coreMIDIObjectRef = other.coreMIDIObjectRef
            self.name = other.name
            self.uniqueID = .init(other.uniqueID.coreMIDIUniqueID)
        }
        
    }
    
}

extension MIDI.IO.AnyEndpoint {
    
    public typealias UniqueID = MIDI.IO.AnyUniqueID
    
}
