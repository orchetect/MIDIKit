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
    static func initFrom<D: DataProtocol>(
        midi1SMFRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int, bufferLength: Int) {
        let (anyHeader, trackCount, bufferLength) = try AnyMIDI1FileHeaderChunk.initFrom(
            midi1SMFRawBytesStream: stream,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        switch anyHeader.timebase {
        case let .musical(timebase as Timebase):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
            
        case let .smpte(timebase as Timebase):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount, bufferLength: bufferLength)
            
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }
    
    static func initFrom<D: DataProtocol>(
        midi1SMFRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int) {
        let (anyHeader, trackCount) = try AnyMIDI1FileHeaderChunk.initFrom(
            midi1SMFRawBytes: midi1SMFRawBytes,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
        switch anyHeader.timebase {
        case let .musical(timebase as Timebase):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount)
            
        case let .smpte(timebase as Timebase):
            let header = Self(format: anyHeader.format, timebase: timebase, additionalBytes: anyHeader.additionalBytes)
            return (header: header, trackCount: trackCount)
            
        default:
            throw .malformed("Unexpected file header timebase: \(anyHeader.timebase.description).")
        }
    }
}
