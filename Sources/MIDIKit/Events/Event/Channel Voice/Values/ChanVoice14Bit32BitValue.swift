//
//  ChanVoice14Bit32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public enum ChanVoice14Bit32BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// Protocol-agnostic bipolar unit interval (-1.0...0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case bipolarUnitInterval(Double)
        
        /// MIDI 1.0 14-bit Value (0x0000...0x3FFF)
        case midi1(MIDI.UInt14)
        
        /// MIDI 2.0 32-bit Channel Voice Note Velocity (0x00000000...0xFFFFFFFF)
        case midi2(UInt32)
        
    }
    
}

extension MIDI.Event.ChanVoice14Bit32BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .bipolarUnitInterval(let rhsInterval):
                return lhs.bipolarUnitIntervalValue == rhsInterval
                
            case .midi1(let rhsUInt14):
                return lhs.midi1Value == rhsUInt14
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .bipolarUnitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhs.unitIntervalValue == rhsInterval
                
            case .bipolarUnitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi1(let rhsUInt14):
                return lhs.midi1Value == rhsUInt14
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .midi1(let lhsUInt14):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt14 == rhs.midi1Value
                
            case .bipolarUnitInterval(_):
                return lhsUInt14 == rhs.midi1Value
                
            case .midi1(let rhsUInt14):
                return lhsUInt14 == rhsUInt14
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .midi2(let lhsUInt32):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt32 == rhs.midi2Value
                
            case .bipolarUnitInterval(_):
                return lhsUInt32 == rhs.midi2Value
                
            case .midi1(let rhsUInt14):
                return lhs.midi1Value == rhsUInt14
                
            case .midi2(let rhsUInt32):
                return lhsUInt32 == rhsUInt32
                
            }
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice14Bit32BitValue {
    
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    @inline(__always)
    public var unitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.clamped(to: 0.0...1.0)
            
        case .bipolarUnitInterval(let interval):
            return MIDI.Event.scaledUnitInterval(fromBipolarUnitInterval: interval)
            
        case .midi1(let uInt14):
            return MIDI.Event.scaledUnitInterval(from14Bit: uInt14)
            
        case .midi2(let uInt32):
            return MIDI.Event.scaledUnitInterval(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as protocol-agnostic bipolar unit interval, converting if necessary.
    @inline(__always)
    public var bipolarUnitIntervalValue: Double {
        
        switch self {
        case .unitInterval(let interval):
            return interval.bipolarUnitIntervalValue
            
        case .bipolarUnitInterval(let interval):
            return interval
            
        case .midi1(let uInt14):
            return uInt14.bipolarUnitIntervalValue
            
        case .midi2(let uInt32):
            return uInt32.bipolarUnitIntervalValue
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 14-bit value, converting if necessary.
    @inline(__always)
    public var midi1Value: MIDI.UInt14 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled14Bit(fromUnitInterval: interval)
            
        case .bipolarUnitInterval(let interval):
            return MIDI.Event.scaled14Bit(fromBipolarUnitInterval: interval)
            
        case .midi1(let uInt14):
            return uInt14
            
        case .midi2(let uInt32):
            return MIDI.Event.scaled14Bit(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    @inline(__always)
    public var midi2Value: UInt32 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled32Bit(fromUnitInterval: interval)
            
        case .bipolarUnitInterval(let interval):
            return MIDI.Event.scaled32Bit(fromBipolarUnitInterval: interval)
            
        case .midi1(let uInt14):
            return MIDI.Event.scaled32Bit(from14Bit: uInt14)
            
        case .midi2(let uInt32):
            return uInt32
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice14Bit32BitValue {
    
    @propertyWrapper
    public struct Validated: Equatable, Hashable {
        
        public typealias Value = MIDI.Event.ChanVoice14Bit32BitValue
        
        @inline(__always)
        private var value: Value
        
        @inline(__always)
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case .unitInterval(let interval):
                    value = .unitInterval(interval.clamped(to: 0.0...1.0))

                case .bipolarUnitInterval(let interval):
                    value = .bipolarUnitInterval(interval.clamped(to: -1.0...1.0))

                case .midi1:
                    value = newValue

                case .midi2:
                    value = newValue
                }
            }
        }
        
        @inline(__always)
        public init(wrappedValue: Value) {
            self.value = wrappedValue
        }
        
    }
    
}
