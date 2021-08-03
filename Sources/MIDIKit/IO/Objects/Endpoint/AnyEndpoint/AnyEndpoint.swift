//
//  AnyEndpoint.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO {
    
    /// Type-erased box for `MIDI.IO.InputEndpoint` or `MIDI.IO.OutputEndpoint`
    public struct AnyEndpoint: MIDIIOEndpointProtocol {
        
        public let endpointType: MIDI.IO.EndpointType
        
        public let coreMIDIObjectRef: MIDIEndpointRef
        
        public let name: String
        
        public var uniqueID: UniqueID
        
        internal init<T: MIDIIOEndpointProtocol>(_ other: T) {
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
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOEndpointUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDIUniqueID) {
            self.coreMIDIUniqueID = coreMIDIUniqueID
        }
        
    }
    
}

extension MIDI.IO.AnyEndpoint.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.AnyEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.AnyEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        return "\(coreMIDIUniqueID)"
        
    }
    
}
