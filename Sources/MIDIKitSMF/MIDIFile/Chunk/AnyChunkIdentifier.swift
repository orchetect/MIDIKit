//
//  AnyChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// Type-erased box for a MIDI file chunk identifier.
    public struct AnyChunkIdentifier {
        public let wrapped: any MIDIFileChunkIdentifier
        
        public init(_ wrapped: any MIDIFileChunkIdentifier) {
            self.wrapped = wrapped
        }
    }
}

extension MIDIFile.AnyChunkIdentifier: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped.string == rhs.wrapped.string
    }
}

extension MIDIFile.AnyChunkIdentifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
}

extension MIDIFile.AnyChunkIdentifier: Sendable { }

// MARK: - Init

extension MIDIFile.AnyChunkIdentifier {
    public init?(string: String) {
        switch string {
        case MIDIFile.HeaderChunk.identifier.string:
            wrapped = .track
        case MIDIFile.HeaderChunk.identifier.string:
            wrapped = .header
        default:
            guard let id = MIDIFile.AnyChunk.UnrecognizedChunk.Identifier(string: string) else {
                return nil
            }
            wrapped = id
        }
    }
}

// MARK: - Properties

extension MIDIFile.AnyChunkIdentifier {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is `MTrk`.
    /// For non-track chunks, any 4-character identifier can be used except for `MTrk` or `MThd`.
    public var string: String {
        wrapped.string
    }
}
