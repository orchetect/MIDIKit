//
//  MIDIUMPMixedDataSetStatusField.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Mixed Data Set Status Field.
/// Only meant to be used with SysEx8 Mixed Data Set packets.
public enum MIDIUMPMixedDataSetStatusField: UInt4 {
    // 0x0...0x7 are unused/reserved
    
    /// Mixed Data Set Header UMP.
    case header = 0x8
    
    /// Mixed Data Set Payload UMP.
    case payload = 0x9
    
    // 0xA... are unused/reserved
}

extension MIDIUMPMixedDataSetStatusField: Equatable { }

extension MIDIUMPMixedDataSetStatusField: Hashable { }

extension MIDIUMPMixedDataSetStatusField: CaseIterable { }

extension MIDIUMPMixedDataSetStatusField: Sendable { }
