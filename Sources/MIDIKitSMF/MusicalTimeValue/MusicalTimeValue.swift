//
//  MusicalTimeValue.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Represents a musical time value (bar, beat, beat division, and ticks).
///
/// Often displayed in a DAW or sequencer.
/// Provides conversion methods and string output.
public struct MusicalTimeValue {
    /// Bar number time component. Zero-based.
    public var bar: Int
    
    /// Beat number time component. The beat within the current bar. Zero-based.
    public var beat: Int
    
    /// Beat subdivision time component. Zero-based.
    public var beatDivision: Int
    
    /// Remaining ticks time component. Ticks elapsed since the beat division. Zero-based.
    public var ticks: Int
    
    /// Beats per bar property.
    public let beatsPerBar: Int
    
    /// Divisions per beat property.
    public let divisionsPerBeat: Int
    
    /// PPQ (ticks per beat) property.
    public let ppq: Int
    
    /// Time value sign. Returns `true` if time value is a negative interval.
    public var isNegative: Bool
    
    /// Initialize using discrete musical time components (bar, beat, beat division, ticks) at a
    /// given PPQ.
    ///
    /// If the time is negative, use absolute (positive) discrete values but pass ``isNegative`` as `true`.
    ///
    /// Subdividing a beat into time unit larger than ticks is possible by specifying a number
    /// greater than 0 for ``divisionsPerBeat``.
    ///
    /// The maximum value of the ticks component is ``ppq`` `/` ``divisionsPerBeat``. In the event
    /// that ``divisionsPerBeat`` `== 0` then ``beatDivision`` is ignored and the maximum number of
    /// ticks is simply equal to the ``ppq``.
    public init(
        bar: Int,
        beat: Int,
        beatDivision: Int,
        ticks: Int,
        beatsPerBar: Int = 4,
        divisionsPerBeat: Int = 0,
        ppq: Int = 480,
        isNegative: Bool = false
    ) {
        self.bar = bar
        self.beat = beat
        self.beatDivision = beatDivision
        self.ticks = ticks
        self.beatsPerBar = beatsPerBar.clamped(to: 1...)
        self.divisionsPerBeat = divisionsPerBeat.clamped(to: 0...)
        self.ppq = ppq.clamped(to: 1...)
        self.isNegative = isNegative
    }
    
    /// Initialize using a total number of elapsed ticks (positive or negative) at a given PPQ.
    /// Uses a static time signature.
    ///
    /// Subdividing a beat into time unit larger than ticks is possible by specifying a number
    /// greater than 0 for ``divisionsPerBeat``.
    ///
    /// The maximum value of the ticks component is ``ppq`` `/` ``divisionsPerBeat``. In the event
    /// that ``divisionsPerBeat`` `== 0` then ``beatDivision`` is ignored and the maximum number of
    /// ticks is simply equal to the ``ppq``.
    public init(
        elapsedTicks: Int,
        beatsPerBar: Int = 4,
        divisionsPerBeat: Int = 4,
        ppq: Int
    ) {
        isNegative = elapsedTicks < 0
        
        // sanitize inputs
        let elapsedTicks = abs(elapsedTicks)
        let beatsPerBar = beatsPerBar.clamped(to: 1...)
        let divisionsPerBeat = divisionsPerBeat.clamped(to: 0...)
        let ppq = ppq.clamped(to: 1...)
        
        // store parameters
        self.beatsPerBar = beatsPerBar
        self.divisionsPerBeat = divisionsPerBeat
        self.ppq = ppq
        
        // calculate
        let ticksPerBar = beatsPerBar * ppq
        bar = elapsedTicks / ticksPerBar
        let barsTicks = bar * ticksPerBar
        let beatsTicks = elapsedTicks - barsTicks
        beat = beatsTicks / ppq
        let beatDivisionTicks = beatsTicks - (beat * ppq)
        if divisionsPerBeat == 0 {
            beatDivision = 0
            ticks = beatsTicks % ppq
        } else {
            beatDivision = beatDivisionTicks / (ppq / divisionsPerBeat)
            let ticksPerDivision = ppq / divisionsPerBeat
            ticks = beatsTicks % ticksPerDivision
        }
    }
    
    /// Returns total elapsed ticks.
    /// Uses a static time signature.
    ///
    /// The maximum value of the ticks component is ``ppq`` `/` ``divisionsPerBeat``. In the event
    /// that ``divisionsPerBeat`` `== 0` then ``beatDivision`` is ignored and the maximum number of
    /// ticks is simply equal to the ``ppq``.
    public func elapsedTicks() -> Int {
        // calculate
        let ticksPerBar = beatsPerBar * ppq
        var out = (bar * ticksPerBar) + (beat * ppq)
        if divisionsPerBeat > 0 {
            let ticksPerDivision = ppq / divisionsPerBeat
            out += beatDivision * ticksPerDivision
        }
        out += ticks
        
        return isNegative ? -out : out
    }
    
    /// Returns number of elapsed beats as a floating-point number indicating number of beats +
    /// fraction of a beat.
    public func elapsedBeats() -> Double {
        let wholeBeats = Double((bar * beatsPerBar) + beat)
        let out = wholeBeats + (Double(ticksWithoutDivisions()) / Double(ppq))
        return isNegative ? -out : out
    }
    
    /// Returns flattened ticks by reducing the beat divisions.
    /// If ``divisionsPerBeat`` == 0, then this value is identical to ``ticks``.
    public func ticksWithoutDivisions() -> Int {
        if divisionsPerBeat == 0 {
            return ticks
        } else {
            let ticksPerDivision = ppq / divisionsPerBeat
            let combinedTicks = (beatDivision * ticksPerDivision) + ticks
            return combinedTicks
        }
    }
    
    /// Returns a display string with bar, beat, division, and ticks.
    /// (ie: "14 2 1 0")
    public func stringValue(delimiter: String = " ", forceBeatDivision: Bool = false) -> String {
        isNegative ? "-" : "" +
        (
            divisionsPerBeat > 0 || forceBeatDivision
                ? [bar, beat, beatDivision, ticks]
                : [bar, beat, ticks]
        )
        .map { String($0) }
        .joined(separator: delimiter)
    }
}

extension MusicalTimeValue: CustomStringConvertible {
    public var description: String {
        stringValue()
    }
}

extension MusicalTimeValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.elapsedBeats() == rhs.elapsedBeats()
    }
}

extension MusicalTimeValue: Hashable { }

extension MusicalTimeValue: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.elapsedBeats() < rhs.elapsedBeats()
    }
}
