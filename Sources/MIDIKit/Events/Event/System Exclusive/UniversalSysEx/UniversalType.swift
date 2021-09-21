//
//  UniversalType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.UniversalSysEx {
    
    /// Universal System Exclusive message type.
    public enum UniversalType: MIDI.Byte, Hashable {
        
        /// Real Time System Exclusive ID number (`0x7F`).
        case realTime = 0x7F
        
        /// Non-Real Time System Exclusive ID number (`0x7E`).
        case nonRealTime = 0x7E
        
    }
    
}

extension MIDI.Event.UniversalSysEx.UniversalType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .realTime: return "realTime"
        case .nonRealTime: return "nonRealTime"
        }
        
    }
    
}
