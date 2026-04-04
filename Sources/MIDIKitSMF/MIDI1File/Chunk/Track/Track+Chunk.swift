//
//  Track+Chunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDI1File.Track: MIDI1FileChunk {
    public var identifier: MIDI1FileChunkIdentifier { Self.identifier }
    
    public static var identifier: MIDI1FileChunkIdentifier { .track }
}

// MARK: - AnyChunk Static Constructors

extension MIDI1File.AnyChunk {
    /// MIDI file track chunk identifier (`MTrk`).
    public static func track(_ events: [MIDI1File<Timebase>.Track.Event]) -> Self {
        .track(.init(events: events))
    }
    
    /// MIDI file track chunk identifier (`MTrk`).
    @_disfavoredOverload
    public static func track(_ events: some Sequence<MIDI1File<Timebase>.Track.Event>) -> Self {
        .track(.init(events: events))
    }
}
