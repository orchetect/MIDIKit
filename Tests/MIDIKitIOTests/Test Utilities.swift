/// ---------------------------------------------------------------
/// ---------------------------------------------------------------
/// Borrowed from swift-testing-extensions 0.2.3 under MIT license.
/// https://github.com/orchetect/swift-testing-extensions
/// Methods herein are unit tested at their source so no unit tests
/// are necessary.
/// ---------------------------------------------------------------
/// ---------------------------------------------------------------

import Foundation
import Testing

// ⚠️ NOTE:
//
// This file is duplicated in the MIDIKitSyncTests target.
// Ensure changes here are also reflected there.
//

/// Wait for a boolean condition, failing an expectation if the condition times out without evaluating to `true`.
func wait(
    expect condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async rethrows {
    let timeout = max(timeout, 0.001) // sanitize: clamp
    let pollingInterval = max(pollingInterval, 0.001) // sanitize: clamp
    
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try? await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    #expect(try await condition(), comment, sourceLocation: sourceLocation)
}

/// Wait for a boolean condition, throwing an error if the condition times out without evaluating to `true`.
func wait(
    require condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
    let timeout = max(timeout, 0.001) // sanitize: clamp
    let pollingInterval = max(pollingInterval, 0.001) // sanitize: clamp
    
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    try #require(await condition(), comment, sourceLocation: sourceLocation)
}

/// Use as a condition for individual tests that rely on stable/precise system timing.
///
/// For example:
///
/// ```swift
/// @Test(.enabled(if: isSystemTimingStable())) func foo { }
/// ```
func isSystemTimingStable(
    duration: TimeInterval = 0.1,
    tolerance: TimeInterval = 0.01
) -> Bool {
    let durationUS = UInt32(duration * TimeInterval(USEC_PER_SEC))
    
    let start = Date()
    usleep(durationUS)
    let end = Date()
    let diff = end.timeIntervalSince(start)
    
    let range = (duration - tolerance) ... (duration + tolerance)
    return range.contains(diff)
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration
    /// in seconds.
    ///
    /// If the task is canceled before the time ends,
    /// this function throws `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    static func sleep(seconds: TimeInterval) async throws {
        let intervalNS = UInt64(seconds * TimeInterval(NSEC_PER_SEC))
        try await sleep(nanoseconds: intervalNS)
    }
}
