//
//  MIDIFile DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions {
        /// Bundle RPN/NRPN CC message sequences into `rpn`/`nrpn` event types.
        /// If `false`, the message sequences will be parsed as individual CC messages.
        public var bundleRPNAndNRPNEvents: Bool
        
        /// The maximum number of events parsed from each track.
        /// If `nil`, all events are parsed.
        public var maxTrackEventCount: Int?
        
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
            bundleRPNAndNRPNEvents: Bool = true,
            maxTrackEventCount: Int? = nil,
            ignoreBytesPastEOF: Bool = true
        ) {
            self.bundleRPNAndNRPNEvents = bundleRPNAndNRPNEvents
            self.maxTrackEventCount = maxTrackEventCount
            self.ignoreBytesPastEOF = ignoreBytesPastEOF
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }
