//
//  MIDI1FileChunkDecodeOptions ErrorStrategy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1FileChunkDecodeOptions {
    public enum ErrorStrategy {
        /// An error is thrown upon the first decoding error encountered.
        ///
        /// This preserves the file's integrity, as the file only successfully decodes if no errors are encountered.
        case throwOnError
        
        /// Tracks that encounter errors while decoding are silently discarded.
        ///
        /// This helps salvage chunks that are fully intact instead of failing to parse the file entirely.
        /// As a result, this option results in data loss in the event there is data corruption in the source file.
        case discardTracksWithErrors
        
        /// The decoder will attempt to continue decoding after any recoverable errors are encountered.
        ///
        /// In each instance where an error occurs during track decoding, if an event is malformed but a suitable
        /// substitution can be made, the substitution will occur and decoding of the track will continue.
        /// If no substitute is appropriate, the malformed event will be discarded instead and decoding of the track will continue.
        ///
        /// If an unrecoverable error is encountered, decoding of the track will end prematurely and the track will
        /// contain all events successfully decoded until the unrecoverable error is encountered.
        /// Any events that may occur in the track after the point in which the error occurs are discarded, as there is no way to repair
        /// the remainder of the track's data.
        ///
        /// This helps salvage chunks that are only partially intact instead of failing to parse the file entirely.
        /// As a result, this option results in data loss in the event there is data corruption in the source file.
        case allowLossyRecovery
    }
}

extension MIDI1FileChunkDecodeOptions.ErrorStrategy: Equatable { }

extension MIDI1FileChunkDecodeOptions.ErrorStrategy: Hashable { }

extension MIDI1FileChunkDecodeOptions.ErrorStrategy: Sendable { }
