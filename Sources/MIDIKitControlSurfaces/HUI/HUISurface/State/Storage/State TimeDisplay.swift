//
//  State TimeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing the Main Time Display LCD and surrounding status LEDs.
    public struct TimeDisplay: Equatable, Hashable {
        /// HUI time display string, comprised of 8 digits.
        ///
        /// The time display consists of eight 7-segment displays (called digits). Every digit except the last (rightmost) has the ability to show a trailing decimal point (dot).
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

extension HUISurface.State.TimeDisplay: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.TimeDisplay

    public func state(of param: Param) -> Bool {
        switch param {
        case .timecode:  return timecode
        case .feet:      return feet
        case .beats:     return beats
        case .rudeSolo:  return rudeSolo
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .timecode:  timecode = state
        case .feet:      feet = state
        case .beats:     beats = state
        case .rudeSolo:  rudeSolo = state
        }
    }
}
