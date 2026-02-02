//
//  TestActor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Dedicated serial actor for objects used in unit tests.
@globalActor actor TestActor {
    static let shared = TestActor()
}
