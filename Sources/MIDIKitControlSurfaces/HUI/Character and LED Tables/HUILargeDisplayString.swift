//
//  HUILargeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals

/// HUI large text display 40-character string.
public struct HUILargeDisplayString: HUIString, Equatable, Hashable {
    public typealias Element = HUILargeDisplayCharacter
    
    public static let staticCount = 40
    
    @HUIStringCharsValidation<Self>
    public var chars: [Element]
    
    public init() {
        chars = Self.defaultChars
    }
}

extension HUILargeDisplayString: Sendable { }

// MARK: - Additional Methods

extension HUILargeDisplayString {
    /// Returns the 40-character sequence as four 10-character slices.
    public func slices() -> [[HUILargeDisplayCharacter]] {
        chars.split(every: 10).map { Array($0) }
    }
    
    /// Internal:
    /// Updates a portion of the 40-char string.
    ///
    /// - Parameters:
    ///   - slice: Slice index (`0 ... 3`)
    ///   - newChars: 10 character array
    /// - Returns: `true` if update resulted in a string that is different from the previous string.
    @inlinable @discardableResult
    mutating func update(slice: UInt4, newChars: [Element]) -> Bool {
        guard newChars.count == 10 else { return false }
        guard (0 ... 3).contains(slice) else { return false }
        
        let offset = 10 * slice.intValue
        let range = offset ... offset + 9
        
        if !(chars[range].elementsEqual(newChars)) {
            chars.replaceSubrange(range, with: newChars)
            return true
        } else {
            return false
        }
    }
}
