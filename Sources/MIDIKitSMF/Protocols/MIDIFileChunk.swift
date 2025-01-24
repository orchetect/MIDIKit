//
//  MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

public protocol MIDIFileChunk: Sendable {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    var identifier: String { get }

    // TODO: add init from raw data, passing in midi header timing info etc.
}
