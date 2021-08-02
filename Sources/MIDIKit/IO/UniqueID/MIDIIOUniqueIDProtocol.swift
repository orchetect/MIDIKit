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

// MARK: - MIDIIOEndpointUniqueIDProtocol

public protocol MIDIIOEndpointUniqueIDProtocol: MIDIIOUniqueIDProtocol {
    
}
