//
//  InputEndpoint UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO.InputEndpoint {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOEndpointUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID) {
            
            self.coreMIDIUniqueID = coreMIDIUniqueID
            
        }
        
    }
    
}

extension MIDI.IO.InputEndpoint.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.InputEndpoint.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.InputEndpoint.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.InputEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDI.IO.CoreMIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.InputEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        "\(coreMIDIUniqueID)"
        
    }
    
}

// MARK: - Collection

extension Set where Element == MIDI.IO.InputEndpoint.UniqueID {
    
    public func asCriteria() -> Set<MIDI.IO.InputEndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.InputEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.InputEndpoint.UniqueID {
    
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.InputEndpointIDCriteria] {
        
        map { .uniqueID($0) }
        
    }
    
}
