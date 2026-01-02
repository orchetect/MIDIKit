//
//  Model.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

@MainActor @Observable public final class Model {
    public internal(set) var receivedEventCount: Int = 0
    
    public init() { }
    
    public func handle(event: MIDIEvent) {
        receivedEventCount += 1
        
        print(event)
    }
}
