//
//  TrackChunk DecodeOptions ErrorStrategy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.TrackChunk.DecodeOptions {
    public enum ErrorStrategy {
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

extension MIDIFile.TrackChunk.DecodeOptions.ErrorStrategy: Equatable { }

extension MIDIFile.TrackChunk.DecodeOptions.ErrorStrategy: Hashable { }

extension MIDIFile.TrackChunk.DecodeOptions.ErrorStrategy: Sendable { }
