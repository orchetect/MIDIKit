//
//  MIDIKit-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

// NOTE: This is not by any means exhaustive, as nearly every symbol had namespace changes from 0.5.x -> 0.6.0 but the most common symbols are covered here to help guide code migration.

@available(
    *, unavailable,
    message: "💡 The MIDI namespace has been removed as of MIDIKit 0.6.0. First-generation nested symbols have adopted a MIDI prefix instead. For example: MIDI.Event has become MIDIEvent, MIDI.IO.Manager has become MIDIManager."
)
public enum MIDI {
    // MARK: Types
    
    public typealias UInt4 = MIDIKit.UInt4
    public typealias UInt7 = MIDIKit.UInt7
    public typealias UInt9 = MIDIKit.UInt9
    public typealias UInt14 = MIDIKit.UInt14
    public typealias UInt25 = MIDIKit.UInt25
    
    public typealias Byte = MIDIKit.Byte
    public typealias Nibble = MIDIKit.Nibble
    public typealias UMPWord = MIDIKit.UMPWord
    
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
        
        @inline(__always)
        public static func noteOn(
            _ note: UInt7,
            velocity: MIDIEvent.NoteVelocity,
            attribute: MIDIEvent.NoteAttribute = .none,
            channel: UInt4,
            group: UInt4 = 0x0,
            midi1ZeroVelocityAsNoteOff: Bool = true
        ) -> Self { fatalError() }
        
        @inline(__always)
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
    
    // MARK: -
    
    @available(
        *, unavailable,
        message: "The `MIDI.IO` namespace has been removed and first-generation nested types have been renamed `MIDIManager`, `MIDIInputEndpoint`, etc."
    )
    public enum IO {
        // MARK: Core MIDI Aliased Types
        
        public typealias UniqueID = MIDIKit.MIDIIdentifier
        public typealias ObjectRef = UInt32
        public typealias ClientRef = MIDIKit.CoreMIDIObjectRef
        public typealias DeviceRef = MIDIKit.CoreMIDIObjectRef
        public typealias EntityRef = MIDIKit.CoreMIDIObjectRef
        public typealias PortRef = MIDIKit.CoreMIDIObjectRef
        public typealias EndpointRef = MIDIKit.CoreMIDIObjectRef
        public typealias ThruConnectionRef = MIDIKit.CoreMIDIObjectRef
        public typealias TimeStamp = UInt64
        public typealias CoreMIDIOSStatus = Int32
        
        
        // MARK: Manager
        
        public class Manager {
            @available(*, unavailable)
            public init(
                clientName: String,
                model: String,
                manufacturer: String,
                notificationHandler: ((
                    _ notification: MIDIIONotification,
                    _ manager: MIDIManager
                ) -> Void)? = nil
            ) { fatalError() }
        
            public func addInput(
                name: String,
                tag: String,
                uniqueID: MIDIIdentifierPersistence,
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            // MARK: - Add Methods
            
            public func addInputConnection(
                toOutputs: Set<MIDIEndpointIdentity>,
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            public func addInputConnection(
                toOutputs: [MIDIEndpointIdentity],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            @_disfavoredOverload
            public func addInputConnection(
                toOutputs: [MIDIOutputEndpoint],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default(),
                receiver: MIDIReceiver
            ) throws { fatalError() }
            
            public func addOutput(
                name: String,
                tag: String,
                uniqueID: MIDIIdentifierPersistence
            ) throws { fatalError() }
            
            public func addOutputConnection(
                toInputs: Set<MIDIEndpointIdentity>,
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            public func addOutputConnection(
                toInputs: [MIDIEndpointIdentity],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            @_disfavoredOverload
            public func addOutputConnection(
                toInputs: [MIDIInputEndpoint],
                tag: String,
                mode: MIDIConnectionMode = .definedEndpoints,
                filter: MIDIEndpointFilter = .default()
            ) throws { fatalError() }
            
            public func addThruConnection(
                outputs: [MIDIOutputEndpoint],
                inputs: [MIDIInputEndpoint],
                tag: String,
                lifecycle: MIDIThruConnection.Lifecycle = .nonPersistent,
                params: MIDIThruConnection.Parameters = .init()
            ) throws { fatalError() }
            
            // MARK: - Remove Methods
            
            public func remove(
                _ type: MIDIManager.ManagedType,
                _ tagSelection: MIDIManager.TagSelection
            ) { fatalError() }
            
            // MARK: State
            
            public func start() throws { fatalError() }
        }
        
        // MARK: Network Session
        
        @available(
            *, unavailable,
             message: "setMIDINetworkSession() is now a top-level global method."
        )
        public static func setMIDINetworkSession(policy: MIDIIONetworkConnectionPolicy?) { fatalError() }
        
        // MARK: UniqueIDPersistence -> MIDIIdentifierPersistence
        
        @available(*, unavailable, message: "Renamed to MIDIIdentifierPersistence")
        public enum UniqueIDPersistence {
            case none
            case preferred(MIDI.IO.UniqueID)
            case userDefaultsManaged(key: String)
            case manualStorage(
                readHandler: () -> MIDI.IO.UniqueID?,
                storeHandler: (MIDI.IO.UniqueID?) -> Void
            )
        }
    }
    
    // MARK: Note
    
    @available(*, unavailable, message: "Renamed to MIDINote")
    public struct Note {
        public var number: UInt7 = 0
        public var style: MIDINote.Style = .yamaha
    }
    
    // MARK: Utilities - Atomic
    
    @available(*, unavailable, message: "Renamed to top-level @ThreadSafeAccess")
    @propertyWrapper
    public final class Atomic<T> {
        public init(wrappedValue value: T) { fatalError() }
        public var wrappedValue: T { fatalError() }
    }
}


// MARK: MIDIUniqueID -> MIDIIdentifier

extension Set where Element == MIDIIdentifier {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> Set<MIDIEndpointIdentity> { fatalError() }
}

extension Array where Element == MIDIIdentifier {
    @available(*, unavailable, renamed: "asIdentities")
    public func asCriteria() -> [MIDIEndpointIdentity] { fatalError() }
}

// MARK: UniqueIDPersistence -> MIDIIdentifierPersistence

extension MIDIIdentifierPersistence {
    @available(*, unavailable, renamed: "adHoc")
    @_disfavoredOverload
    public static let none: Self = { fatalError() }()
    
    @available(*, unavailable, renamed: "unmanaged")
    @_disfavoredOverload
    public static func preferred(_: MIDI.IO.UniqueID) -> Self { fatalError() }
    
    // case userDefaultsManaged was not renamed
    
    @available(*, unavailable, renamed: "managedStorage")
    @_disfavoredOverload
    public static func manualStorage(
        readHandler: () -> MIDI.IO.UniqueID?,
        storeHandler: (MIDI.IO.UniqueID?) -> Void
    ) -> Self { fatalError() }
}
