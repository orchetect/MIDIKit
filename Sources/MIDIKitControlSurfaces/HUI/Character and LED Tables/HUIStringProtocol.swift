//
//  HUIStringProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUIStringProtocol: CustomStringConvertible
    where Self: Equatable & Hashable,
    Element: Equatable & Hashable
{
    associatedtype Element: HUICharacterProtocol
    static var defaultChars: [Element] { get }
    
    /// Fixed (static) char length for the string.
    static var staticCount: Int { get }
    
    // @HUIStringCharsValidation
    /// HUI-encoded characters that make up the string.
    var chars: [Element] { get set }
    
    /// Initialize with empty default string.
    init()
    
    /// Initialize with HUI-encoded characters.
    init(chars: [Element])
    
    /// Initialize from a string.
    /// Characters will be converted or substituted if they
    /// are not contained in ``Element``'s character set.
    /// String will be padded and truncated to the appropriate static length.
    init<S: StringProtocol>(lossy source: S)
    
    /// Return the characters as a concatenated human-readable string.
    var stringValue: String { get }
}

// MARK: - Default Implementation

extension HUIStringProtocol {
    public static var defaultChars: [Element] {
        .init(
            repeating: .default(),
            count: Self.staticCount
        )
    }
    
    public init(chars: [Element]) {
        self.init()
        self.chars = chars
    }
    
    public init<S: StringProtocol>(lossy source: S) {
        self.init()
        
        let encoded: [Element] = source
            .prefix(Self.staticCount)
            .map { Element(String($0)) ?? .unknown() }
        chars = encoded
    }
    
    public var stringValue: String {
        chars.map(\.string).joined()
    }
}

// MARK: - CustomStringConvertible

extension HUIStringProtocol /* : CustomStringConvertible */ {
    public var description: String {
        stringValue
    }
}

// MARK: - Equatable

extension HUIStringProtocol /* : Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.chars == rhs.chars
    }
}

// MARK: - Hashable

extension HUIStringProtocol /* : Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(chars)
    }
}

// MARK: - Validation PropertyWrapper

@propertyWrapper
public struct HUIStringCharsValidation<Str: HUIStringProtocol> {
    private var value: [Str.Element]
    
    public var wrappedValue: [Str.Element] {
        get {
            value
        }
        set {
            if newValue.count != Str.staticCount {
                value = pad(chars: newValue, for: Str.self)
            } else {
                value = newValue
            }
        }
    }
    
    public init(wrappedValue: [Str.Element]) {
        value = pad(chars: wrappedValue, for: Str.self)
    }
}

// MARK: - Utilities

/// Utility:
/// Pads/truncates char array to static char length.
func pad<S: HUIStringProtocol>(
    chars: [S.Element],
    for stringType: S.Type
) -> [S.Element] {
    chars.pad(count: S.staticCount, with: .default())
}
