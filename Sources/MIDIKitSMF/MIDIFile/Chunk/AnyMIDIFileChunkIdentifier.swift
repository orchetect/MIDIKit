//
//  AnyMIDIFileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

public struct AnyMIDIFileChunkIdentifier {
    public let wrapped: any MIDIFileChunkIdentifier
    
    public init(_ wrapped: any MIDIFileChunkIdentifier) {
        self.wrapped = wrapped
    }
}

extension AnyMIDIFileChunkIdentifier: Equatable {
    public static func == (lhs: AnyMIDIFileChunkIdentifier, rhs: AnyMIDIFileChunkIdentifier) -> Bool {
        lhs.wrapped.string == rhs.wrapped.string
    }
}

extension AnyMIDIFileChunkIdentifier: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrapped)
    }
}

extension AnyMIDIFileChunkIdentifier: Sendable { }

extension AnyMIDIFileChunkIdentifier {
    public init?(string: String) {
        switch string {
        case MIDIFile.AnyChunk.Track.identifier.string:
            wrapped = .track
        case MIDIFile.AnyChunk.Header.identifier.string:
            wrapped = .header
        default:
            guard let id = MIDIFile.AnyChunk.UnrecognizedChunk.Identifier(string: string) else {
                return nil
            }
            wrapped = id
        }
    }
}
