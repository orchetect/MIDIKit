//
//  MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// 4-character ASCII string identifying the chunk.
///
/// For standard MIDI tracks, this is `MTrk`.
/// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
public protocol MIDI1FileChunkIdentifier: Equatable, Hashable, Sendable {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    var string: String { get }
}

@_documentation(visibility: internal)
@_disfavoredOverload
public func == (lhs: any MIDI1FileChunkIdentifier, rhs: any MIDI1FileChunkIdentifier) -> Bool {
    lhs.string == rhs.string
}
