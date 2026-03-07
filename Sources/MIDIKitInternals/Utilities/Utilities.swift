//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if compiler(<6.2)

import Foundation

/// Backwards-compatible implementation of standard lib method for Xcode 16.
@available(macOS 10.0, iOS 1.0, tvOS 1.0, watchOS 1.0, *)
package func _autoreleasepool<E, Result>(invoking body: () throws(E) -> Result) throws(E) -> Result where E: Error, Result: ~Copyable {
    let result: Swift.Result<Result, E> = autoreleasepool {
        do throws(E) {
            return .success(try body())
        } catch {
            return .failure(error)
        }
    }
    return try result.get()
}

#endif
