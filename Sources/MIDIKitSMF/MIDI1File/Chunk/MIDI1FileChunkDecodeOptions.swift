//
//  MIDI1FileChunkDecodeOptions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file track decoding options.
public struct MIDI1FileChunkDecodeOptions {
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
        errorStrategy: ErrorStrategy = .allowLossyRecovery
    ) {
        self.bundleRPNAndNRPNEvents = bundleRPNAndNRPNEvents
        self.maxEventCount = maxEventCount
        self.errorStrategy = errorStrategy
    }
}

extension MIDI1FileChunkDecodeOptions: Equatable { }

extension MIDI1FileChunkDecodeOptions: Hashable { }

extension MIDI1FileChunkDecodeOptions: Sendable { }
