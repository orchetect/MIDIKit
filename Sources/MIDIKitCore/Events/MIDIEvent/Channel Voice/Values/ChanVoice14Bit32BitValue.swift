//
//  ChanVoice14Bit32BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Channel Voice 14-Bit (MIDI 1.0) / 32-Bit (MIDI 2.0) Value
    public enum ChanVoice14Bit32BitValue {
        /// Protocol-agnostic unit interval  (`0.0 ... 1.0`)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
    
        /// Protocol-agnostic bipolar unit interval (`-1.0 ... 0.0 ... 1.0`)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case bipolarUnitInterval(Double)
    
        /// MIDI 1.0 14-bit Value (`0x0000 ... 0x3FFF`)
        case midi1(UInt14)
    
        /// MIDI 2.0 32-bit Channel Voice Note Velocity (`0x00000000 ... 0xFFFFFFFF`)
        case midi2(UInt32)
    }
}

extension MIDIEvent.ChanVoice14Bit32BitValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case let .unitInterval(lhsInterval):
            switch rhs {
            case let .unitInterval(rhsInterval):
                lhsInterval == rhsInterval
    
            case let .bipolarUnitInterval(rhsInterval):
                lhs.bipolarUnitIntervalValue == rhsInterval
    
            case let .midi1(rhsUInt14):
                lhs.midi1Value == rhsUInt14
    
            case let .midi2(rhsUInt32):
                lhs.midi2Value == rhsUInt32
            }
    
        case let .bipolarUnitInterval(lhsInterval):
            switch rhs {
            case let .unitInterval(rhsInterval):
                lhs.unitIntervalValue == rhsInterval
    
            case let .bipolarUnitInterval(rhsInterval):
                lhsInterval == rhsInterval
    
            case let .midi1(rhsUInt14):
                lhs.midi1Value == rhsUInt14
    
            case let .midi2(rhsUInt32):
                lhs.midi2Value == rhsUInt32
            }
    
        case let .midi1(lhsUInt14):
            switch rhs {
            case .unitInterval:
                lhsUInt14 == rhs.midi1Value
    
            case .bipolarUnitInterval:
                lhsUInt14 == rhs.midi1Value
    
            case let .midi1(rhsUInt14):
                lhsUInt14 == rhsUInt14
    
            case let .midi2(rhsUInt32):
                lhs.midi2Value == rhsUInt32
            }
    
        case let .midi2(lhsUInt32):
            switch rhs {
            case .unitInterval:
                lhsUInt32 == rhs.midi2Value
    
            case .bipolarUnitInterval:
                lhsUInt32 == rhs.midi2Value
    
            case let .midi1(rhsUInt14):
                lhs.midi1Value == rhsUInt14
    
            case let .midi2(rhsUInt32):
                lhsUInt32 == rhsUInt32
            }
        }
    }
}

extension MIDIEvent.ChanVoice14Bit32BitValue: Hashable { }

extension MIDIEvent.ChanVoice14Bit32BitValue: Sendable { }

extension MIDIEvent.ChanVoice14Bit32BitValue {
    /// Returns value as MIDI protocol-agnostic unit interval, converting if necessary.
    public var unitIntervalValue: Double {
        switch self {
        case let .unitInterval(interval):
            interval.clamped(to: 0.0 ... 1.0)
    
        case let .bipolarUnitInterval(interval):
            MIDIEvent.scaledUnitInterval(fromBipolarUnitInterval: interval)
    
        case let .midi1(uInt14):
            MIDIEvent.scaledUnitInterval(from14Bit: uInt14)
    
        case let .midi2(uInt32):
            MIDIEvent.scaledUnitInterval(from32Bit: uInt32)
        }
    }
    
    /// Returns value as MIDI protocol-agnostic bipolar unit interval, converting if necessary.
    public var bipolarUnitIntervalValue: Double {
        switch self {
        case let .unitInterval(interval):
            interval.bipolarUnitIntervalValue
    
        case let .bipolarUnitInterval(interval):
            interval
    
        case let .midi1(uInt14):
            uInt14.bipolarUnitIntervalValue
    
        case let .midi2(uInt32):
            uInt32.bipolarUnitIntervalValue
        }
    }
    
    /// Returns value as a MIDI 1.0 14-bit value, converting if necessary.
    public var midi1Value: UInt14 {
        switch self {
        case let .unitInterval(interval):
            MIDIEvent.scaled14Bit(fromUnitInterval: interval)
    
        case let .bipolarUnitInterval(interval):
            MIDIEvent.scaled14Bit(fromBipolarUnitInterval: interval)
    
        case let .midi1(uInt14):
            uInt14
    
        case let .midi2(uInt32):
            MIDIEvent.scaled14Bit(from32Bit: uInt32)
        }
    }
    
    /// Returns value as a MIDI 2.0 32-bit value, converting if necessary.
    public var midi2Value: UInt32 {
        switch self {
        case let .unitInterval(interval):
            MIDIEvent.scaled32Bit(fromUnitInterval: interval)
    
        case let .bipolarUnitInterval(interval):
            MIDIEvent.scaled32Bit(fromBipolarUnitInterval: interval)
    
        case let .midi1(uInt14):
            MIDIEvent.scaled32Bit(from14Bit: uInt14)
    
        case let .midi2(uInt32):
            uInt32
        }
    }
}

// MARK: - Validated PropertyWrapper

extension MIDIEvent.ChanVoice14Bit32BitValue {
    @propertyWrapper
    public struct Validated {
        public typealias Value = MIDIEvent.ChanVoice14Bit32BitValue
    
        private var value: Value
    
        public var wrappedValue: Value {
            get {
                value
            }
            set {
                switch newValue {
                case let .unitInterval(interval):
                    value = .unitInterval(interval.clamped(to: 0.0 ... 1.0))

                case let .bipolarUnitInterval(interval):
                    value = .bipolarUnitInterval(interval.clamped(to: -1.0 ... 1.0))

                case .midi1:
                    value = newValue

                case .midi2:
                    value = newValue
                }
            }
        }
    
        public init(wrappedValue: Value) {
            value = wrappedValue
        }
    }
}

extension MIDIEvent.ChanVoice14Bit32BitValue.Validated: Equatable { }

extension MIDIEvent.ChanVoice14Bit32BitValue.Validated: Hashable { }

extension MIDIEvent.ChanVoice14Bit32BitValue.Validated: Sendable { }
