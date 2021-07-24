//
//  MIDIIOUniqueIDProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

// MARK: - MIDIIOUniqueIDProtocol

public protocol MIDIIOUniqueIDProtocol {
    
    /// CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    var coreMIDIUniqueID: MIDIUniqueID { get }
    
    init(_ coreMIDIUniqueID: MIDIUniqueID)
    
}

// default Equatable implementation
// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Equatable and this implementation will be used)
extension MIDIIOUniqueIDProtocol {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    public func isEqual(to other: Self) -> Bool {
        coreMIDIUniqueID == other.coreMIDIUniqueID
    }
    
}

// default Hashable implementation
// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Hashable and this implementation will be used)
extension MIDIIOUniqueIDProtocol {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coreMIDIUniqueID)
    }
    
}

// default Identifiable implementation
// (conforming types to MIDIIOUniqueIDProtocol just need to conform to Identifiable and this implementation will be used)
extension MIDIIOUniqueIDProtocol {
    
    public typealias ID = MIDIUniqueID
    
    public var id: MIDIUniqueID { coreMIDIUniqueID }
    
}

// MARK: - MIDIIOEndpointUniqueIDProtocol

public protocol MIDIIOEndpointUniqueIDProtocol: MIDIIOUniqueIDProtocol {
    
}
