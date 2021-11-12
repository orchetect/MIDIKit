/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------
/// Borrowed from [OTCore 1.1.8](https://github.com/orchetect/OTCore) under MIT license.
/// Methods herein are unit tested in OTCore, so no unit tests are necessary in MIDIKit.
/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------

import Foundation

extension String {
    
    /// Wraps a string with double-quotes (`"`)
    @inlinable
    internal var quoted: Self {
        
        "\"\(self)\""
        
    }
    
}

// MARK: - Character filters

extension StringProtocol {
    
    /// **OTCore:**
    /// Returns a string preserving only characters from the CharacterSet and removing all other characters.
    ///
    /// Example:
    ///
    ///     "A string 123".only(.alphanumerics)`
    ///
    public func only(_ characterSet: CharacterSet) -> String {
        
        self.map { characterSet.contains(UnicodeScalar("\($0)")!) ? "\($0)" : "" }
            .joined()
        
    }
    
    /// **OTCore:**
    /// Returns a string preserving only characters from the passed string and removing all other characters.
    public func only(characters: String) -> String {
        
        self.only(CharacterSet(charactersIn: characters))
        
    }
    
    /// **OTCore:**
    /// Returns a string containing only alphanumeric characters and removing all other characters.
    public var onlyAlphanumerics: String {
        
        self.only(.alphanumerics)
        
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed CharacterSet.
    public func removing(_ characterSet: CharacterSet) -> String {
        
        self.components(separatedBy: characterSet)
            .joined()
        
    }
    
    /// **OTCore:**
    /// Returns a string removing all characters from the passed string.
    public func removing(characters: String) -> String {
        
        self.components(separatedBy: CharacterSet(charactersIn: characters))
            .joined()
        
    }
    
}
