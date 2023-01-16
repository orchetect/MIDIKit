//
//  RandomAccessCollection.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension RandomAccessCollection {
    /// Utility
    @_disfavoredOverload
    public func range(ofOffsets range: ClosedRange<Int>) -> ClosedRange<Index> {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return inIndex ... outIndex
    }
    
    /// Utility
    @_disfavoredOverload
    public subscript(atOffsets range: ClosedRange<Int>) -> Self.SubSequence {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return self[inIndex ... outIndex]
    }
    
    /// Utility
    @_disfavoredOverload
    public subscript(atOffset offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
}
