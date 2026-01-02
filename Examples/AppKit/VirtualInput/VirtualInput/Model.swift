//
//  Model.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

public final class Model: Sendable {
    public init() { }
    
    public func handle(event: MIDIEvent) {
        print(event)
    }
}
