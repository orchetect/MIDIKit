//
//  ChanVoice32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Channel Voice 32-Bit (MIDI 2.0) Value
    public enum ChanVoice32BitValue: Hashable {
        
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
        
        /// MIDI 2.0 32-bit Channel Voice Value (0x00000000...0xFFFFFFFF)
        case midi2(UInt32)
        
        // conversion initializers from MIDI 1 value types
        
        /// Returns `.midi2()` case converting from a MIDI 1.0 7-Bit value.
        public static func midi1(sevenBit: MIDI.UInt7) -> Self {
            
            let scaled = MIDI.Event.scaled32Bit(from7Bit: sevenBit)
            return .midi2(scaled)
            
        }
        
        /// Returns `.midi2()` case converting from a MIDI 1.0 14-Bit value.
        public static func midi1(fourteenBit: MIDI.UInt14) -> Self {
            
            let scaled = MIDI.Event.scaled32Bit(from14Bit: fourteenBit)
            return .midi2(scaled)
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice32BitValue: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        
        switch lhs {
        case .unitInterval(let lhsInterval):
            switch rhs {
            case .unitInterval(let rhsInterval):
                return lhsInterval == rhsInterval
                
            case .midi2(let rhsUInt32):
                return lhs.midi2Value == rhsUInt32
                
            }
            
        case .midi2(let lhsUInt32):
            switch rhs {
            case .unitInterval(_):
                return lhsUInt32 == rhs.midi2Value
                
            case .midi2(let rhsUInt32):
                return lhsUInt32 == rhsUInt32
                
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
                        
        case .midi2(let uInt32):
            return MIDI.Event.scaledUnitInterval(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    public var midi1_7BitValue: MIDI.UInt7 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled7Bit(fromUnitInterval: interval)
            
        case .midi2(let uInt32):
            return MIDI.Event.scaled7Bit(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 1.0 14-bit value, converting if necessary.
    public var midi1_14BitValue: MIDI.UInt14 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled14Bit(fromUnitInterval: interval)
            
        case .midi2(let uInt32):
            return MIDI.Event.scaled14Bit(from32Bit: uInt32)
            
        }
        
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    public var midi2Value: UInt32 {
        
        switch self {
        case .unitInterval(let interval):
            return MIDI.Event.scaled32Bit(fromUnitInterval: interval)
            
        case .midi2(let uInt32):
            return uInt32
            
        }
        
    }
    
}

extension MIDI.Event.ChanVoice32BitValue {
    
    @propertyWrapper
    public struct Validated: Equatable, Hashable {
        
        public typealias Value = MIDI.Event.ChanVoice32BitValue
        
        private var value: Value
        
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case .unitInterval(let interval):
                    value = .unitInterval(interval.clamped(to: 0.0...1.0))
                    
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
