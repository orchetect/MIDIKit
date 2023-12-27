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
    
    /// When receiving an RPN or NRPN message without a Data Entry LSB value, or a Data Entry LSB
    /// value of `0`, store the message for a very brief period in order to wait for a follow-up message
    /// containing a non-zero Data Entry LSB and combine the two messages into a single event.
    ///
    /// In the event no follow-up message arrives, a new RPN/NRPN is received, or another MIDI event
    /// type is received, the stored event will be released.
    ///
    /// This is useful when receiving RPN or NRPN messages from a MIDI 1.0 device or endpoint while
    /// MIDIKit is using the new MIDI 2.0 Core MIDI API.
    ///
    /// Note that this may introduce a very small amount of latency only for RPN/NRPN messages that
    /// intentionally do not carry a Data Entry LSB or carry a Data Entry LSB of `0`.
    ///
    /// For details see [this thread](https://github.com/orchetect/MIDIKit/discussions/198).
    public static let bundleRPNAndNRPNDataEntryLSB = MIDIReceiverOptions(rawValue: 1 << 2)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension MIDIReceiverOptions: Sendable { }

#endif
