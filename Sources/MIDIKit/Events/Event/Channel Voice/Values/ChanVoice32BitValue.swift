//
//  ChanVoice32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    /// Channel Voice 32-Bit Value
    public enum ChanVoice32BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// MIDI 1.0 7-bit Channel Voice Value (0x00..0x7F)
        case midi1(MIDI.UInt7)
        
        /// MIDI 2.0 32-bit Channel Voice Value (0x00000000...0xFFFFFFFF)
        case midi2(UInt32)
        
    }
    
}

extension MIDI.Event.ChanVoice32BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let uInt32):
                return lhs.midi2Value == uInt32
                
            }
            
        case .midi1(let lhsUInt7):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhs.unitIntervalValue == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhsUInt7 == rhsUInt7
                
            case .midi2(let uInt32):
                return lhs.midi2Value == uInt32
                
            }
            
        case .midi2(let lhsUInt32):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhs.unitIntervalValue == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let uInt32):
                return lhsUInt32 == uInt32
                
            }
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice32BitValue {
    
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    public var unitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.clamped(to: 0.0...1.0)
            
        case .midi1(let uInt7):
            return Double(uInt7.uInt8Value) / 0x7F
            
        case .midi2(let uInt32):
            return Double(uInt32) / 0xFFFFFFFF
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    public var midi1Value: MIDI.UInt7 {
        
        switch self {
        case .unitInterval(let interval):
            let scaled = interval.clamped(to: 0.0...1.0) * 0x7F
            return MIDI.UInt7(scaled)
            
        case .midi1(let uInt7):
            return uInt7
            
        case .midi2(let uInt32):
            let scaled = (Double(uInt32) / 0xFFFFFFFF) * 0x7F
            return MIDI.UInt7(scaled)
            
        }
        
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    public var midi2Value: UInt32 {
        
        switch self {
        case .unitInterval(let interval):
            let scaled = interval.clamped(to: 0.0...1.0) * 0xFFFFFFFF
            return UInt32(scaled)
            
        case .midi1(let uInt7):
            let scaled = (Double(uInt7.uInt8Value) / 0x7F) * 0xFFFFFFFF
            return UInt32(scaled)
            
        case .midi2(let uInt32):
            return uInt32
            
        }
        
    }
    
}
