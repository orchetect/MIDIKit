/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------
/// Borrowed from [OTCore 1.4.1](https://github.com/orchetect/OTCore) under MIT license.
/// Methods herein are unit tested in OTCore, so no unit tests are necessary in MIDIKit.
/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------

#if shouldTestCurrentPlatform

import Foundation

extension Collection {
    /// Splits a `Collection` or `String` into groups of `length` characters, grouping from left-to-right. If `backwards` is true, right-to-left.
    @_disfavoredOverload
    internal func split(
        every: Int,
        backwards: Bool = false
    ) -> [SubSequence] {
        var result: [SubSequence] = []
    
        for i in stride(from: 0, to: count, by: every) {
            switch backwards {
            case true:
                let offsetEndIndex = index(endIndex, offsetBy: -i)
                let offsetStartIndex = index(
                    offsetEndIndex,
                    offsetBy: -every,
                    limitedBy: startIndex
                )
                    ?? startIndex
    
                result.insert(self[offsetStartIndex ..< offsetEndIndex], at: 0)
    
            case false:
                let offsetStartIndex = index(startIndex, offsetBy: i)
                let offsetEndIndex = index(
                    offsetStartIndex,
                    offsetBy: every,
                    limitedBy: endIndex
                )
                    ?? endIndex
    
                result.append(self[offsetStartIndex ..< offsetEndIndex])
            }
        }
    
        return result
    }
}

#endif
