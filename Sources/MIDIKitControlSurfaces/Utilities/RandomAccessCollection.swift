//
//  RandomAccessCollection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension RandomAccessCollection {
    /// Utility
    internal func range(ofOffsets range: ClosedRange<Int>) -> ClosedRange<Index> {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return inIndex ... outIndex
    }
    
    /// Utility
    internal subscript(atOffsets range: ClosedRange<Int>) -> Self.SubSequence {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return self[inIndex ... outIndex]
    }
    
    /// Utility
    internal subscript(atOffset offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
}
