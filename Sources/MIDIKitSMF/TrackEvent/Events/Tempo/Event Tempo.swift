//
//  Event Tempo.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import SwiftDataParsing

// MARK: - Tempo

// ------------------------------------
// NOTE: When revising these documentation blocks, they are duplicated in:
//   - MIDIFileEvent enum case (`case keySignature(_:)`, etc.)
//   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
//   - DocC documentation for each MIDIFileEvent type
// ------------------------------------

extension MIDIFileEvent {
    /// Tempo event.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > This value is encoded as microseconds per MIDI quarter-note.
    /// >
    /// > Another way of putting "microseconds per quarter-note" is "24ths of a microsecond per MIDI clock".
    /// > Representing tempos as time per beat instead of beat per time allows absolutely exact long-term
    /// > synchronization with a time-based sync protocol such as SMPTE timecode or MIDI timecode.
    public protocol Tempo: Equatable, Hashable, Sendable where Self: MIDIFileEventPayload {
        /// MIDI file timebase associated with the tempo.
        /// Tempo events have different interpretations depending on the timebase, so `Tempo` must be specialized.
        associatedtype Timebase: MIDIFileTimebase
        
        /// "Microseconds per quarter-note"; the raw encoding value of the tempo event.
        ///
        /// > Standard MIDI File 1.0 Spec:
        /// >
        /// > This value is encoded as microseconds per MIDI quarter-note.
        /// >
        /// > Another way of putting "microseconds per quarter-note" is "24ths of a microsecond per MIDI clock".
        /// > Representing tempos as time per beat instead of beat per time allows absolutely exact long-term
        /// > synchronization with a time-based sync protocol such as SMPTE timecode or MIDI timecode.
        var microsecondsPerQuarter: UInt32 { get set }
        
        /// "Microseconds per quarter-note"; the raw encoding value of the tempo event.
        ///
        /// > Standard MIDI File 1.0 Spec:
        /// >
        /// > This value is encoded as microseconds per MIDI quarter-note.
        /// >
        /// > Another way of putting "microseconds per quarter-note" is "24ths of a microsecond per MIDI clock".
        /// > Representing tempos as time per beat instead of beat per time allows absolutely exact long-term
        /// > synchronization with a time-based sync protocol such as SMPTE timecode or MIDI timecode.
        init(microsecondsPerQuarter: UInt32)
    }
}

// MARK: - Static

extension MIDIFileEvent.Tempo {
    /// The prefix bytes that define the start of the event.
    public static var prefixBytes: [UInt8] { [0xFF, 0x51, 0x03] }
}

// MARK: - MIDIFileEventPayload Default Implementation

extension MIDIFileEvent.Tempo /* : MIDIFileEventPayload */ {
    public static var midiFileEventType: MIDIFileEventType { .tempo }
    
    // `var wrapped` needs to be implemented by the concrete type.
    
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
        let microseconds: UInt32
        do throws(MIDIFileDecodeError) {
            microseconds = try stream.withDataParser { parser throws(MIDIFileDecodeError) in
                // 3-byte preamble
                guard let headerBytes = try? parser.read(bytes: Self.prefixBytes.count),
                      headerBytes.elementsEqual(Self.prefixBytes)
                else {
                    throw .malformed("Tempo does not start with expected bytes.")
                }
                
                do {
                    let byte3 = try UInt32(parser.readByte())
                    let byte4 = try UInt32(parser.readByte())
                    let byte5 = try UInt32(parser.readByte())
                    
                    let readUInt32 = (byte3 << 16)
                        + (byte4 << 8)
                        + byte5
                    
                    return readUInt32
                } catch {
                    throw .malformed("Tempo does not have enough bytes.")
                }
            }
        } catch {
            return .unrecoverableError(error: error)
        }
        
        let newEvent = Self(microsecondsPerQuarter: microseconds)
        
        return .event(
            payload: newEvent,
            byteLength: requiredStreamByteCount
        )
    }
    
    public func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        // FF 51 03 xx xx xx
        // xx xx xx = 3-byte (24-bit) microseconds per MIDI quarter-note
        
        var data = D()
        
        data += Self.prefixBytes
        
        var tempoUInt32 = microsecondsPerQuarter
        data += Array(NSData(bytes: &tempoUInt32, length: 3) as Data)
            .reversed()
        
        return data
    }
    
    // default implementation; each concrete type should override this
    public var midiFileDescription: String {
        "\(microsecondsPerQuarter) ms/qtr"
    }
    
    // default implementation; each concrete type should override this
    public var midiFileDebugDescription: String {
        "Tempo(\(midiFileDescription))"
    }
}
