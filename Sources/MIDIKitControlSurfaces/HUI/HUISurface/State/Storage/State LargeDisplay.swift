//
//  State LargeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing the Large Text Display (40x2 character matrix)
    public struct LargeDisplay: Equatable, Hashable {
        static let defaultStringComponent = String(
            repeating: HUIConstants.kCharTables.largeDisplay[0x20],
            count: 10
        )
        
        /// Returns the individual string components that make up the large display contents
        public var components = [String](
            repeating: Self.defaultStringComponent,
            count: 8
        ) {
            didSet {
                switch components.count {
                case ...7:
                    components.append(
                        contentsOf: [String](
                            repeating: Self.defaultStringComponent,
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
        
        /// Returns the full concatenated top string
        public var topStringValue: String {
            components[0 ... 3].reduce("", +)
        }
        
        /// Returns the full concatenated bottom string
        public var bottomStringValue: String {
            components[4 ... 7].reduce("", +)
        }
    }
}
