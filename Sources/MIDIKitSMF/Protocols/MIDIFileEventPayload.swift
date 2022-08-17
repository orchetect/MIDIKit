//
//  MIDIFileEventPayload.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Protocol describing a MIDI event payload for use in `MIDIFileEvent` cases.
public protocol MIDIFileEventPayload {
    /// MIDI File event type.
    static var smfEventType: MIDIFileEventType { get }
    
    /// Initialize from raw event bytes.
    /// Returns nil if data is malformed or cannot otherwise be used to construct the event.
    init(midi1SMFRawBytes: [Byte]) throws
    
    /// Raw data for the event.
    var midi1SMFRawBytes: [Byte] { get }
    
    /// Returns the new event and MIDI file buffer length (number of bytes).
    typealias InitFromMIDI1SMFRawBytesStreamResult = (newEvent: Self, bufferLength: Int)
    
    /// If it is possible to initialize a new instance of this event from the head of the data buffer, a new instance will be returned along with the byte length traversed from the buffer.
    static func initFrom(midi1SMFRawBytesStream rawBuffer: Data) throws
        -> InitFromMIDI1SMFRawBytesStreamResult
    
    /// Description for the event in a MIDI file context.
    var smfDescription: String { get }
    
    /// Debug description for the event in a MIDI file context.
    var smfDebugDescription: String { get }
}

extension MIDIFileEventPayload /* : CustomStringConvertible, CustomDebugStringConvertible */ {
    public var description: String { smfDescription }
    
    public var debugDescription: String { smfDebugDescription }
}
