//
//  MIDIFile DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions {
        /// Allows malformed MIDI files that declare they are format 0 (single track) but contain zero or multiple tracks.
        /// If `false`, this is an error condition and the file is considered malformed.
        public var allowMultiTrackFormat0: Bool
        
        /// Bundle RPN/NRPN CC message sequences into `rpn`/`nrpn` event types.
        /// If `false`, the message sequences will be parsed as individual CC messages.
        public var bundleRPNAndNRPNEvents: Bool
        
        /// The maximum number of events parsed from each track.
        /// If `nil`, all events are parsed.
        public var maxTrackEventCount: Int?
        
        /// The strategy to employ when errors are encountered while decoding tracks.
        public var trackDecodeStrategy: TrackDecodeStrategy
        
        /// Ignore any bytes that may be present past the "end of file".
        /// If `false`, if any extraneous bytes are present it is considered a malformed file and an error is thrown.
        ///
        /// As long the parser has enough bytes to parse the entire body of the file data and it parses without
        /// issue, we can safely ignore any bytes that follow - regardless of what they are (CR, LF, whitespace, or
        /// other random bytes).
        ///
        /// Some MIDI files may have trailing CR/LF bytes or whitespace, either from poorly implemented MIDI file encoders,
        /// or if they were opened in a text editor and resaved by an individual. This parsing option is a
        /// mitigation to work around these type of scenarios.
        ///
        /// See issue for more details: https://github.com/orchetect/MIDIKit/issues/177
        public var ignoreBytesPastEOF: Bool
        
        public init(
            allowMultiTrackFormat0: Bool = true,
            bundleRPNAndNRPNEvents: Bool = true,
            maxTrackEventCount: Int? = nil,
            trackDecodeStrategy: TrackDecodeStrategy = .throwOnError,
            ignoreBytesPastEOF: Bool = true
        ) {
            self.allowMultiTrackFormat0 = allowMultiTrackFormat0
            self.bundleRPNAndNRPNEvents = bundleRPNAndNRPNEvents
            self.maxTrackEventCount = maxTrackEventCount
            self.trackDecodeStrategy = trackDecodeStrategy
            self.ignoreBytesPastEOF = ignoreBytesPastEOF
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }

// MARK: - TrackDecodeStrategy

extension MIDIFile.DecodeOptions {
    public enum TrackDecodeStrategy {
        /// An error is thrown upon the first decoding error encountered.
        ///
        /// This preserves the file's integrity, as the file only successfully decodes if no errors are encountered.
        case throwOnError
        
        /// Tracks that encounter errors while decoding are silently discarded.
        ///
        /// This helps salvage tracks that are fully intact instead of failing to parse the file entirely.
        /// As a result, this option results in data loss in the event there is data corruption in the source file.
        case discardTracksWithErrors
        
        /// Tracks that encounter errors while decoding will contain all events successfully decoded until the error is encountered.
        /// Any events that may occur in the track after the point in which the error occurs are discarded, as there is no way to repair
        /// the remainder of the track's data.
        ///
        /// This helps salvage tracks that are only partially intact instead of failing to parse the file entirely.
        /// As a result, this option results in data loss in the event there is data corruption in the source file.
        case decodePartialTracksWithErrors
    }
}

extension MIDIFile.DecodeOptions.TrackDecodeStrategy: Equatable { }

extension MIDIFile.DecodeOptions.TrackDecodeStrategy: Hashable { }

extension MIDIFile.DecodeOptions.TrackDecodeStrategy: Sendable { }
