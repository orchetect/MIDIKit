//
//  State TimeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Main Time Display LCD and surrounding status LEDs
    public struct TimeDisplay: Equatable, Hashable {
        
        /// Returns the individual string components that make up the full time display `stringValue`
        public var components: [String] = [
            MIDI.HUI.kCharTables.timeDisplay[0x00], // "0"
            MIDI.HUI.kCharTables.timeDisplay[0x10], // "0."
            MIDI.HUI.kCharTables.timeDisplay[0x00], // "0"
            MIDI.HUI.kCharTables.timeDisplay[0x10], // "0."
            MIDI.HUI.kCharTables.timeDisplay[0x00], // "0"
            MIDI.HUI.kCharTables.timeDisplay[0x10], // "0."
            MIDI.HUI.kCharTables.timeDisplay[0x00], // "0"
            MIDI.HUI.kCharTables.timeDisplay[0x00]  // "0"
        ]
        
        // LEDs
        public var timecode = false
        public var feet = false
        public var beats = false
        
        public var rudeSolo = false
        
        /// Returns the full time display as a string of digits.
        public var stringValue: String {
            components.reduce("", +)
        }
        
    }
    
}

extension MIDI.HUI.Surface.State.TimeDisplay: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.TimeDisplay

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .timecode:  return timecode
        case .feet:      return feet
        case .beats:     return beats
        case .rudeSolo:  return rudeSolo
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .timecode:  timecode = state
        case .feet:      feet = state
        case .beats:     beats = state
        case .rudeSolo:  rudeSolo = state
        }
        
    }
    
}
