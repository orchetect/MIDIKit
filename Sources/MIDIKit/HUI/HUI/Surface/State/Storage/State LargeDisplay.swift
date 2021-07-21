//
//  State LargeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Large Text Display (40x2 character matrix)
    public struct LargeDisplay: Equatable, Hashable {
        
        static let defaultStringComponent = String(repeating: MIDI.HUI.kCharTables.largeDisplay[0x20],
                                                   count: 8)
        
        /// Returns the individual string components that make up the large display contents
        public var components = [String](repeating: Self.defaultStringComponent,
                                         count: 8)
        {
            didSet {
                switch components.count {
                case ...7:
                    components.append(
                        contentsOf: [String](repeating: Self.defaultStringComponent,
                                             count: 8 - components.count)
                    )
                case 9...:
                    components = components.prefix(8).array
                default:
                    break
                }
            }
        }
        
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
