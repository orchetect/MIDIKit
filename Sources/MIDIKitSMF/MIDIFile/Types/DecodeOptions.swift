//
//  DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions {
        /// Allows malformed MIDI files that declare they are format 0 (single track) but contain zero or multiple tracks.
        /// If `false`, this is an error condition and the file is considered malformed.
        public var allowMultiTrackFormat0: Bool
        
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
        
        /// MIDI file track decoding options.
        public var trackDecodeOptions: AnyChunk.Track.DecodeOptions
        
        public init(
            allowMultiTrackFormat0: Bool = true,
            ignoreBytesPastEOF: Bool = true,
            trackDecodeOptions: AnyChunk.Track.DecodeOptions = .init()
        ) {
            self.allowMultiTrackFormat0 = allowMultiTrackFormat0
            self.ignoreBytesPastEOF = ignoreBytesPastEOF
            self.trackDecodeOptions = trackDecodeOptions
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }
