//
//  HUICharacter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUICharacter: CustomStringConvertible, CaseIterable, Sendable
where Self: RawRepresentable, RawValue == UInt7 {
    /// Returns the user-facing display string of the character.
    var string: String { get }
    
    /// Initialize from the user-facing display string of the character.
    init?<S: StringProtocol>(_ string: S)
    
    /// Suitable default case for use as a default/neutral character.
    static func `default`() -> Self
    
    /// Suitable default case for use as a substitute for an unknown character.
    static func unknown() -> Self
}

protocol _HUICharacter: HUICharacter {
    /// Internal:
    /// Table of characters. Array index corresponds to raw HUI encoding value.
    static var stringTable: [String] { get }
}

// MARK: - Default Implementation

extension _HUICharacter {
    /// Returns the user-facing display string of the character.
    public var string: String {
        Self.stringTable[Int(rawValue)]
    }
    
    /// Initialize from the user-facing display string of the character.
    public init?(_ string: some StringProtocol) {
        guard let idx = Self.stringTable.firstIndex(of: String(string))
        else { return nil }
        self.init(rawValue: UInt7(idx))
    }
}

// MARK: - CustomStringConvertible

extension HUICharacter /* : CustomStringConvertible */ {
    public var description: String {
        string
    }
}

// MARK: - Conveniences

extension HUICharacter {
    /// Convenience initializer for `UInt8` raw value.
    public init?(rawValue: UInt8) {
        guard let uInt7 = rawValue.toUInt7Exactly else { return nil }
        self.init(rawValue: uInt7)
    }
}

// MARK: - Sequence Category Methods

extension RangeReplaceableCollection where Element: HUICharacter {
    /// Returns the HUI character sequence as a single concatenated string of characters.
    public var stringValue: String {
        map { $0.string }.joined()
    }
    
    /// Internal:
    /// Pad digits array to static count length.
    func pad(count padCount: Int, with pad: Element) -> [Element] {
        let padCount = padCount.clamped(to: 0...)
        
        switch count {
        case ..<padCount:
            return Array(self) + .init(repeating: pad, count: padCount - count)
        case (padCount + 1)...:
            return Array(prefix(padCount))
        default:
            return Array(self)
        }
    }
}
