//
//  MIDIIOUniqueIDProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Equatable default implementation

// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Equatable and this implementation will be used)

extension MIDIIOUniqueIDProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        lhs.isEqual(to: rhs)
        
    }
    
    public func isEqual(to other: Self) -> Bool {
        
        coreMIDIUniqueID == other.coreMIDIUniqueID
        
    }
    
}

// MARK: - Hashable default implementation

// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Hashable and this implementation will be used)

extension MIDIIOUniqueIDProtocol {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(coreMIDIUniqueID)
        
    }
    
}

// MARK: - Identifiable default implementation

// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Identifiable and this implementation will be used)

extension MIDIIOUniqueIDProtocol {
    
    public typealias ID = MIDI.IO.CoreMIDIUniqueID
    
    public var id: ID { coreMIDIUniqueID }
    
}
