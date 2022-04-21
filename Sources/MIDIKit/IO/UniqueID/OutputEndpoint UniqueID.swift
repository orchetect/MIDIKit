//
//  OutputEndpoint UniqueID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO.OutputEndpoint {
    
    /// MIDIKit Object Unique ID value type.
    /// Analogous with Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    public struct UniqueID: MIDIIOEndpointUniqueIDProtocol {
        
        public let coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID
        
        public init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID) {
            
            self.coreMIDIUniqueID = coreMIDIUniqueID
            
        }
        
    }
    
}

extension MIDI.IO.OutputEndpoint.UniqueID: Equatable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.OutputEndpoint.UniqueID: Hashable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.OutputEndpoint.UniqueID: Identifiable {
    // default implementation provided by MIDIIOUniqueIDProtocol
}

extension MIDI.IO.OutputEndpoint.UniqueID: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = MIDI.IO.CoreMIDIUniqueID
    
    public init(integerLiteral value: IntegerLiteralType) {
        
        coreMIDIUniqueID = value
        
    }
    
}

extension MIDI.IO.OutputEndpoint.UniqueID: CustomStringConvertible {
    
    public var description: String {
        
        "\(coreMIDIUniqueID)"
        
    }
    
}

// MARK: - Collection

extension Set where Element == MIDI.IO.OutputEndpoint.UniqueID {
    
    public func asCriteria() -> Set<MIDI.IO.OutputEndpointIDCriteria> {
        
        // for some reason Set(map { ... }) was not working
        // so we have to use reduce
        
        reduce(into: Set<MIDI.IO.OutputEndpointIDCriteria>()) {
            $0.insert(.uniqueID($1))
        }
        
    }
    
}

extension Array where Element == MIDI.IO.OutputEndpoint.UniqueID {
    
    @_disfavoredOverload
    public func asCriteria() -> [MIDI.IO.OutputEndpointIDCriteria] {
        
        map { .uniqueID($0) }
        
    }
    
}
