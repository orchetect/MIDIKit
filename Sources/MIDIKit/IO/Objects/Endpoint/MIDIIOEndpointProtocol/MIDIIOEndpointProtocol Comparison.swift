//
//  MIDIIOEndpointProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

// MARK: - Equatable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Equatable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    static public func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.uniqueID == rhs.uniqueID
        
    }
    
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Hashable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.uniqueID)
        
    }
    
}

// MARK: - Identifiable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Identifiable and this implementation will be used)

extension MIDIIOEndpointProtocol {
    
    public typealias ID = MIDI.IO.UniqueID
    
    public var id: ID { uniqueID }
    
}

#endif
