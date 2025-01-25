//
//  Test Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

#if !os(watchOS)

func wait(
    expect condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async rethrows {
    let pollingIntervalMS = Int(pollingInterval * TimeInterval(MSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try? await Task.sleep(for: .milliseconds(pollingIntervalMS))
    }
    
    #expect(try await condition(), comment, sourceLocation: sourceLocation)
}

func wait(
    require condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
    let pollingIntervalMS = Int(pollingInterval * TimeInterval(MSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try await Task.sleep(for: .milliseconds(pollingIntervalMS))
    }
    
    try #require(await condition(), comment, sourceLocation: sourceLocation)
}

#endif

/// Use as a condition for individual tests that rely on stable/precise system timing.
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
