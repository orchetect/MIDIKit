//
//  MIDIIOUniqueIDProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - MIDIIOUniqueIDProtocol

public protocol MIDIIOUniqueIDProtocol {
    
    /// Core MIDI value of `MIDIObjectRef` property key `kMIDIPropertyUniqueID`.
    var coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID { get }
    
    init(_ coreMIDIUniqueID: MIDI.IO.CoreMIDIUniqueID)
    
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
