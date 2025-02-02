//
//  ChanVoice7Bit16BitValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIEvent {
    /// Channel Voice 7-Bit (MIDI 1.0) / 16-Bit (MIDI 2.0) Value
    public enum ChanVoice7Bit16BitValue {
        /// Protocol-agnostic unit interval (`0.0 ... 1.0`)
        /// Scaled automatically depending on MIDI protocol (1.0/2.0) in use.
        case unitInterval(Double)
    
        /// MIDI 1.0 7-bit Channel Voice Value (`0x00 ... 0x7F`)
        case midi1(UInt7)
    
        /// MIDI 2.0 16-bit Channel Voice Value (`0x0000 ... 0xFFFF`)
        case midi2(UInt16)
    }
}

extension MIDIEvent.ChanVoice7Bit16BitValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case let .unitInterval(lhsInterval):
            switch rhs {
            case let .unitInterval(rhsInterval):
                lhsInterval == rhsInterval
    
            case let .midi1(rhsUInt7):
                lhs.midi1Value == rhsUInt7
    
            case let .midi2(rhsUInt16):
                lhs.midi2Value == rhsUInt16
            }
    
        case let .midi1(lhsUInt7):
            switch rhs {
            case .unitInterval:
                lhsUInt7 == rhs.midi1Value
    
            case let .midi1(rhsUInt7):
                lhsUInt7 == rhsUInt7
    
            case let .midi2(rhsUInt16):
                lhs.midi2Value == rhsUInt16
            }
    
        case let .midi2(lhsUInt16):
            switch rhs {
            case .unitInterval:
                lhsUInt16 == rhs.midi2Value
    
            case let .midi1(rhsUInt7):
                lhs.midi1Value == rhsUInt7
    
            case let .midi2(rhsUInt16):
                lhsUInt16 == rhsUInt16
            }
        }
    }
}

extension MIDIEvent.ChanVoice7Bit16BitValue: Hashable { }

extension MIDIEvent.ChanVoice7Bit16BitValue: Sendable { }

extension MIDIEvent.ChanVoice7Bit16BitValue {
    /// Returns value as protocol-agnostic unit interval, converting if necessary.
    public var unitIntervalValue: Double {
        switch self {
        case let .unitInterval(interval):
            interval.clamped(to: 0.0 ... 1.0)
    
        case let .midi1(uInt7):
            MIDIEvent.scaledUnitInterval(from7Bit: uInt7)
    
        case let .midi2(uInt16):
            MIDIEvent.scaledUnitInterval(from16Bit: uInt16)
        }
    }
    
    /// Returns value as a MIDI 1.0 7-bit value, converting if necessary.
    public var midi1Value: UInt7 {
        switch self {
        case let .unitInterval(interval):
            MIDIEvent.scaled7Bit(fromUnitInterval: interval)
    
        case let .midi1(uInt7):
            uInt7
    
        case let .midi2(uInt16):
            MIDIEvent.scaled7Bit(from16Bit: uInt16)
        }
    }
    
    /// Returns value as a MIDI 2.0 16-bit value, converting if necessary.
    public var midi2Value: UInt16 {
        switch self {
        case let .unitInterval(interval):
            MIDIEvent.scaled16Bit(fromUnitInterval: interval)
    
        case let .midi1(uInt7):
            MIDIEvent.scaled16Bit(from7Bit: uInt7)
    
        case let .midi2(uInt16):
            uInt16
        }
    }
}

// MARK: - Validated PropertyWrapper

extension MIDIEvent.ChanVoice7Bit16BitValue {
    @propertyWrapper
    public struct Validated {
        public typealias Value = MIDIEvent.ChanVoice7Bit16BitValue
    
        private var value: Value
    
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
    
        public init(wrappedValue: Value) {
            value = wrappedValue
        }
    }
}

extension MIDIEvent.ChanVoice7Bit16BitValue.Validated: Equatable { }

extension MIDIEvent.ChanVoice7Bit16BitValue.Validated: Hashable { }

extension MIDIEvent.ChanVoice7Bit16BitValue.Validated: Sendable { }
