//
//  UniversalSysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Universal System Exclusive message type.
    public enum UniversalSysExType: MIDI.Byte, Equatable, Hashable {
        
        /// Real Time System Exclusive ID number (`0x7F`).
        case realTime = 0x7F
        
        /// Non-Real Time System Exclusive ID number (`0x7E`).
        case nonRealTime = 0x7E
        
    }
    
}

extension MIDI.Event.UniversalSysExType: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .realTime: return "realTime"
        case .nonRealTime: return "nonRealTime"
        }
        
    }
    
}
