/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------
/// Borrowed from [OTCore 1.4.1](https://github.com/orchetect/OTCore) under MIT license.
/// Methods herein are unit tested in OTCore, so no unit tests are necessary in MIDIKit.
/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------

import Foundation

extension String {
    /// Wraps a string with double-quotes (`"`)
    @inlinable @_disfavoredOverload
    internal var quoted: Self {
        "\"\(self)\""
    }
}

// MARK: - Character filters

extension StringProtocol {
    /// Returns a string preserving only characters from one or more `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".only(.alphanumerics)`
    ///     "A string 123".only(.letters, .decimalDigits)`
    ///
    @inlinable @_disfavoredOverload
    internal func only(
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
    @inlinable @_disfavoredOverload
    internal func only(characters: String) -> String {
        only(CharacterSet(charactersIn: characters))
    }
    
    /// Returns a string containing only alphanumeric characters and removing all other characters.
    @inlinable @_disfavoredOverload
    internal var onlyAlphanumerics: String {
        only(.alphanumerics)
    }
    
    /// Returns a string removing all characters from the passed `CharacterSet`s.
    ///
    /// Example:
    ///
    ///     "A string 123".removing(.whitespaces)`
    ///     "A string 123".removing(.letters, .decimalDigits)`
    ///
    @inlinable @_disfavoredOverload
    internal func removing(
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
    @inlinable @_disfavoredOverload
    internal func removing(characters: String) -> String {
        components(separatedBy: CharacterSet(charactersIn: characters))
            .joined()
    }
}
