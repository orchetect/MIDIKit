//
//  State LargeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Large Text Display (40x2 character matrix)
    public struct LargeDisplay: Equatable, Hashable {
        
        /// Returns the individual string components that make up the large display contents
        var components = [String](repeating: MIDI.HUI.kCharTables.largeDisplay[0x20],
                                  count: 8)
        
        /// Returns the full concatenated top string
        public var topStringValue: String {
            components[0...3].reduce("", +)
        }
        /// Returns the full concatenated bottom string
        public var bottomStringValue: String {
            components[4...7].reduce("", +)
        }
        
    }
    
}
