//
//  ChunkType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    /// MIDI file chunk type.
    public enum ChunkType {
        /// Track chunk.
        case track
        
        /// Other (unrecognized) chunk type.
        case other(identifier: String)
    }
}


extension MIDIFile.ChunkType: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

extension MIDIFile.ChunkType: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension MIDIFile.ChunkType: Sendable { }

extension MIDIFile.ChunkType: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case MIDIFile.Chunk.Track.staticIdentifier:
            self = .track
            
        default:
            guard rawValue.count == 4 else {
                assertionFailure("MIDI file chunk identifiers must be exactly 4 characters.")
                return nil
            }
            self = .other(identifier: rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .track:
            return MIDIFile.Chunk.Track.staticIdentifier
            
        case let .other(identifier):
            guard identifier.count == 4 else {
                assertionFailure("MIDI file chunk identifiers must be exactly 4 characters.")
                return String((identifier + "????").prefix(4))
            }
            return identifier
        }
    }
}
