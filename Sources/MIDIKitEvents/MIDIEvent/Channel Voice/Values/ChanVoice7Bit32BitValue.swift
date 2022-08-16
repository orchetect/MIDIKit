//
//  ChanVoice7Bit32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice 7-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value.
    public enum ChanVoice7Bit32BitValue: Hashable {
        /// Protocol-agnostic unit interval (0.0...1.0)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
    
        /// MIDI 1.0 7-bit Channel Voice Value (0x00..0x7F)
        case midi1(UInt7)
    
        /// MIDI 2.0 32-bit Channel Voice Value (0x00000000...0xFFFFFFFF)
        case midi2(UInt32)
    }
}

extension MIDIEvent.ChanVoice7Bit32BitValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case let .unitInterval(lhsInterval):
            switch rhs {
            case let .unitInterval(rhsInterval):
                return lhsInterval == rhsInterval
    
            case let .midi1(rhsUInt7):
                return lhs.midi1Value == rhsUInt7
    
            case let .midi2(rhsUInt32):
                return lhs.midi2Value == rhsUInt32
            }
    
        case let .midi1(lhsUInt7):
            switch rhs {
            case .unitInterval:
                return lhsUInt7 == rhs.midi1Value
    
            case let .midi1(rhsUInt7):
                return lhsUInt7 == rhsUInt7
    
            case let .midi2(rhsUInt32):
                return lhs.midi2Value == rhsUInt32
            }
    
        case let .midi2(lhsUInt32):
            switch rhs {
            case .unitInterval:
                return lhsUInt32 == rhs.midi2Value
    
            case let .midi1(rhsUInt7):
                return lhs.midi1Value == rhsUInt7
    
            case let .midi2(rhsUInt32):
                return lhsUInt32 == rhsUInt32
            }
        }
    }
}

extension MIDIEvent.ChanVoice7Bit32BitValue {
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    @inline(__always)
    public var unitIntervalValue: Double {
        switch self {
        case let .unitInterval(interval):
            return interval.clamped(to: 0.0 ... 1.0)
    
        case let .midi1(uInt7):
            return MIDIEvent.scaledUnitInterval(from7Bit: uInt7)
    
        case let .midi2(uInt32):
            return MIDIEvent.scaledUnitInterval(from32Bit: uInt32)
        }
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    @inline(__always)
    public var midi1Value: UInt7 {
        switch self {
        case let .unitInterval(interval):
            return MIDIEvent.scaled7Bit(fromUnitInterval: interval)
    
        case let .midi1(uInt7):
            return uInt7
    
        case let .midi2(uInt32):
            return MIDIEvent.scaled7Bit(from32Bit: uInt32)
        }
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    @inline(__always)
    public var midi2Value: UInt32 {
        switch self {
        case let .unitInterval(interval):
            return MIDIEvent.scaled32Bit(fromUnitInterval: interval)
    
        case let .midi1(uInt7):
            return MIDIEvent.scaled32Bit(from7Bit: uInt7)
    
        case let .midi2(uInt32):
            return uInt32
        }
    }
}

extension MIDIEvent.ChanVoice7Bit32BitValue {
    @propertyWrapper
    public struct Validated: Equatable, Hashable {
        public typealias Value = MIDIEvent.ChanVoice7Bit32BitValue
    
        @inline(__always)
        private var value: Value
    
        @inline(__always)
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case let .unitInterval(interval):
                    value = .unitInterval(interval.clamped(to: 0.0 ... 1.0))
    
                case .midi1:
                    value = newValue
    
                case .midi2:
                    value = newValue
                }
            }
        }
    
        @inline(__always)
        public init(wrappedValue: Value) {
            value = wrappedValue
        }
    }
}
