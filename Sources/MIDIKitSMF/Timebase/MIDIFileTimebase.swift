//
//  MIDIFileTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// MIDI file timebase as described in the MIDI file header.
///
/// At this time, the Standard MIDI File 1.0 spec defines only two timebase types: musical and SMPTE/timecode.
///
/// All MIDI file tracks use ticks as timing resolution - the smallest, most finite unit of time duration possible.
/// The timebase determines how those ticks are used to calculate real wall-time duration.
public protocol MIDIFileTimebase: Equatable, Hashable, Sendable, CustomStringConvertible, CustomDebugStringConvertible
where DeltaTime.Timebase == Self {
    associatedtype DeltaTime: MIDIFileDeltaTime
    
    typealias Header = MIDI1File<Self>.Header
    
    /// Returns the timebase encoded as raw data.
    func midi1FileRawBytes() -> Data
    
    /// Returns the timebase encoded as raw data.
    func midi1FileRawBytes<D: MutableDataProtocol>(as dataType: D.Type) -> D
    
    /// Decode MIDI file header from raw data.
    static func decodeMIDI1FileHeader<D: DataProtocol>(
        midi1FileRawBytes: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Header, trackCount: Int)
    
    /// Decode MIDI file header from raw data stream.
    static func decodeMIDI1FileHeader<D: DataProtocol>(
        midi1FileRawBytesStream stream: D,
        allowMultiTrackFormat0: Bool
    ) throws(MIDIFileDecodeError) -> (header: Header, trackCount: Int, bufferLength: Int)
    
    /// Returns the timebase as a type-erased ``AnyMIDIFileTimebase`` instance.
    func asAnyMIDIFileTimebase() -> AnyMIDIFileTimebase
    
    /// Initialize from raw data.
    init?(midi1FileRawBytes: some DataProtocol)
    
    /// Returns a general-purpose default timebase configuration for the timebase.
    static func `default`() -> Self
}
