//
//  MIDIReceiverOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Options for ``MIDIReceiver``.
public struct MIDIReceiverOptions: OptionSet {
    public let rawValue: Int
    
    /// For MIDI 1.0 note-on events, translate a velocity value of 0 to be a note-off event instead.
    public static let translateMIDI1NoteOnZeroVelocityToNoteOff = MIDIReceiverOptions(rawValue: 1 << 0)
    
    /// Filter (remove) active-sensing and clock messages.
    /// This is useful when logging or monitoring incoming MIDI events from MIDI keyboards and devices
    /// that send these messages at a fast rate.
    public static let filterActiveSensingAndClock = MIDIReceiverOptions(rawValue: 1 << 1)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension MIDIReceiverOptions: Sendable { }

#endif
