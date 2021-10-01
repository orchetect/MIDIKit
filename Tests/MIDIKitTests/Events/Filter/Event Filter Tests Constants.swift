//
//  Event Filter Tests Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKit

enum kEvents {
    
    enum ChanVoice {
        
        static let noteOn: MIDI.Event = .noteOn(60,
                                                velocity: .unitInterval(0.5),
                                                channel: 2,
                                                group: 0)
        
        static let noteOff: MIDI.Event = .noteOff(61,
                                                  velocity: .unitInterval(0.0),
                                                  channel: 3,
                                                  group: 0)
        
        static let noteCC: MIDI.Event = .noteCC(note: 60,
                                                controller: .registered(.modWheel),
                                                value: 1,
                                                channel: 4,
                                                group: 0)
        
        static let notePitchBend: MIDI.Event = .notePitchBend(note: 61,
                                                              value: 0x80000000,
                                                              channel: 4,
                                                              group: 0)
        
        static let notePressure: MIDI.Event = .notePressure(note: 60,
                                                            amount: .midi1(102),
                                                            channel: 1,
                                                            group: 0)
        
        static let noteManagement: MIDI.Event = .noteManagement(61,
                                                                flags: [.resetPerNoteControllers],
                                                                channel: 4,
                                                                group: 0)
        
        static let cc: MIDI.Event = .cc(11,
                                        value: .midi1(127),
                                        channel: 0,
                                        group: 0)
        
        static let programChange: MIDI.Event = .programChange(program: 1,
                                                              channel: 1,
                                                              group: 0)
        
        static let pitchBend: MIDI.Event = .pitchBend(value: 1,
                                                      channel: 1,
                                                      group: 0)
        
        static let pressure: MIDI.Event = .pressure(amount: .midi1(1),
                                                    channel: 1,
                                                    group: 0)
        
        // ancillary events
        static let cc1: MIDI.Event = .cc(1,
                                         value: .midi1(127),
                                         channel: 0,
                                         group: 0)
        
        static let oneOfEachEventType: [MIDI.Event] = [
            Self.noteOn,
            Self.noteOff,
            Self.noteCC,
            Self.notePitchBend,
            Self.notePressure,
            Self.noteManagement,
            Self.cc,
            Self.programChange,
            Self.pitchBend,
            Self.pressure
        ]
        
    }
    
    enum SysCommon {
        
        static let timecodeQuarterFrame: MIDI.Event = .timecodeQuarterFrame(dataByte: 0b0000_0000, group: 0)
        static let songPositionPointer: MIDI.Event = .songPositionPointer(midiBeat: 8, group: 0)
        static let songSelect: MIDI.Event = .songSelect(number: 4, group: 0)
        static let unofficialBusSelect: MIDI.Event = .unofficialBusSelect(bus: 2, group: 0)
        static let tuneRequest: MIDI.Event = .tuneRequest(group: 0)
        
        static let oneOfEachEventType: [MIDI.Event] = [
            Self.timecodeQuarterFrame,
            Self.songPositionPointer,
            Self.songSelect,
            Self.unofficialBusSelect,
            Self.tuneRequest
        ]
        
    }
    
    enum SysEx {
        
        static let sysEx: MIDI.Event = .sysEx(
            manufacturer: .educational(),
            data: [0x20],
            group: 0
        )
        static let universalSysEx: MIDI.Event = .universalSysEx(
            universalType: .realTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x01,
            data: [0x20],
            group: 0
        )
        
        static let oneOfEachEventType: [MIDI.Event] = [
            Self.sysEx,
            Self.universalSysEx
        ]
        
    }
    
    enum SysRealTime {
        
        static let timingClock: MIDI.Event = .timingClock(group: 0)
        static let start: MIDI.Event = .start(group: 0)
        static let `continue`: MIDI.Event = .continue(group: 0)
        static let stop: MIDI.Event = .stop(group: 0)
        static let activeSensing: MIDI.Event = .activeSensing(group: 0)
        static let systemReset: MIDI.Event = .systemReset(group: 0)
        
        static let oneOfEachEventType: [MIDI.Event] = [
            Self.timingClock,
            Self.start,
            Self.continue,
            Self.stop,
            Self.activeSensing,
            Self.systemReset
        ]
        
    }
    
    static let oneOfEachMIDI1EventType: [MIDI.Event] =
    ChanVoice.oneOfEachEventType +
    SysCommon.oneOfEachEventType +
    SysEx.oneOfEachEventType +
    SysRealTime.oneOfEachEventType
    
}
