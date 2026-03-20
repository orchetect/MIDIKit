//
//  Track+MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.Chunk.Track: MIDIFileChunk {
    public struct Identifier: MIDIFileChunkIdentifier {
        public let string: String = "MTrk"
        
        public init() { }
    }
    
    public var identifier: Identifier { Self.identifier }
    
    public static let identifier: Identifier = .init()
}

// MARK: - Static Constructors

extension MIDIFile.Chunk {
    /// Track: `MTrk` chunk type.
    public static func track(_ events: [MIDIFileEvent]) -> Self {
        .track(.init(events: events))
    }
    
    /// Track: `MTrk` chunk type.
    @_disfavoredOverload
    public static func track(_ events: some Sequence<MIDIFileEvent>) -> Self {
        .track(.init(events: events))
    }
}
