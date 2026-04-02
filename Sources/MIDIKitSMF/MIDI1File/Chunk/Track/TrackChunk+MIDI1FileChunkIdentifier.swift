//
//  TrackChunk+MIDI1FileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file track chunk identifier (`MTrk`).
public struct TrackMIDI1FileChunkIdentifier: MIDI1FileChunkIdentifier {
    public let string: String = "MTrk"
    
    public init() { }
}

// MARK: - Static Constructor

extension MIDI1FileChunkIdentifier where Self == TrackMIDI1FileChunkIdentifier {
    /// MIDI file track chunk identifier (`MTrk`).
    public static var track: TrackMIDI1FileChunkIdentifier {
        TrackMIDI1FileChunkIdentifier()
    }
}

// MARK: - AnyChunk Static Constructors

extension MIDI1File.AnyChunk {
    /// MIDI file track chunk identifier (`MTrk`).
    public static func track(_ events: [MIDI1File<Timebase>.TrackChunk.Event]) -> Self {
        .track(.init(events: events))
    }
    
    /// MIDI file track chunk identifier (`MTrk`).
    @_disfavoredOverload
    public static func track(_ events: some Sequence<MIDI1File<Timebase>.TrackChunk.Event>) -> Self {
        .track(.init(events: events))
    }
}
