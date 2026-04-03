//
//  HeaderChunk+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

extension MIDI1File.HeaderChunk {
    /// Init from MIDI file data stream.
    static func decode<D: DataProtocol>(
        midi1FileRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int, bufferLength: Int) {
        let (anyHeader, trackCount, bufferLength) = try MIDI1File<AnyMIDIFileTimebase>.HeaderChunk.decodeAny(
            midi1FileRawBytesStream: stream,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        
        switch (anyHeader, anyHeader.timebase) {
        case (let header as Self, _): // MIDI1File<AnyMIDIFileTimebase>.HeaderChunk
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
            
        case (_, let .musical(timebase as Timebase)):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
            
        case (_, let .smpte(timebase as Timebase)):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
        
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }
    
    static func decode<D: DataProtocol>(
        midi1FileRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int) {
        let (anyHeader, trackCount) = try MIDI1File<AnyMIDIFileTimebase>.HeaderChunk.decodeAny(
            midi1FileRawBytes: midi1FileRawBytes,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        
        switch (anyHeader, anyHeader.timebase) {
        case (let header as Self, _): // MIDI1File<AnyMIDIFileTimebase>.HeaderChunk
            return (header: header, trackCount: trackCount)
            
        case (_, let .musical(timebase as Timebase)):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount)
            
        case (_, let .smpte(timebase as Timebase)):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount)
            
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }
}
