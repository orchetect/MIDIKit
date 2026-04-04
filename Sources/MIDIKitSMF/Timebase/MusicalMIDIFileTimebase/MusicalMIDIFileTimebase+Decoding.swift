//
//  MusicalMIDIFileTimebase+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension MusicalMIDIFileTimebase {
    public static func decodeMIDI1FileHeader<D: DataProtocol>(
        midi1FileRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: HeaderChunk, trackCount: Int) {
        let (anyHeader, trackCount) = try MIDI1File<AnyMIDIFileTimebase>.HeaderChunk.decode(
            midi1FileRawBytes: midi1FileRawBytes,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        
        switch anyHeader.timebase {
        case let .musical(timebase):
            let header = HeaderChunk(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount)
            
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }

    public static func decodeMIDI1FileHeader<D: DataProtocol>(
        midi1FileRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: HeaderChunk, trackCount: Int, bufferLength: Int) {
        let (anyHeader, trackCount, bufferLength) = try AnyMIDIFileTimebase.decodeMIDI1FileHeader(
            midi1FileRawBytesStream: stream,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        
        switch anyHeader.timebase {
        case let .musical(timebase):
            let header = HeaderChunk(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
            
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }
}
