//
//  HUISurfaceModelState TimeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Main Time Display LCD and surrounding status LEDs.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class TimeDisplay {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.TimeDisplay: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.TimeDisplayStatus
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .timecode: timecode
        case .feet:     feet
        case .beats:    beats
        case .rudeSolo: rudeSolo
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .timecode: timecode = state
        case .feet:     feet = state
        case .beats:    beats = state
        case .rudeSolo: rudeSolo = state
        }
    }
}
