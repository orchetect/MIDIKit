//
//  HUISurfaceModel LargeDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurfaceModel {
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
        
        // MARK: - Internal Methods
        
        /// Internal:
        /// Get or set the 8 individual 10-character string slices that make up
        /// the large display contents.
        /// When encoded in a HUI message, these are indexed 0 through 7.
        var slices: HUILargeDisplaySlices {
            get {
                .init(top: top, bottom: bottom)
            }
            set {
                update(mergingFrom: newValue)
            }
        }
        
        /// Internal:
        /// Update HUI string storage by merging string slices atomically.
        ///
        /// - Returns: `true` if characters were different and replaced with new characters.
        @discardableResult
        mutating func update(mergingFrom slices: HUILargeDisplaySlices) -> Bool {
            guard !slices.isEmpty else { return false }
            
            let topSlices = slices.filter { (0 ... 3).contains($0.key) }
            let bottomSlices = slices.filter { (4 ... 7).contains($0.key) }
            
            var isTopDiff = false
            var isBottomDiff = false
            
            // update top
            var newTop = top
            for (sliceIndex, sliceChars) in topSlices {
                if newTop.update(slice: sliceIndex, newChars: sliceChars) {
                    isTopDiff = true
                }
            }
            if isTopDiff { top = newTop }
            
            // update bottom
            var newBottom = bottom
            for (sliceIndex, sliceChars) in bottomSlices {
                if newBottom.update(slice: sliceIndex, newChars: sliceChars) {
                    isBottomDiff = true
                }
            }
            if isBottomDiff { bottom = newBottom }
            
            return isTopDiff || isBottomDiff
        }
        
        /// Internal:
        /// Converts two 40-char large display strings to a dictionary of slices.
        /// Keyed by slice index (`0 ... 7`).
        static func slices(
            top: HUILargeDisplayString,
            bottom: HUILargeDisplayString
        ) -> HUILargeDisplaySlices {
            (top.slices + bottom.slices).enumerated()
                .reduce(into: HUILargeDisplaySlices()) {
                    $0[$1.0.toUInt4] = $1.1
                }
        }
    }
}

/// Display text slices for HUI Large Display.
/// Keyed by slice index (`0 ... 7`).
public typealias HUILargeDisplaySlices = [UInt4: [HUILargeDisplayCharacter]]

extension HUILargeDisplaySlices {
    /// Internal:
    /// Converts two 40-char large display strings to a dictionary of slices.
    /// Keyed by slice index (`0 ... 7`).
    init(
        top: HUILargeDisplayString,
        bottom: HUILargeDisplayString
    ) {
        self = HUISurfaceModel.LargeDisplay.slices(top: top, bottom: bottom)
    }
}
