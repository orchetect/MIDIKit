//
//  Header+Decoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

extension MIDI1File.Header {
    /// Init from MIDI file header data.
    static func decode<D: DataProtocol>(
        midi1FileRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int) {
        try Timebase.decodeMIDI1FileHeader(
            midi1FileRawBytes: midi1FileRawBytes,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
    }
    
    /// Init from MIDI file data stream.
    static func decode<D: DataProtocol>(
        midi1FileRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Self, trackCount: Int, bufferLength: Int) {
        try Timebase.decodeMIDI1FileHeader(
            midi1FileRawBytesStream: stream,
            allowMultiTrackFormat0: allowMultiTrackFormat0
        )
    }
}
