//
//  Event Conversion Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import MIDIKitSMF
import XCTest

final class Event_Conversion_EventToSMFEvent_Tests: XCTestCase {
    func testMIDI_Event_NoteOn_smfEvent() throws {
        let event = MIDIEvent.noteOn(
            60,
            velocity: .midi1(64),
            attribute: .profileSpecific(data: 0x1234),
            channel: 1,
            group: 2,
            midi1ZeroVelocityAsNoteOff: true
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .noteOn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .noteOn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_NoteOff_smfEvent() throws {
        let event = MIDIEvent.noteOff(
            60,
            velocity: .midi1(0),
            attribute: .profileSpecific(data: 0x1234),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .noteOff(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .noteOff(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_NoteCC_smfEvent() throws {
        let event = MIDIEvent.noteCC(
            note: 60,
            controller: .registered(.modWheel),
            value: .midi2(32768),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_NotePitchBend_smfEvent() throws {
        let event = MIDIEvent.notePitchBend(
            note: 60,
            value: .midi2(.zero),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_NotePressure_smfEvent() throws {
        let event = MIDIEvent.notePressure(
            note: 60,
            amount: .midi2(.zero),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .notePressure(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .notePressure(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_NoteManagement_smfEvent() throws {
        let event = MIDIEvent.noteManagement(
            note: 60,
            flags: [.detachPerNoteControllers],
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_CC_smfEvent() throws {
        let event = MIDIEvent.cc(
            .modWheel,
            value: .midi1(64),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .cc(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .cc(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_ProgramChange_smfEvent() throws {
        let event = MIDIEvent.programChange(
            program: 20,
            bank: .bankSelect(4),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .programChange(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .programChange(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_RPN_smfEvent() throws {
        let event = MIDIEvent.rpn(
            .channelFineTuning(123),
            channel: 0
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .rpn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .rpn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_NRPN_smfEvent() throws {
        let event = MIDIEvent.nrpn(
            .raw(parameter: .init(msb: 2, lsb: 1), dataEntryMSB: 0x05, dataEntryLSB: 0x20),
            channel: 0
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .nrpn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .nrpn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_PitchBend_smfEvent() throws {
        let event = MIDIEvent.pitchBend(
            value: .midi1(.midpoint),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .pitchBend(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .pitchBend(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_Pressure_smfEvent() throws {
        let event = MIDIEvent.pressure(
            amount: .midi1(5),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .pressure(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .pressure(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_SysEx_smfEvent() throws {
        let event = try MIDIEvent.sysEx7(
            manufacturer: .educational(),
            data: [0x12, 0x34],
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .sysEx7(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .sysEx7(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_UniversalSysEx_smfEvent() throws {
        let event = try MIDIEvent.universalSysEx7(
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x02,
            data: [0x12, 0x34],
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // extract MIDIEvent payload
        guard case let .universalSysEx7(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // extract MIDIFileEvent payload
        guard case .universalSysEx7(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedEvent, unwrappedSMFEvent)
    }
    
    func testMIDI_Event_TimecodeQuarterFrame_smfEvent() {
        let event = MIDIEvent.timecodeQuarterFrame(
            dataByte: 0x00,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_SongPositionPointer_smfEvent() {
        let event = MIDIEvent.songPositionPointer(
            midiBeat: 8,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_SongSelect_smfEvent() {
        let event = MIDIEvent.songSelect(
            number: 4,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_UnofficialBusSelect_smfEvent() {
        let event = MIDIEvent.unofficialBusSelect(
            bus: 4,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_TuneRequest_smfEvent() {
        let event = MIDIEvent.tuneRequest(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_TimingClock_smfEvent() {
        let event = MIDIEvent.timingClock(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_Start_smfEvent() {
        let event = MIDIEvent.start(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_Continue_smfEvent() {
        let event = MIDIEvent.continue(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_Stop_smfEvent() {
        let event = MIDIEvent.stop(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_ActiveSensing_smfEvent() {
        let event = MIDIEvent.activeSensing(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        XCTAssertNil(smfEvent)
    }
    
    func testMIDI_Event_SystemReset_smfEvent() {
        let event = MIDIEvent.systemReset(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.smfEvent(delta: .ticks(120))
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        // (A system reset message byte (0xFF) is reserved in the MIDI file format as the start byte
        // for various MIDI file-specific event types.)
        XCTAssertNil(smfEvent)
    }
}

final class Event_Conversion_SMFEventToEvent_Tests: XCTestCase {
    func testMIDI_File_Event_CC_event() throws {
        let smfEvent = MIDIFileEvent.cc(
            delta: .none,
            controller: .modWheel,
            value: .midi1(64),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .cc(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .cc(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_NoteOff_event() throws {
        let smfEvent = MIDIFileEvent.noteOff(
            delta: .none,
            note: 60,
            velocity: .midi1(0),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .noteOff(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .noteOff(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_NoteOn_event() throws {
        let smfEvent = MIDIFileEvent.noteOn(
            delta: .none,
            note: 60,
            velocity: .midi1(64),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .noteOn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .noteOn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_NotePressure_event() throws {
        let smfEvent = MIDIFileEvent.notePressure(
            delta: .none,
            note: 60,
            amount: .midi1(64),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .notePressure(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .notePressure(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_PitchBend_event() throws {
        let smfEvent = MIDIFileEvent.pitchBend(
            delta: .none,
            value: .midi1(.midpoint),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .pitchBend(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .pitchBend(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_Pressure_event() throws {
        let smfEvent = MIDIFileEvent.pressure(
            delta: .none,
            amount: .midi1(.midpoint),
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .pressure(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .pressure(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_ProgramChange_event() throws {
        let smfEvent = MIDIFileEvent.programChange(
            delta: .none,
            program: 20,
            channel: 1
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .programChange(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .programChange(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_RPN_event() throws {
        let smfEvent = MIDIFileEvent.rpn(
            delta: .none,
            parameter: .channelFineTuning(123),
            change: .absolute,
            channel: 0
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .rpn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .rpn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_NRPN_event() throws {
        let smfEvent = MIDIFileEvent.nrpn(
            delta: .none,
            parameter: .raw(
                parameter: .init(msb: 2, lsb: 1),
                dataEntryMSB: 0x05,
                dataEntryLSB: 0x20
            ),
            change: .absolute,
            channel: 0
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .nrpn(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .nrpn(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_SysEx7_event() throws {
        let smfEvent = try MIDIFileEvent.sysEx7(
            delta: .none,
            manufacturer: .educational(),
            data: [0x12, 0x34]
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .sysEx7(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .sysEx7(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_UniversalSysEx7_event() throws {
        let smfEvent = try MIDIFileEvent.universalSysEx7(
            delta: .none,
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x02,
            data: [0x12, 0x34]
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // extract MIDIFileEvent payload
        guard case .universalSysEx7(
            delta: _,
            event: let unwrappedSMFEvent
        ) = smfEvent else {
            XCTFail(); return
        }
        
        // extract MIDIEvent payload
        guard case let .universalSysEx7(unwrappedEvent) = event else {
            XCTFail(); return
        }
        
        // compare payloads to ensure they are the same
        XCTAssertEqual(unwrappedSMFEvent, unwrappedEvent)
    }
    
    func testMIDI_File_Event_ChannelPrefix_event() throws {
        let smfEvent = MIDIFileEvent.channelPrefix(
            delta: .none,
            channel: 4
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_KeySignature_event() throws {
        let smfEvent = MIDIFileEvent.keySignature(
            delta: .none,
            flatsOrSharps: -2,
            majorKey: true
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_PortPrefix_event() throws {
        let smfEvent = MIDIFileEvent.portPrefix(
            delta: .none,
            port: 4
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_SequenceNumber_event() throws {
        let smfEvent = MIDIFileEvent.sequenceNumber(
            delta: .none,
            sequence: 4
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_SequencerSpecific_event() throws {
        let smfEvent = MIDIFileEvent.sequencerSpecific(
            delta: .none,
            data: [0x12, 0x34]
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_SMPTEOffset_event() throws {
        let smfEvent = MIDIFileEvent.smpteOffset(
            delta: .none,
            hr: 1,
            min: 2,
            sec: 3,
            fr: 4,
            subFr: 0,
            frRate: .fps29_97d
        )
                                                  
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_Tempo_event() throws {
        let smfEvent = MIDIFileEvent.tempo(
            delta: .none,
            bpm: 140.0
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_Text_event() throws {
        let smfEvent = MIDIFileEvent.text(
            delta: .none,
            type: .trackOrSequenceName,
            string: "Piano"
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_TimeSignature_event() throws {
        let smfEvent = MIDIFileEvent.timeSignature(
            delta: .none,
            numerator: 2,
            denominator: 2
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_UnrecognizedMeta_event() throws {
        let smfEvent = MIDIFileEvent.unrecognizedMeta(
            delta: .none,
            metaType: 0x30,
            data: [0x12, 0x34]
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
    
    func testMIDI_File_Event_XMFPatchTypePrefix_event() throws {
        let smfEvent = MIDIFileEvent.xmfPatchTypePrefix(
            delta: .none,
            patchSet: .DLS
        )
        
        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.event()
        
        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        XCTAssertNil(event)
    }
}

#endif
