//
//  LEDState LED.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIVPotDisplay.LEDState {
    /// HUI V-Pot Display LED.
    /// Raw value is the offset from the leftmost LED.
    public enum LED: UInt8, CaseIterable, Equatable, Hashable {
        case L5 = 0x0
        case L4 = 0x1
        case L3 = 0x2
        case L2 = 0x3
        case L1 = 0x4
        case C  = 0x5
        case R1 = 0x6
        case R2 = 0x7
        case R3 = 0x8
        case R4 = 0x9
        case R5 = 0xA
    }
}

// MARK: - Comparable

extension HUIVPotDisplay.LEDState.LED: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - CustomStringConvertible

extension HUIVPotDisplay.LEDState.LED: CustomStringConvertible {
    public var description: String {
        switch self {
        case .L5: return "L5"
        case .L4: return "L4"
        case .L3: return "L3"
        case .L2: return "L2"
        case .L1: return "L1"
        case .C:  return "C"
        case .R1: return "R1"
        case .R2: return "R2"
        case .R3: return "R3"
        case .R4: return "R4"
        case .R5: return "R5"
        }
    }
}

// MARK: - Sendable

extension HUIVPotDisplay.LEDState.LED: Sendable { }

// MARK: - Radius

extension HUIVPotDisplay.LEDState.LED {
    /// Initialize from the LED count from center as an absolute (positive) radius (`0 ... 5`).
    public init?(radius: Int) {
        switch radius {
        case 0: self = .C
        case 1: self = .L1
        case 2: self = .L2
        case 3: self = .L3
        case 4: self = .L4
        case 5: self = .L5
        default: return nil
        }
    }
    
    /// Returns the LED count from center as an absolute (positive) radius (`0 ... 5`).
    public var radius: Int {
        switch self {
        case .C:       return 0
        case .L1, .R1: return 1
        case .L2, .R2: return 2
        case .L3, .R3: return 3
        case .L4, .R4: return 4
        case .L5, .R5: return 5
        }
    }
    
    /// Initialize from the LED count from center as
    /// an absolute (positive) unit interval (`0.0 ... 1.0`).
    public init?(radiusUnitInterval: Double) {
        switch radiusUnitInterval {
        case 0.0 ..< 0.2: self = .C
        case 0.2 ..< 0.4: self = .L1
        case 0.4 ..< 0.6: self = .L2
        case 0.6 ..< 0.8: self = .L3
        case 0.8 ..< 1.0: self = .L4
        case 1.0:         self = .L5
        default:          return nil
        }
    }
    
    /// Returns the LED count from center as an absolute (positive) unit interval (`0.0 ... 1.0`).
    public var radiusUnitInterval: Double {
        Double(radius) / 5
    }
}

// MARK: - Unit Interval

extension HUIVPotDisplay.LEDState.LED {
    /// Initialize from a unit interval (`0.0 ... 1.0`) corresponding
    /// to the nearest LED position from left-to-right.
    /// Value will be clamped.
    public init(position unitInterval: Double) {
        let raw = UInt8((unitInterval * 0xA).clamped(to: 0x0 ... 0xA))
        self = Self(rawValue: raw) ?? .L5
    }
    
    /// Return the LED position from left-to-right as a unit interval (`0.0 ... 1.0`).
    public var unitInterval: Double {
        Double(rawValue) / 0xA
    }
}

// MARK: - Internal Helpers

extension HUIVPotDisplay.LEDState.LED {
    /// Internal:
    /// The lower bound of the LED's position as a fraction of
    /// the overall distance of the unit interval scale.
    var unitIntervalLowerBound: Double {
        Double(rawValue) / 0xB
    }
    
    /// Internal:
    /// The upper bound of the LED's position as a fraction of
    /// the overall distance of the unit interval scale.
    var unitIntervalUpperBound: Double {
        Double(rawValue + 1) / 0xB
    }
}
