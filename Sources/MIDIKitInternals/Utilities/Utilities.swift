//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if compiler(<6.2)

import Foundation

// TODO: This was used in MIDIKitSMF prior to MIDIKit 0.12.0 to avoid large memory usage in the MIDIFile decode procedure, but after the decoding refactor this is not being used and may not be needed

// /// Backwards-compatible implementation of standard lib method for Xcode 16.
// @available(macOS 10.0, iOS 1.0, tvOS 1.0, watchOS 1.0, *)
// @inlinable
// package func autoreleasepool<E, Result>(invoking body: () throws(E) -> Result) throws(E) -> Result where E: Error /* , Result: ~Copyable */ {
//     let result: Swift.Result<Result, E> = Foundation.autoreleasepool {
//         do throws(E) {
//             return .success(try body())
//         } catch {
//             return .failure(error)
//         }
//     }
//     return try result.get()
// }

#endif
