//
//  MusicalTimebase.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
//internal import MIDIKitInternals

extension MIDIFile {
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
    public struct MusicalTimebase {
        /// The number of ticks per musical quarter-note.
        /// A tick represents the timing resolution - the smallest, most finite unit of time duration possible in a MIDI file track.
        public var ticksPerQuarterNote: UInt16
        
        public init(ticksPerQuarterNote ppq: UInt16) {
            self.ticksPerQuarterNote = ppq
        }
    }
}

extension MIDIFile.MusicalTimebase: Equatable { }

extension MIDIFile.MusicalTimebase: Hashable { }

extension MIDIFile.MusicalTimebase: Identifiable {
    public var id: Self { self }
}

extension MIDIFile.MusicalTimebase: Sendable { }

extension MIDIFile.MusicalTimebase: CustomStringConvertible {
    public var description: String {
        "Musical: \(ticksPerQuarterNote) ticks per quarter"
    }
}

extension MIDIFile.MusicalTimebase: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Timebase(" + description + ")"
    }
}

// MARK: - Static Constructors

extension MIDIFile.Timebase where Self == MIDIFile.MusicalTimebase {
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
        MIDIFile.MusicalTimebase(ticksPerQuarterNote: ppq)
    }
}

extension MIDIFile.AnyTimebase {
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
        .musical(MIDIFile.MusicalTimebase(ticksPerQuarterNote: ppq))
    }
}

extension MIDIFile.MusicalTimebase: MIDIFile.Timebase {
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
}
