//
//  MIDIEvent Filter Tests Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import MIDIKitCore

enum kEvents {
    enum ChanVoice {
        static let noteOn: MIDIEvent = .noteOn(
            60,
            velocity: .unitInterval(0.5),
            channel: 2,
            group: 0
        )
    
        static let noteOff: MIDIEvent = .noteOff(
            61,
            velocity: .unitInterval(0.0),
            channel: 3,
            group: 0
        )
    
        static let noteCC: MIDIEvent = .noteCC(
            note: 60,
            controller: .registered(.modWheel),
            value: .midi2(1),
            channel: 4,
            group: 0
        )
    
        static let notePitchBend: MIDIEvent = .notePitchBend(
            note: 61,
            value: .midi2(0x8000_0000),
            channel: 4,
            group: 0
        )
    
        static let notePressure: MIDIEvent = .notePressure(
            note: 60,
            amount: .midi1(102),
            channel: 1,
            group: 0
        )
    
        static let noteManagement: MIDIEvent = .noteManagement(
            note: 61,
            flags: [.resetPerNoteControllers],
            channel: 4,
            group: 0
        )
    
        static let cc: MIDIEvent = .cc(
            11,
            value: .midi1(127),
            channel: 0,
            group: 0
        )
    
        static let programChange: MIDIEvent = .programChange(
            program: 1,
            channel: 1,
            group: 0
        )
    
        static let pitchBend: MIDIEvent = .pitchBend(
            value: .bipolarUnitInterval(0.0),
            channel: 1,
            group: 0
        )
    
        static let pressure: MIDIEvent = .pressure(
            amount: .midi1(1),
            channel: 1,
            group: 0
        )
        
        static let rpn: MIDIEvent = .rpn(
            .channelFineTuning(123),
            change: .absolute,
            channel: 7
        )
        
        static let nrpn: MIDIEvent = .nrpn(
            .raw(parameter: .init(msb: 0x08, lsb: 0x12), dataEntryMSB: 0x10, dataEntryLSB: 0x20),
            change: .absolute,
            channel: 7
        )
        
        // ancillary events
        static let cc1: MIDIEvent = .cc(
            1,
            value: .midi1(127),
            channel: 0,
            group: 0
        )
    
        static let oneOfEachEventType: [MIDIEvent] = [
            Self.noteOn,
            Self.noteOff,
            Self.noteCC,
            Self.notePitchBend,
            Self.notePressure,
            Self.noteManagement,
            Self.cc,
            Self.programChange,
            Self.pitchBend,
            Self.pressure,
            Self.rpn,
            Self.nrpn
        ]
    }
    
    enum SysCommon {
        static let timecodeQuarterFrame: MIDIEvent = .timecodeQuarterFrame(
            dataByte: 0b00000000,
            group: 0
        )
        static let songPositionPointer: MIDIEvent = .songPositionPointer(midiBeat: 8, group: 0)
        static let songSelect: MIDIEvent = .songSelect(number: 4, group: 0)
        static let unofficialBusSelect: MIDIEvent = .unofficialBusSelect(bus: 2, group: 0)
        static let tuneRequest: MIDIEvent = .tuneRequest(group: 0)
    
        static let oneOfEachEventType: [MIDIEvent] = [
            Self.timecodeQuarterFrame,
            Self.songPositionPointer,
            Self.songSelect,
            Self.unofficialBusSelect,
            Self.tuneRequest
        ]
    }
    
    enum SysEx {
        static let sysEx7: MIDIEvent = .sysEx7(
            manufacturer: .educational(),
            data: [0x20] as [UInt7],
            group: 0
        )
        static let universalSysEx7: MIDIEvent = .universalSysEx7(
            universalType: .realTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x01,
            data: [0x20] as [UInt7],
            group: 0
        )
    
        static let sysEx8: MIDIEvent = .sysEx8(
            manufacturer: .educational(),
            data: [0xE6],
            group: 0
        )
        static let universalSysEx8: MIDIEvent = .universalSysEx8(
            universalType: .nonRealTime,
            deviceID: 0x05,
            subID1: 0x02,
            subID2: 0x03,
            data: [0xE6],
            group: 0
        )
    
        static let oneOfEachEventType: [MIDIEvent] = [
            Self.sysEx7,
            Self.universalSysEx7,
            Self.sysEx8,
            Self.universalSysEx8
        ]
    }
    
    enum SysRealTime {
        static let timingClock: MIDIEvent = .timingClock(group: 0)
        static let start: MIDIEvent = .start(group: 0)
        static let `continue`: MIDIEvent = .continue(group: 0)
        static let stop: MIDIEvent = .stop(group: 0)
        static let activeSensing: MIDIEvent = .activeSensing(group: 0)
        static let systemReset: MIDIEvent = .systemReset(group: 0)
    
        static let oneOfEachEventType: [MIDIEvent] = [
            Self.timingClock,
            Self.start,
            Self.continue,
            Self.stop,
            Self.activeSensing,
            Self.systemReset
        ]
    }
    
    enum Utility {
        static let noOp: MIDIEvent = .noOp(group: 0)
        static let jrClock: MIDIEvent = .jrClock(time: 0x1234, group: 1)
        static let jrTimestamp: MIDIEvent = .jrTimestamp(time: 0x1234, group: 2)
    
        static let oneOfEachEventType: [MIDIEvent] = [
            Self.noOp,
            Self.jrClock,
            Self.jrTimestamp
        ]
    }
    
    static let oneOfEachEventType: [MIDIEvent] =
        ChanVoice.oneOfEachEventType +
        SysCommon.oneOfEachEventType +
        SysEx.oneOfEachEventType +
        SysRealTime.oneOfEachEventType +
        Utility.oneOfEachEventType
}

#endif
