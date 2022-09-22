//
//  HUIModel LargeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
    /// State storage representing the Large Text Display (40 x 2 character matrix).
    public struct LargeDisplay: Equatable, Hashable {
        /// Top 40-character character readout.
        public var top: HUILargeDisplayString
        
        /// Bottom 40-character character readout.
        public var bottom: HUILargeDisplayString
        
        init(
            top: HUILargeDisplayString = .init(),
            bottom: HUILargeDisplayString = .init()
        ) {
            self.top = top
            self.bottom = bottom
        }
        
        /// Internal:
        /// Get or set the 8 individual 10-character string slices that make up the large display contents.
        /// When encoded in a HUI message, these are indexed 0 through 7.
        var slices: [[HUILargeDisplayCharacter]] {
            get {
                let topSlices = top.chars.split(every: 10).map { Array($0) }
                let bottomSlices = bottom.chars.split(every: 10).map { Array($0) }
                return topSlices + bottomSlices
            }
            set {
                // validate
                var newValue = newValue
                switch newValue.count {
                case ...7:
                    newValue += [[HUILargeDisplayCharacter]](
                        repeating: .defaultSlice,
                        count: 8 - slices.count
                    )
                case 9...:
                    newValue = Array(slices.prefix(8))
                default:
                    break
                }
                
                // conditionally set only if different
                let newTopChars = newValue[0 ... 3].flatMap { $0 }
                let newBottomChars = newValue[4 ... 7].flatMap { $0 }
                if newTopChars != top.chars {
                    top.chars = newTopChars
                }
                if newBottomChars != bottom.chars {
                    bottom.chars = newBottomChars
                }
            }
        }
    }
}
