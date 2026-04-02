//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension FileManager {
    // `FileManager` is thread-safe but doesn't yet conform to Sendable,
    // so we can coerce it to be treated as Sendable.
    private static func getDefaultFileManager() -> @Sendable () -> FileManager { { Self.default } }
    package static var sendableDefault: FileManager { getDefaultFileManager()() }
}

/// Zips two collections, padding the shorter collection with `nil` in order to fit the larger collection if necessary.
package func optionalZip<C1, E1, C2, E2>(
    _ collection1: C1,
    _ collection2: C2
) -> [(E1?, E2?)] where C1: Collection<E1>, C2: Collection<E2> {
    var output: [(E1?, E2?)] = []
    var commonIndex: Int = 0
    
    func c1HasRemainder() -> Bool { commonIndex < collection1.count }
    func c1Index() -> C1.Index? {
        guard c1HasRemainder() else { return nil }
        return collection1.index(collection1.startIndex, offsetBy: commonIndex)
    }
    
    func c2HasRemainder() -> Bool { commonIndex < collection2.count }
    func c2Index() -> C2.Index? {
        guard c2HasRemainder() else { return nil }
        return collection2.index(collection2.startIndex, offsetBy: commonIndex)
    }
    
    while c1HasRemainder() || c2HasRemainder() {
        let element1: E1? = if let index = c1Index() { collection1[index] } else { nil }
        let element2: E2? = if let index = c2Index() { collection2[index] } else { nil }
        output += [(element1, element2)]
        commonIndex += 1
    }
    return output
}

#if compiler(<6.2)

// TODO: This was used in MIDIKitSMF prior to MIDIKit 0.12.0 to avoid large memory usage in the MIDI1File decode procedure, but after the decoding refactor this is not being used and may not be needed

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
