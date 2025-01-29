/// -------------------------------------------------
/// -------------------------------------------------
/// Borrowed from SwiftASCII 1.1.3 under MIT license.
/// https://github.com/orchetect/SwiftASCII
/// Methods herein are unit tested at their source
/// so no unit tests are necessary.
/// -------------------------------------------------
/// -------------------------------------------------

import Foundation

extension StringProtocol {
    package func convertToASCII() -> String {
        if allSatisfy({ $0.isASCII }) { return String(self) }
        return asciiStringLossy
    }
    
    /// Converts a `String` to ASCII string lossily.
    ///
    /// Performs a lossy conversion, transforming characters to printable ASCII substitutions where
    /// necessary.
    ///
    /// Note that some characters may be transformed to representations that occupy more than one
    /// ASCII character. For example: char 189 (½) will be converted to "1/2"
    ///
    /// Where a suitable character substitution can't reasonably be performed, a question-mark "?"
    /// will be substituted.
    @available(OSX 10.11, iOS 9.0, *)
    var asciiStringLossy: String {
        let transformed = applyingTransform(
            StringTransform("Latin-ASCII"),
            reverse: false
        )
        
        let components = (transformed ?? String(self))
            .components(separatedBy: CharacterSet.asciiPrintable.inverted)
        
        return components.joined(separator: "?")
    }
}

extension CharacterSet {
    /// Includes all ASCII characters, including printable and non-printable (0...127)
    package static let ascii = CharacterSet(
        charactersIn: UnicodeScalar(0) ... UnicodeScalar(127)
    )
    
    /// Includes all printable ASCII characters (32...126)
    package static let asciiPrintable = CharacterSet(
        charactersIn: UnicodeScalar(32) ... UnicodeScalar(126)
    )
    
    /// Includes all ASCII characters, including printable and non-printable (0...31)
    package static let asciiNonPrintable = CharacterSet(
        charactersIn: UnicodeScalar(0) ... UnicodeScalar(31)
    )
    
    /// Includes all extended ASCII characters (128...255)
    package static let asciiExtended = CharacterSet(
        charactersIn: UnicodeScalar(128) ... UnicodeScalar(255)
    )
    
    /// Includes all ASCII characters and extended characters (0...255)
    package static let asciiFull = CharacterSet(
        charactersIn: UnicodeScalar(0) ... UnicodeScalar(255)
    )
}
