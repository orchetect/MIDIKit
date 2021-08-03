//
//  MIDIIOUniqueIDProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - MIDIIOUniqueIDProtocol

public protocol MIDIIOUniqueIDProtocol {
    
    /// CoreMIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    var coreMIDIUniqueID: MIDIUniqueID { get }
    
    init(_ coreMIDIUniqueID: MIDIUniqueID)
    
}

extension Collection where Element == MIDIIOUniqueIDProtocol {
    
    /// Returns the collection as a collection of type-erased `AnyUniqueID` unique IDs.
    public var asAnyUniqueIDs: [MIDI.IO.AnyUniqueID] {
        
        map { MIDI.IO.AnyUniqueID($0.coreMIDIUniqueID) }
        
    }
    
}

// MARK: - MIDIIOEndpointUniqueIDProtocol

public protocol MIDIIOEndpointUniqueIDProtocol: MIDIIOUniqueIDProtocol {
    
}
