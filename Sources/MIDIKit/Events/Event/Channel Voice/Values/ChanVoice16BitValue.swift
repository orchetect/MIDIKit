//
//  ChanVoice16BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    /// Channel Voice Note Velocity
    public enum ChanVoice16BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// MIDI 1.0 7-bit Channel Voice Note Velocity (0x00..0x7F)
        case midi1(MIDI.UInt7)
        
        /// MIDI 2.0 16-bit Channel Voice Note Velocity (0x0000...0xFFFF)
        case midi2(UInt16)
        
    }
    
}

extension MIDI.Event.ChanVoice16BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let uInt16):
                return lhs.midi2Value == uInt16
                
            }
            
        case .midi1(let lhsUInt7):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhs.unitIntervalValue == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhsUInt7 == rhsUInt7
                
            case .midi2(let uInt16):
                return lhs.midi2Value == uInt16
                
            }
            
        case .midi2(let lhsUInt16):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhs.unitIntervalValue == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let uInt16):
                return lhsUInt16 == uInt16
                
            }
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice16BitValue {
    
    /// Returns velocity as protocol-agnostic unit interval, converting if necessary.
    public var unitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.clamped(to: 0.0...1.0)
            
        case .midi1(let uInt7):
            return Double(uInt7.uInt8Value) / 0x7F
            
        case .midi2(let uInt16):
            return Double(uInt16) / 0xFFFF
            
        }
        
    }
    
    /// Returns velocity as a 7-bit MIDI 1.0 velocity value, converting if necessary.
    public var midi1Value: MIDI.UInt7 {
        
        switch self {
        case .unitInterval(let interval):
            let scaled = interval.clamped(to: 0.0...1.0) * 0x7F
            return MIDI.UInt7(scaled)
            
        case .midi1(let uInt7):
            return uInt7
            
        case .midi2(let uInt16):
            let scaled = (Double(uInt16) / 0xFFFF) * 0x7F
            return MIDI.UInt7(scaled)
            
        }
        
    }
    
    /// Returns velocity as a 16-bit MIDI 2.0 velocity value, converting if necessary.
    public var midi2Value: UInt16 {
        
        switch self {
        case .unitInterval(let interval):
            let scaled = interval.clamped(to: 0.0...1.0) * 0xFFFF
            return UInt16(scaled)
            
        case .midi1(let uInt7):
            let scaled = (Double(uInt7.uInt8Value) / 0x7F) * 0xFFFF
            return UInt16(scaled)
            
        case .midi2(let uInt16):
            return uInt16
            
        }
        
    }
    
}
