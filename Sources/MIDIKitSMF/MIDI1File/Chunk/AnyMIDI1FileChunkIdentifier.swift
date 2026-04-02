//
//  AnyMIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Type-erased box for a MIDI file chunk identifier.
public struct AnyMIDI1FileChunkIdentifier {
    public let wrapped: any MIDI1FileChunkIdentifier
    
    public init(_ wrapped: any MIDI1FileChunkIdentifier) {
        self.wrapped = wrapped
    }
}

extension AnyMIDI1FileChunkIdentifier: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped.string == rhs.wrapped.string
    }
}

extension AnyMIDI1FileChunkIdentifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
}

extension AnyMIDI1FileChunkIdentifier: Sendable { }

// MARK: - Init

extension AnyMIDI1FileChunkIdentifier {
    public init?(string: String) {
        switch string {
        case HeaderMIDI1FileChunkIdentifier().string:
            wrapped = .header
        case TrackMIDI1FileChunkIdentifier().string:
            wrapped = .track
        default:
            guard let id = UndefinedMIDI1FileChunkIdentifier(string: string) else {
                return nil
            }
            wrapped = id
        }
    }
}

// MARK: - Properties

extension AnyMIDI1FileChunkIdentifier {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    public var string: String {
        wrapped.string
    }
}
