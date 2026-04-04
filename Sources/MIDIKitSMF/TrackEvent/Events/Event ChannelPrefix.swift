//
//  Event ChannelPrefix.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - ChannelPrefix

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// MIDI Channel Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > The MIDI channel (`0 ... 15`) contained in this event may be used to associate a MIDI
    /// > channel with all events which follow, including System Exclusive and meta-events. This
    /// > channel is "effective" until the next normal MIDI event (which contains a channel) or the
    /// > next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may
    /// > help jam several tracks into a format 0 file, keeping their non-MIDI data associated with
    /// > a track. This capability is also present in Yamaha's ESEQ file format.
    public struct ChannelPrefix {
        /// Channel (`1 ... 16`) is stored zero-based (`0 ... 15`).
        public var channel: UInt4 = 0
        
        // MARK: - Init
        
        public init(channel: UInt4) {
            self.channel = channel
        }
    }
}

extension MIDIFileEvent.ChannelPrefix: Equatable { }

extension MIDIFileEvent.ChannelPrefix: Hashable { }

extension MIDIFileEvent.ChannelPrefix: Sendable { }

// MARK: - Static Constructors

extension MIDIFileEvent {
    /// MIDI Channel Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > The MIDI channel (`0 ... 15`) contained in this event may be used to associate a MIDI
    /// > channel with all events which follow, including System Exclusive and meta-events. This
    /// > channel is "effective" until the next normal MIDI event (which contains a channel) or the
    /// > next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may
    /// > help jam several tracks into a format 0 file, keeping their non-MIDI data associated with
    /// > a track. This capability is also present in Yamaha's ESEQ file format.
    public static func channelPrefix(
        channel: UInt4
    ) -> Self {
        .channelPrefix(
            .init(channel: channel)
        )
    }
}

extension MIDI1File.Track.Event {
    /// MIDI Channel Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > The MIDI channel (`0 ... 15`) contained in this event may be used to associate a MIDI
    /// > channel with all events which follow, including System Exclusive and meta-events. This
    /// > channel is "effective" until the next normal MIDI event (which contains a channel) or the
    /// > next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may
    /// > help jam several tracks into a format 0 file, keeping their non-MIDI data associated with
    /// > a track. This capability is also present in Yamaha's ESEQ file format.
    public static func channelPrefix(
        delta: DeltaTime = .none,
        channel: UInt4
    ) -> Self {
        let event: MIDIFileEvent = .channelPrefix(
            channel: channel
        )
        return Self(delta: delta, event: event)
    }
}

// MARK: - Static

extension MIDIFileEvent.ChannelPrefix {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x20, 0x01] }
}

// MARK: - Encoding

extension MIDIFileEvent.ChannelPrefix: MIDIFileEventPayload {
    public static var midiFileEventType: MIDIFileEventType { .channelPrefix }
    
    public func asMIDIFileEvent() -> MIDIFileEvent {
        .channelPrefix(self)
    }
    
    public static func decode(
        midi1FileRawBytesStream stream: some DataProtocol,
        runningStatus: UInt8?
    ) -> MIDIFileEventDecodeResult<Self> {
        // Step 1: Check required byte count
        let requiredStreamByteCount: Int
        do throws(MIDIFileDecodeError) {
            requiredStreamByteCount = try requiredStreamByteLength(
                availableByteCount: stream.count,
                isRunningStatusPresent: runningStatus != nil
            )
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 2: Parse out required bytes
        let readChannel: UInt8
        do throws(MIDIFileDecodeError) {
            readChannel = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Channel Prefix event does not start with expected bytes.")
                }
                
                let readChannel: UInt8 = try parser.toMIDIFileDecodeError(
                    malformedReason: "Channel Prefix is missing channel byte.",
                    try parser.readByte()
                )
                
                return readChannel
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        // Step 3: Validate and transform values
        let channel: UInt4
        do throws(MIDIFileDecodeError) {
            guard (0x0 ... 0xF).contains(readChannel),
                  let channelUInt4 = readChannel.toUInt4Exactly
            else {
                throw .malformed("Channel Prefix channel number is out of bounds: \(readChannel)")
            }
            
            channel = channelUInt4
        } catch {
            return .recoverableError(
                payload: nil,
                byteLength: requiredStreamByteCount,
                error: error
            )
        }
        
        let newEvent = Self(channel: channel)
        
        return .event(
            payload: newEvent,
            byteLength: requiredStreamByteCount
        )
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 20 01 cc
        // cc is channel number (0...15)
        
        D(Self.prefixBytes + [channel.uInt8Value])
    }
    
    public var midiFileDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "chanPrefix: \(chanString)"
    }

    public var midiFileDebugDescription: String {
        let chanString = channel.uInt8Value.hexString(padTo: 1, prefix: true)

        return "ChannelPrefix(\(chanString))"
    }
}
