//
//  Track DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.Chunk.Track {
    /// MIDI file track decoding options.
    public struct DecodeOptions {
        /// Bundle RPN/NRPN CC message sequences into `rpn`/`nrpn` event types.
        /// If `false`, the message sequences will be parsed as individual CC messages.
        public var bundleRPNAndNRPNEvents: Bool
        
        /// The maximum number of events parsed from each track.
        /// If `nil`, all events are parsed.
        public var maxEventCount: Int?
        
        /// The strategy to employ when errors are encountered while decoding tracks.
        public var errorStrategy: ErrorStrategy
        
        public init(
            bundleRPNAndNRPNEvents: Bool = true,
            maxEventCount: Int? = nil,
            errorStrategy: ErrorStrategy = .throwOnError
        ) {
            self.bundleRPNAndNRPNEvents = bundleRPNAndNRPNEvents
            self.maxEventCount = maxEventCount
            self.errorStrategy = errorStrategy
        }
    }
}

extension MIDIFile.Chunk.Track.DecodeOptions: Equatable { }

extension MIDIFile.Chunk.Track.DecodeOptions: Hashable { }

extension MIDIFile.Chunk.Track.DecodeOptions: Sendable { }
