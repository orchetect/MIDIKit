//
//  ChanVoice7Bit16BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    /// Channel Voice 7-Bit (MIDI 1.0) / 16-Bit (MIDI 2.0) Value
    public enum ChanVoice7Bit16BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// MIDI 1.0 7-bit Channel Voice Value (0x00..0x7F)
        case midi1(MIDI.UInt7)
        
        /// MIDI 2.0 16-bit Channel Voice Value (0x0000...0xFFFF)
        case midi2(UInt16)
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit16BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let rhsUInt16):
                return lhs.midi2Value == rhsUInt16
                
            }
            
        case .midi1(let lhsUInt7):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt7 == rhs.midi1Value
                
            case .midi1(let rhsUInt7):
                return lhsUInt7 == rhsUInt7
                
            case .midi2(let rhsUInt16):
                return lhs.midi2Value == rhsUInt16
                
            }
            
        case .midi2(let lhsUInt16):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt16 == rhs.midi2Value
                
            case .midi1(let rhsUInt7):
                return lhs.midi1Value == rhsUInt7
                
            case .midi2(let rhsUInt16):
                return lhsUInt16 == rhsUInt16
                
            }
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit16BitValue {
    
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    public var unitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.clamped(to: 0.0...1.0)
            
        case .midi1(let uInt7):
            return MIDI.Event.scaledUnitInterval(from7Bit: uInt7)
            
        case .midi2(let uInt16):
            return MIDI.Event.scaledUnitInterval(from16Bit: uInt16)
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    public var midi1Value: MIDI.UInt7 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled7Bit(fromUnitInterval: interval)
            
        case .midi1(let uInt7):
            return uInt7
            
        case .midi2(let uInt16):
            return MIDI.Event.scaled7Bit(from16Bit: uInt16)
            
        }
        
    }
    
    /// Returns value as a MIDI 2.0 16-bit value, converting if necessary.
    public var midi2Value: UInt16 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled16Bit(fromUnitInterval: interval)
            
        case .midi1(let uInt7):
            return MIDI.Event.scaled16Bit(from7Bit: uInt7)
            
        case .midi2(let uInt16):
            return uInt16
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice7Bit16BitValue {
    
    @propertyWrapper
    public struct Validated: Equatable, Hashable {
        
        public typealias Value = MIDI.Event.ChanVoice7Bit16BitValue
        
        private var value: Value
        
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case .unitInterval(let interval):
                    value = .unitInterval(interval.clamped(to: 0.0...1.0))
                    
                case .midi1:
                    value = newValue
                    
                case .midi2:
                    value = newValue
                }
            }
        }
        
        public init(wrappedValue: Value) {
            self.value = wrappedValue
        }
        
    }
    
}
