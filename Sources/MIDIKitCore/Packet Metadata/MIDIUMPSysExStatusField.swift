//
//  MIDIUMPSysExStatusField.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet SysEx Status Field.
/// Used with both SysEx7 and SysEx8.
public enum MIDIUMPSysExStatusField: UInt4 {
    /// Complete System Exclusive Message in one UMP System Exclusive.
    case complete = 0x0
    
    /// System Exclusive Start UMP.
    case start = 0x1
    
    /// System Exclusive Continue UMP.
    /// There might be multiple Continue UMPs in a single message.
    case `continue` = 0x2
    
    /// System Exclusive End UMP.
    case end = 0x3
    
    // 0x4... are unused/reserved
}

extension MIDIUMPSysExStatusField: Equatable { }

extension MIDIUMPSysExStatusField: Hashable { }

extension MIDIUMPSysExStatusField: CaseIterable { }

extension MIDIUMPSysExStatusField: Sendable { }
