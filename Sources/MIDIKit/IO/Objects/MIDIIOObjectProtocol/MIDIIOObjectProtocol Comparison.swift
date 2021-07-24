//
//  MIDIIOObjectProtocol Comparison.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

// MARK: - Equatable default implementation

extension MIDIIOObjectProtocol {
    
    static public func == (lhs: Self, rhs: Self) -> Bool {
        lhs.coreMIDIObjectRef == rhs.coreMIDIObjectRef
    }
    
}

// MARK: - Hashable default implementation

extension MIDIIOObjectProtocol {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coreMIDIObjectRef)
    }
    
}
