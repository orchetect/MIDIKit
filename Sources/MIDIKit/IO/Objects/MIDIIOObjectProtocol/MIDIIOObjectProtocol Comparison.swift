//
//  MIDIIOObjectProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Equatable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Equatable and this implementation will be used)

extension MIDIIOObjectProtocol {
    
    static public func == (lhs: Self, rhs: Self) -> Bool
    where Self : _MIDIIOObjectProtocol
    {
        
        lhs.coreMIDIObjectRef == rhs.coreMIDIObjectRef
        
    }
    
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Hashable and this implementation will be used)

extension MIDIIOObjectProtocol {
    
    /// Hash
    public func hash(into hasher: inout Hasher)
    where Self : _MIDIIOObjectProtocol
    {
        
        hasher.combine(self.coreMIDIObjectRef)
        
    }
    
}

// MARK: - Identifiable default implementation

// (conforming types to MIDIIOObjectProtocol just need to conform to Identifiable and this implementation will be used)

extension _MIDIIOObjectProtocol {
    
    public typealias ID = MIDI.IO.CoreMIDIObjectRef
    
    public var id: ID { coreMIDIObjectRef }
    
}
