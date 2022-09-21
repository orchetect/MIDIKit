//
//  HUILargeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI large text display 40-character string.
public struct HUILargeDisplayString: HUIStringProtocol, Equatable, Hashable {
    public typealias Element = HUILargeDisplayCharacter
    
    public static let staticCount = 40
    
    @HUIStringCharsValidation<Self>
    public var chars: [Element]
    
    public init() {
        chars = Self.defaultChars
    }
}

// MARK: - Additional Methods

extension HUILargeDisplayString {
    /// Returns the 40-character sequence as four 10-character slices.
    var slices: [[HUILargeDisplayCharacter]] {
        chars.split(every: 10).map { Array($0) }
    }
}
