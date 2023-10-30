//
//  MIDIReceiverOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

public struct MIDIReceiverOptions: OptionSet {
    public let rawValue: Int
    
    public static let translateMIDI1NoteOnZeroVelocityToNoteOff = MIDIReceiverOptions(rawValue: 1 << 0)
    public static let filterActiveSensingAndClock = MIDIReceiverOptions(rawValue: 1 << 1)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension MIDIReceiverOptions: Sendable { }

#endif
