//
//  AnyMIDIFileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Type-erased box for a MIDI file chunk identifier.
public struct AnyMIDIFileChunkIdentifier {
    public let wrapped: any MIDIFileChunkIdentifier
    
    public init(_ wrapped: any MIDIFileChunkIdentifier) {
        self.wrapped = wrapped
    }
}

extension AnyMIDIFileChunkIdentifier: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped.string == rhs.wrapped.string
    }
}

extension AnyMIDIFileChunkIdentifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
}

extension AnyMIDIFileChunkIdentifier: Sendable { }

// MARK: - Init

extension AnyMIDIFileChunkIdentifier {
    public init?(string: String) {
        switch string {
        case HeaderMIDIFileChunkIdentifier().string:
            wrapped = .header
        case TrackMIDIFileChunkIdentifier().string:
            wrapped = .track
        default:
            guard let id = UndefinedMIDIFileChunkIdentifier(string: string) else {
                return nil
            }
            wrapped = id
        }
    }
}

// MARK: - Properties

extension AnyMIDIFileChunkIdentifier {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    public var string: String {
        wrapped.string
    }
}
