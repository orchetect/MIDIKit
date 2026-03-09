//
//  MIDIFile DecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file decoding options.
    public struct DecodeOptions {
        public var bundleParameterNumbers: Bool
        public var maxTrackEventCount: Int?
        
        public init(
            bundleParameterNumbers: Bool = true,
            maxTrackEventCount: Int? = nil
        ) {
            self.bundleParameterNumbers = bundleParameterNumbers
            self.maxTrackEventCount = maxTrackEventCount
        }
    }
}

extension MIDIFile.DecodeOptions: Equatable { }

extension MIDIFile.DecodeOptions: Hashable { }

extension MIDIFile.DecodeOptions: Sendable { }
