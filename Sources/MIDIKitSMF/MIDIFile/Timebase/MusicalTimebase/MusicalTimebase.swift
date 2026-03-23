//
//  MusicalMIDIFileTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
//internal import MIDIKitInternals

/// Musical MIDI file timebase: Ticks per quarter note (PPQN / PPQ / PPQBase / TPQN).
///
/// Common values: `96`, `120`, `480`, `960` ppq or larger.
/// The larger the number of divisions, the greater the timing resolution.
///
/// When in doubt, a value of `960` or `480` ppq is sufficient for most use cases.
/// Cubase, for example, exports at `480` by default but is user-definable. Logic Pro exports at `960` ppq.
///
/// # Non-Standard (Custom) PPQ Values
///
/// If choosing a custom value, it is crucial to consider evenly divisible sub-divisions
/// when recursively dividing by `2` (8th -> 16th -> 32nd etc..)
/// or by `3` then recursively by `2` (8th triplet -> 16th triplet -> 32nd triplet etc.).
///
/// `480` has accurate timing resolution down to 128th-note durations but will start to
/// introduce aliasing (rounding errors requiring quantization to the nearest tick) at
/// a 256th-note duration.
///
/// | ppq | Note  | Ticks (÷2ⁿ)       | Ticks Triplet (÷3÷2ⁿ⁻¹) |
/// | --- | ----- | ----------------- | ----------------------- |
/// | 480 | 8th   | 240               | 160                     |
/// | 480 | 16th  | 120               | 80                      |
/// | 480 | 32nd  | 60                | 40                      |
/// | 480 | 64th  | 30                | 20                      |
/// | 480 | 128th | 15                | 10                      |
/// | 480 | 256th | 7.5 rounded to 7  | 5                       |
/// | 480 | 512th | 3.75 rounded to 4 | 2.5 rounded to 3        |
///
/// `960` has accurate timing resolution down to 256th-note durations but will start to
/// introduce aliasing at a 512th-note duration.
///
/// | ppq | Note   | Ticks (÷2ⁿ)       | Ticks Triplet (÷3÷2ⁿ⁻¹) |
/// | --- | ------ | ----------------- | ----------------------- |
/// | 960 | 8th    | 480               | 320                     |
/// | 960 | 16th   | 240               | 160                     |
/// | 960 | 32nd   | 120               | 80                      |
/// | 960 | 64th   | 60                | 40                      |
/// | 960 | 128th  | 30                | 20                      |
/// | 960 | 256th  | 15                | 10                      |
/// | 960 | 512th  | 7.5 rounded to 7  | 5                       |
/// | 960 | 1024th | 3.75 rounded to 4 | 2.5 rounded to 3        |
///
/// > Tip:
/// >
/// > Musical timebase is the most common timebase used in MIDI files.
/// >
/// > The alternate timebase (SMPTE timecode) is extraordinarily rare to find and in fact, most
/// > software manufacturers don't support the format. However, it is included in MIDIKit
/// > because it is part of the Standard MIDI File spec.
public struct MusicalMIDIFileTimebase {
    /// The number of ticks per musical quarter-note.
    /// A tick represents the timing resolution - the smallest, most finite unit of time duration possible in a MIDI file track.
    public var ticksPerQuarterNote: UInt16
    
    public init(ticksPerQuarterNote ppq: UInt16) {
        self.ticksPerQuarterNote = ppq
    }
}

extension MusicalMIDIFileTimebase: Equatable { }

extension MusicalMIDIFileTimebase: Hashable { }

extension MusicalMIDIFileTimebase: Identifiable {
    public var id: Self { self }
}

extension MusicalMIDIFileTimebase: Sendable { }

extension MusicalMIDIFileTimebase: CustomStringConvertible {
    public var description: String {
        "Musical: \(ticksPerQuarterNote) ticks per quarter"
    }
}

extension MusicalMIDIFileTimebase: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Timebase(" + description + ")"
    }
}

// MARK: - Static Constructors

extension MIDIFileTimebase where Self == MusicalMIDIFileTimebase {
    public static func `default`() -> MusicalMIDIFileTimebase {
        MusicalMIDIFileTimebase(ticksPerQuarterNote: 960)
    }
        
    /// Musical MIDI file timebase: Ticks per quarter note (PPQN / PPQ / PPQBase / TPQN).
    ///
    /// Common values: `96`, `120`, `480`, `960`.
    /// Can also be a larger value if needed.
    ///
    /// It is recommended to consider evenly divisible sub-divisions when determining this value.
    /// When in doubt, a value of 480 or 960 is sufficient for most use cases.
    /// Cubase, for example, exports at `480` by default but is user-definable.
    ///
    /// > Tip:
    /// >
    /// > This is by far the most common timebase used in MIDI files.
    public static func musical(ticksPerQuarterNote ppq: UInt16) -> Self {
        MusicalMIDIFileTimebase(ticksPerQuarterNote: ppq)
    }
}

extension AnyMIDIFileTimebase {
    /// Musical MIDI file timebase: Ticks per quarter note (PPQN / PPQ / PPQBase / TPQN).
    ///
    /// Common values: `96`, `120`, `480`, `960`.
    /// Can also be a larger value if needed.
    ///
    /// It is recommended to consider evenly divisible sub-divisions when determining this value.
    /// When in doubt, a value of 480 or 960 is sufficient for most use cases.
    /// Cubase, for example, exports at `480` by default but is user-definable.
    ///
    /// > Tip:
    /// >
    /// > This is by far the most common timebase used in MIDI files.
    public static func musical(ticksPerQuarterNote ppq: UInt16) -> Self {
        .musical(MusicalMIDIFileTimebase(ticksPerQuarterNote: ppq))
    }
}

extension MusicalMIDIFileTimebase: MIDIFileTimebase {
    // MARK: - Decoding
    
    public init?(data: some DataProtocol) {
        guard data.count == 2 else {
            return nil
        }
        
        let byte1 = data[atOffset: 0]
        let byte2 = data[atOffset: 1]
        
        let ticks = ((UInt16(byte1) & 0b01111111) << 8) + UInt16(byte2)
        self = .init(ticksPerQuarterNote: ticks)
    }
    
    // MARK: - Encoding
    
    public func rawData() -> Data {
        rawData(as: Data.self)
    }
    
    public func rawData<D: MutableDataProtocol>(as dataType: D.Type) -> D {
        let data = (ticksPerQuarterNote & 0b01111111_11111111)
            .toData(.bigEndian)
        
        return D(data)
    }
    
    // MARK: - AnyMIDIFileTimebase
    
    public var asAnyMIDIFileTimebase: AnyMIDIFileTimebase {
        .musical(self)
    }
}
