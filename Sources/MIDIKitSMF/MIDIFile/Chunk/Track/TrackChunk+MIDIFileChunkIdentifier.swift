//
//  TrackChunk+MIDIFileChunkIdentifier.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// MIDI file track chunk identifier (`MTrk`).
public struct TrackMIDIFileChunkIdentifier: MIDIFileChunkIdentifier {
    public let string: String = "MTrk"
    
    public init() { }
}

// MARK: - Static Constructor

extension MIDIFileChunkIdentifier where Self == TrackMIDIFileChunkIdentifier {
    /// MIDI file track chunk identifier (`MTrk`).
    public static var track: TrackMIDIFileChunkIdentifier {
        TrackMIDIFileChunkIdentifier()
    }
}

// MARK: - AnyChunk Static Constructors

extension MIDIFile.AnyChunk {
    /// MIDI file track chunk identifier (`MTrk`).
    public static func track(_ events: [MIDIFile<Timebase>.TrackChunk.Event]) -> Self {
        .track(.init(events: events))
    }
    
    /// MIDI file track chunk identifier (`MTrk`).
    @_disfavoredOverload
    public static func track(_ events: some Sequence<MIDIFile<Timebase>.TrackChunk.Event>) -> Self {
        .track(.init(events: events))
    }
}
