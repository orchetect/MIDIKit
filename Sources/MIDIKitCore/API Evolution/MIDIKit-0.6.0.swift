//
//  MIDIKit-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

// NOTE: This is not by any means exhaustive, as nearly every symbol had namespace changes from 0.5.x -> 0.6.0 but the most common symbols are covered here to help guide code migration.

@available(
    *, deprecated,
    message: "💡 The MIDI namespace has been removed as of MIDIKit 0.6.0. First-generation nested symbols have adopted a MIDI prefix instead. For example: MIDI.Event has become MIDIEvent, MIDI.IO.Manager has become MIDIManager."
)
public enum MIDI {
    // MARK: Types
    
    public typealias UInt4 = MIDIKitCore.UInt4
    public typealias UInt7 = MIDIKitCore.UInt7
    public typealias UInt9 = MIDIKitCore.UInt9
    public typealias UInt14 = MIDIKitCore.UInt14
    public typealias UInt25 = MIDIKitCore.UInt25
    
    @available(*, unavailable, renamed: "UInt8")
    public typealias Byte = UInt8
    
    @available(*, unavailable, renamed: "UInt4")
    public typealias Nibble = UInt4
    
    public typealias UMPWord = MIDIKitCore.UMPWord
    
    // MARK: Event
    @available(
        *, unavailable,
        message: "The `MIDI.Event` namespace has been removed and first-generation nested types have been renamed `MIDIEvent.NoteOn`, `MIDIEvent.NoteOff`, etc."
    )
    public enum Event {
        case noteOn(Note.On)
        case noteOff(Note.Off)
        case noteCC(Note.CC)
        case notePitchBend(Note.PitchBend)
        case notePressure(Note.Pressure)
        case noteManagement(Note.Management)
        case cc(CC)
        case programChange(ProgramChange)
        case pitchBend(PitchBend)
        case pressure(Pressure)
        case sysEx7(SysEx7)
        case universalSysEx7(UniversalSysEx7)
        case sysEx8(SysEx8)
        case universalSysEx8(UniversalSysEx8)
        case timecodeQuarterFrame(TimecodeQuarterFrame)
        case songPositionPointer(SongPositionPointer)
        case songSelect(SongSelect)
        case unofficialBusSelect(UnofficialBusSelect)
        case tuneRequest(TuneRequest)
        case timingClock(TimingClock)
        case start(Start)
        case `continue`(Continue)
        case stop(Stop)
        case activeSensing(ActiveSensing)
        case systemReset(SystemReset)
        case noOp(NoOp)
        case jrClock(JRClock)
        case jrTimestamp(JRTimestamp)
        
        // MARK: Static constructors
        
        public static func noteOn(
            _ note: UInt7,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0,
            midi1ZeroVelocityAsNoteOff: Bool = true
        ) -> Self { fatalError() }
        
        public static func noteOn(
            _ note: MIDINote,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0,
            midi1ZeroVelocityAsNoteOff: Bool = true
        ) -> Self { fatalError() }
        
        // MARK: Note
        
        @available(
            *, unavailable,
            message: "The `MIDI.Event.Note` namespace has been removed and first-generation nested types have been renamed `MIDIEvent.NoteOn`, `MIDIEvent.NoteOff`, etc."
        )
        public enum Note {
            @available(*, unavailable, message: "Renamed to MIDIEvent.NoteOn")
            public struct On {
                public init(
                    note: UInt7,
                    velocity: MIDIEvent.NoteVelocity,
                    attribute: MIDIEvent.NoteAttribute = .none,
                    channel: UInt4,
                    group: UInt4 = 0x0,
                    midi1ZeroVelocityAsNoteOff: Bool = true
                ) { fatalError() }
                
                public init(
                    note: MIDINote,
                    velocity: MIDIEvent.NoteVelocity,
                    attribute: MIDIEvent.NoteAttribute = .none,
                    channel: UInt4,
                    group: UInt4 = 0x0,
                    midi1ZeroVelocityAsNoteOff: Bool = true
                ) { fatalError() }
            }
            
            @available(*, unavailable, message: "Renamed to MIDIEvent.NoteOff")
            public struct Off { }
            
            @available(*, unavailable, message: "Renamed to MIDIEvent.NoteCC")
            public struct CC { }
            
            @available(*, unavailable, message: "Renamed to MIDIEvent.PitchBend")
            public struct PitchBend { }
            
            @available(*, unavailable, message: "Renamed to MIDIEvent.Pressure")
            public struct Pressure { }
            
            @available(*, unavailable, message: "Renamed to MIDIEvent.Management")
            public struct Management { }
        }
        
        @available(*, unavailable, message: "Renamed to MIDIEvent.CC")
        public enum CC { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.ProgramChange")
        public enum ProgramChange { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.PitchBend")
        public enum PitchBend { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.Pressure")
        public enum Pressure { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.SysEx7")
        public enum SysEx7 { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.UniversalSysEx7")
        public enum UniversalSysEx7 { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.SysEx8")
        public enum SysEx8 { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.UniversalSysEx8")
        public enum UniversalSysEx8 { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.TimecodeQuarterFrame")
        public enum TimecodeQuarterFrame { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.SongPositionPointer")
        public enum SongPositionPointer { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.SongSelect")
        public enum SongSelect { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.UnofficialBusSelect")
        public enum UnofficialBusSelect { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.TuneRequest")
        public enum TuneRequest { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.TimingClock")
        public enum TimingClock { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.Start")
        public enum Start { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.Continue")
        public enum Continue { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.Stop")
        public enum Stop { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.ActiveSensing")
        public enum ActiveSensing { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.SystemReset")
        public enum SystemReset { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.NoOp")
        public enum NoOp { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.JRClock")
        public enum JRClock { }
            
        @available(*, unavailable, message: "Renamed to MIDIEvent.JRTimestamp")
        public enum JRTimestamp { }
    }
    
    // MARK: Note
    
    @available(*, unavailable, message: "Renamed to MIDINote")
    public struct Note {
        public var number: UInt7 = 0
        public var style: MIDINote.Style = .yamaha
    }
    
    // MARK: Utilities - Atomic
    
    @available(
        *,
        unavailable,
        message: "Renamed to top-level @ThreadSafeAccess in MIDIKitInternals target"
    )
    @propertyWrapper
    public final class Atomic<T> {
        public init(wrappedValue value: T) { fatalError() }
        public var wrappedValue: T { fatalError() }
    }
}

// MARK: Category Extensions for Type conversion

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt4")
    public var toMIDIUInt4: UInt4 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt4Exactly")
    public var toMIDIUInt4Exactly: UInt4? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt7")
    public var toMIDIUInt7: UInt7 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt7Exactly")
    public var toMIDIUInt7Exactly: UInt7? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt9")
    public var toMIDIUInt9: UInt9 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt9Exactly")
    public var toMIDIUInt9Exactly: UInt9? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt14")
    public var toMIDIUInt14: UInt14 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt14Exactly")
    public var toMIDIUInt14Exactly: UInt14? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt25")
    public var toMIDIUInt25: UInt25 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt25Exactly")
    public var toMIDIUInt25Exactly: UInt25? { fatalError() }
}
