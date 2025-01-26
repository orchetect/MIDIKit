//
//  HUISurfaceModelState TimeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Main Time Display LCD and surrounding status LEDs.
    public struct TimeDisplay {
        /// HUI time display string, comprised of 8 digits.
        ///
        /// The time display consists of eight 7-segment displays (called digits). Every digit
        /// except the last (rightmost) has the ability to show a trailing decimal point (dot).
        public var timeString: HUITimeDisplayString = .init()
        
        // LEDs
        
        /// Timecode LED.
        public var timecode = false
        
        /// Feet LED.
        public var feet = false
        
        /// Beats LED.
        public var beats = false
        
        /// Rude Solo LED.
        public var rudeSolo = false
    }
}

extension HUISurfaceModelState.TimeDisplay: Equatable { }

extension HUISurfaceModelState.TimeDisplay: Hashable { }

extension HUISurfaceModelState.TimeDisplay: Sendable { }

extension HUISurfaceModelState.TimeDisplay: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.TimeDisplayStatus

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .timecode: return timecode
        case .feet:     return feet
        case .beats:    return beats
        case .rudeSolo: return rudeSolo
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .timecode: timecode = state
        case .feet:     feet = state
        case .beats:    beats = state
        case .rudeSolo: rudeSolo = state
        }
    }
}
