//
//  MIDIHUIParameterProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

public protocol MIDIHUIParameterProtocol {
    
    /// HUI zone and port constant for the parameter
    @inlinable var zoneAndPort: MIDI.HUI.ZoneAndPortPair { get }
    
}
