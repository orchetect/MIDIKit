//
//  MTCMessageType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

public enum MTCMessageType {
    /// MTC Full-Frame Message
    ///
    /// Timecode changed as a result of a full-frame message, which a MTC transmitter will send while not playing back but locating to a new timecode
    case fullFrame
        
    /// MTC Quarter-Frame Message
    ///
    /// Timecode changed as a result of MTC quarter-frame data stream
    case quarterFrame
}
