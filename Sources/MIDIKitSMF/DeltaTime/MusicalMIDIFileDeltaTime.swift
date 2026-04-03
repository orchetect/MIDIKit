//
//  MusicalMIDIFileDeltaTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

/// Delta time values appropriate for musical MIDI file tracks (SMF1) or clips (SMF2).
public enum MusicalMIDIFileDeltaTime {
    /// Construct delta time of a whole note.
    case noteWhole
    
    /// Construct delta time of a half note.
    case noteHalf
    
    /// Construct delta time of a quarter note.
    case noteQuarter
    
    /// Construct delta time of a 8th note.
    case note8th(triplet: Bool)
    
    /// Construct delta time of a 16th note.
    case note16th(triplet: Bool)
    
    /// Construct delta time of a 32nd note.
    case note32nd(triplet: Bool)
    
    /// Construct delta time of a 64th note.
    case note64th(triplet: Bool)
    
    /// Construct delta time of a 128th note.
    case note128th(triplet: Bool)
    
    /// Construct delta time of a 256th note.
    case note256th(triplet: Bool)
    
    /// Construct delta time in beats (quarter-notes) as a floating-point value.
    /// The `ppq` (ticks per quarter note) value must match the value in the MIDI file header.
    ///
    /// Passing a beat value less than `0.0` is invalid and will always return a delta time of `0`.
    ///
    /// For example:
    /// - `0.25` beats would equal a 16th-note
    /// - `0.5` beats would equal an 8th-note
    /// - `1.5` beats would equal a quarter- & 8th- note tied duration
    /// - `4.0` beats would equal a whole-note (in 4/4 time signature)
    ///
    /// > Warning:
    /// >
    /// > Fractions of a beat that are intended to represent triplet notes should not be expressed
    /// > using this constructor, as floating-point beat values cannot naturally express perfect
    /// > divisions of 3 (0.33333... repeating) and may introduce cumulative rounding errors.
    case beats(_ beats: Double)
    
    case ticks(_ ticks: UInt32)
}

extension MusicalMIDIFileDeltaTime: Equatable {
    // Note that using the `isEqual(to:using)` method is available in the `MIDIFileDeltaTime`
    // protocol default implementation and is a better mechanism for testing equality between instances.
}

extension MusicalMIDIFileDeltaTime: Hashable { }

extension MusicalMIDIFileDeltaTime: Sendable { }

extension MusicalMIDIFileDeltaTime: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noteWhole:
            "Whole Note"
        case .noteHalf:
            "Half Note"
        case .noteQuarter:
            "Quarter Note"
        case let .note8th(triplet):
            "\(triplet ? "Triplet-" : "")8th Note"
        case let .note16th(triplet):
            "\(triplet ? "Triplet-" : "")16th Note"
        case let .note32nd(triplet):
            "\(triplet ? "Triplet-" : "")32nd Note"
        case let .note64th(triplet):
            "\(triplet ? "Triplet-" : "")64th Note"
        case let .note128th(triplet):
            "\(triplet ? "Triplet-" : "")128th Note"
        case let .note256th(triplet):
            "\(triplet ? "Triplet-" : "")256th Note"
        case let .beats(beats):
            "\(beats) Beats"
        case let .ticks(ticks):
            "\(ticks) Ticks"
        }
    }
}

extension MusicalMIDIFileDeltaTime: MIDIFileDeltaTime {
    public typealias Timebase = MusicalMIDIFileTimebase
    
    public func ticks(using timebase: Timebase) -> UInt32 {
        switch self {
        case .noteWhole:
            UInt32(Double(timebase.ticksPerQuarterNote) * 4.0)
        case .noteHalf:
            UInt32(Double(timebase.ticksPerQuarterNote) * 2.0)
        case .noteQuarter:
            UInt32(timebase.ticksPerQuarterNote)
        case let .note8th(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 3.0 : 2.0)).rounded())
        case let .note16th(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 6.0 : 4.0)).rounded())
        case let .note32nd(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 12.0 : 8.0)).rounded())
        case let .note64th(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 24.0 : 16.0)).rounded())
        case let .note128th(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 48.0 : 32.0)).rounded())
        case let .note256th(triplet):
            UInt32((Double(timebase.ticksPerQuarterNote) / (triplet ? 96.0 : 64.0)).rounded())
        case let .beats(beats):
            UInt32((Double(timebase.ticksPerQuarterNote) * beats.clamped(to: 0.0...)).rounded())
        case let .ticks(ticks):
            ticks
        }
    }
}

// MARK: - Static Constructors

extension MusicalMIDIFileDeltaTime {
    // MARK: Defaulted Parameter Overloads
    
    /// Construct delta time of a 8th note.
    public static var note8th: Self { .note8th(triplet: false) }
    
    /// Construct delta time of a 16th note.
    public static var note16th: Self { .note16th(triplet: false) }
    
    /// Construct delta time of a 32nd note.
    public static var note32nd: Self { .note32nd(triplet: false) }
    
    /// Construct delta time of a 64th note.
    public static var note64th: Self { .note64th(triplet: false) }
    
    /// Construct delta time of a 128th note.
    public static var note128th: Self { .note128th(triplet: false) }
    
    /// Construct delta time of a 256th note.
    public static var note256th: Self { .note256th(triplet: false) }
}

// MARK: - Methods

extension MusicalMIDIFileDeltaTime {
    /// Returns the musical beat duration of the delta time using the specified timebase.
    /// Ensure the `ppq` (ticks per quarter note) supplied is the same as used in the MIDI file.
    ///
    /// For example:
    ///
    /// - 480 ticks at 480 ppq == 1 beat == 0.25 beat duration
    /// - 960 ticks at 480 ppq == 2 beats == 0.5 beat duration
    public func quarterNoteBeats(using timebase: Timebase) -> Double {
        let ppq = timebase.ticksPerQuarterNote
        let ticks = ticks(using: timebase)
        guard ppq > 0 else { return 0.0 } // prevent division by zero
        return Double(ticks) / Double(ppq)
    }
}
