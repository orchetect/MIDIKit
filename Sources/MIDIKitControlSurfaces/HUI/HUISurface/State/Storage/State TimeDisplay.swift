//
//  State TimeDisplay.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing the Main Time Display LCD and surrounding status LEDs
    public struct TimeDisplay: Equatable, Hashable {
        /// Returns the individual string components that make up the full time display `stringValue`
        public var components: [String] = [
            HUIConstants.kCharTables.timeDisplay[0x00], // "0"
            HUIConstants.kCharTables.timeDisplay[0x10], // "0."
            HUIConstants.kCharTables.timeDisplay[0x00], // "0"
            HUIConstants.kCharTables.timeDisplay[0x10], // "0."
            HUIConstants.kCharTables.timeDisplay[0x00], // "0"
            HUIConstants.kCharTables.timeDisplay[0x10], // "0."
            HUIConstants.kCharTables.timeDisplay[0x00], // "0"
            HUIConstants.kCharTables.timeDisplay[0x00]  // "0"
        ] {
            didSet {
                switch components.count {
                case ...7:
                    components.append(
                        contentsOf: [String](
                            repeating: HUIConstants.kCharTables.timeDisplay[0x20],
                            count: 8 - components.count
                        )
                    )
                case 9...:
                    components = Array(components.prefix(8))
                default:
                    break
                }
            }
        }
        
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
