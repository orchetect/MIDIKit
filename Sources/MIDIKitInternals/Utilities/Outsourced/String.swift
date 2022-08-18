/// ----------------------------------------------
/// ----------------------------------------------
/// /OTCore/Extensions/Swift/String.swift
/// /OTCore/Extensions/Foundation/String and CharacterSet.swift
///
/// Borrowed from OTCore 1.4.1 under MIT license.
/// https://github.com/orchetect/OTCore
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// ----------------------------------------------
/// ----------------------------------------------

import Foundation

// ---------------------------------------------
// MARK: - /OTCore/Extensions/Swift/String.swift
// ---------------------------------------------

extension String {
    /// Wraps a string with double-quotes (`"`)
    @_disfavoredOverload
    public var quoted: Self {
        "\"\(self)\""
    }
}

// MARK: - String functional append constants

extension String {
    /// Returns a new String appending a newline character to the end.
    @_disfavoredOverload
    public var newLined: Self {
        self + "\n"
    }
    
    /// Returns a new String appending a tab character to the end.
    @_disfavoredOverload
    public var tabbed: Self {
        self + "\t"
    }
    
    /// Appends a newline character to the end of the string.
    @_disfavoredOverload
    public mutating func newLine() {
        self += "\n"
    }
    
    /// Appends a tab character to the end of the string.
    @_disfavoredOverload
    public mutating func tab() {
        self += "\t"
    }
}

extension Substring {
    /// Returns a new String appending a newline character to the end.
    @_disfavoredOverload
    public var newLined: String {
        String(self) + "\n"
    }
    
    /// Returns a new String appending a tab character to the end.
    @_disfavoredOverload
    public var tabbed: String {
        String(self) + "\t"
    }
}

// -------------------------------------------------------------------
// MARK: - /OTCore/Extensions/Foundation/String and CharacterSet.swift
// -------------------------------------------------------------------

// MARK: - Character filters

extension StringProtocol {
    /// Returns a string preserving only characters from one or more `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".only(.alphanumerics)`
    ///     "A string 123".only(.letters, .decimalDigits)`
    ///
    @_disfavoredOverload
    public func only(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> String {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet) { $0.formUnion($1) }
    
        return unicodeScalars
            .filter { mergedCharacterSet.contains($0) }
            .map { "\($0)" }
            .joined()
    }
    
    /// Returns a string preserving only characters from the passed string and removing all other characters.
    @_disfavoredOverload
    public func only(characters: String) -> String {
        only(CharacterSet(charactersIn: characters))
    }
    
    /// Returns a string containing only alphanumeric characters and removing all other characters.
    @_disfavoredOverload
    public var onlyAlphanumerics: String {
        only(.alphanumerics)
    }
    
    /// Returns a string removing all characters from the passed `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".removing(.whitespaces)`
    ///     "A string 123".removing(.letters, .decimalDigits)`
    ///
    @_disfavoredOverload
    public func removing(
        _ characterSet: CharacterSet,
        _ characterSets: CharacterSet...
    ) -> String {
        let mergedCharacterSet = characterSets.isEmpty
            ? characterSet
            : characterSets.reduce(into: characterSet) { $0.formUnion($1) }
    
        return components(separatedBy: mergedCharacterSet)
            .joined()
    }
    
    /// Returns a string removing all characters from the passed string.
    @_disfavoredOverload
    public func removing(characters: String) -> String {
        components(separatedBy: CharacterSet(charactersIn: characters))
            .joined()
    }
}
