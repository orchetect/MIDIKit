//
//  Event ChannelPrefix.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import OTCore

// MARK: - ChannelPrefix

extension MIDIFileEvent {
    /// MIDI Channel Prefix event.
    ///
    /// - remark: Standard MIDI File Spec 1.0:
    ///
    /// "The MIDI channel (0-15) contained in this event may be used to associate a MIDI channel with all events which follow, including System Exclusive and meta-events. This channel is "effective" until the next normal MIDI event (which contains a channel) or the next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may help jam several tracks into a format 0 file, keeping their non-MIDI data associated with a track. This capability is also present in Yamaha's ESEQ file format."
    public struct ChannelPrefix: Equatable, Hashable {
        /// Channel (1...16) is stored zero-based (0..15).
        public var channel: UInt4 = 0
        
        // MARK: - Init
        
        public init(channel: UInt4) {
            self.channel = channel
        }
    }
}

extension MIDIFileEvent.ChannelPrefix: MIDIFileEventPayload {
    public static let smfEventType: MIDIFileEventType = .channelPrefix
    
    public init(midi1SMFRawBytes rawBytes: [Byte]) throws {
        guard rawBytes.count == Self.midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Invalid number of bytes. Expected \(Self.midi1SMFFixedRawBytesLength) but got \(rawBytes.count)"
            )
        }
        
        // 3-byte preamble
        guard rawBytes.starts(with: MIDIFile.kEventHeaders[.channelPrefix]!) else {
            throw MIDIFile.DecodeError.malformed(
                "Event does not start with expected bytes."
            )
        }
        
        let readChannel = rawBytes[3]
        
        guard readChannel.isContained(in: 0x0 ... 0xF) else {
            throw MIDIFile.DecodeError.malformed(
                "Channel number is out of bounds: \(readChannel)"
            )
        }
        
        guard let channel = readChannel.toUInt4Exactly else {
            throw MIDIFile.DecodeError.malformed(
                "Value(s) out of bounds."
            )
        }
        
        self.channel = channel
    }
    
    public var midi1SMFRawBytes: [Byte] {
        // FF 20 01 cc
        // cc is channel number (0...15)
        
        MIDIFile.kEventHeaders[.channelPrefix]! + [channel.uInt8Value]
    }
    
    static let midi1SMFFixedRawBytesLength = 4

    public static func initFrom(
        midi1SMFRawBytesStream rawBuffer: Data
    ) throws -> InitFromMIDI1SMFRawBytesStreamResult {
        let requiredData = rawBuffer.prefix(midi1SMFFixedRawBytesLength).bytes

        guard requiredData.count == midi1SMFFixedRawBytesLength else {
            throw MIDIFile.DecodeError.malformed(
                "Unexpected byte length."
            )
        }

        let newInstance = try Self(midi1SMFRawBytes: requiredData)

        return (
            newEvent: newInstance,
            bufferLength: midi1SMFFixedRawBytesLength
        )
    }
    
    public var smfDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "chanPrefix: \(chanString)"
    }

    public var smfDebugDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "ChannelPrefix(\(chanString))"
    }
}
