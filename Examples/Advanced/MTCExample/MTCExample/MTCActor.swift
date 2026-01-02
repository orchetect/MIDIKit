//
//  MTCActor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Dedicated background actor for MTC generator and receiver.
@globalActor public actor MTCActor {
    public static let shared = MTCActor()
}
