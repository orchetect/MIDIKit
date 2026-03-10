//
//  MIDIFile DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions {
        public var bundleRPNAndNRPNEvents: Bool
        public var maxTrackEventCount: Int?
        
        public init(
            bundleRPNAndNRPNEvents: Bool = true,
            maxTrackEventCount: Int? = nil
        ) {
            self.bundleRPNAndNRPNEvents = bundleRPNAndNRPNEvents
            self.maxTrackEventCount = maxTrackEventCount
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }
