//
//  Event Conversion Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitSMF
import Testing

@Suite struct Event_Conversion_EventToMIDIFileEvent_Tests {
    @Test
    func midi_Event_NoteOn_midiFileEvent() async throws {
        let event: MIDIEvent = .noteOn(
            60,
            velocity: .midi1(64),
            attribute: .profileSpecific(data: 0x1234),
            channel: 1,
            group: 2,
            midi1ZeroVelocityAsNoteOff: true
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .noteOn(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .noteOn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_NoteOff_midiFileEvent() async throws {
        let event: MIDIEvent = .noteOff(
            60,
            velocity: .midi1(0),
            attribute: .profileSpecific(data: 0x1234),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .noteOff(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .noteOff(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_NoteCC_midiFileEvent() async throws {
        let event: MIDIEvent = .noteCC(
            note: 60,
            controller: .registered(.modWheel),
            value: .midi2(32768),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_NotePitchBend_midiFileEvent() async throws {
        let event: MIDIEvent = .notePitchBend(
            note: 60,
            value: .midi2(.zero),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_NotePressure_midiFileEvent() async throws {
        let event: MIDIEvent = .notePressure(
            note: 60,
            amount: .midi2(.zero),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .notePressure(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .notePressure(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_NoteManagement_midiFileEvent() async throws {
        let event: MIDIEvent = .noteManagement(
            note: 60,
            flags: [.detachPerNoteControllers],
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // no equivalent SMF event exists
        // (with the upcoming Standard MIDI File 2.0 spec, this may be implemented in future)
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_CC_midiFileEvent() async throws {
        let event: MIDIEvent = .cc(
            .modWheel,
            value: .midi1(64),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .cc(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .cc(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_ProgramChange_midiFileEvent() async throws {
        let event: MIDIEvent = .programChange(
            program: 20,
            bank: .bankSelect(4),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .programChange(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .programChange(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_RPN_midiFileEvent() async throws {
        let event: MIDIEvent = .rpn(
            .channelFineTuning(123),
            channel: 0
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .rpn(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .rpn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_NRPN_midiFileEvent() async throws {
        let event: MIDIEvent = .nrpn(
            .raw(parameter: .init(msb: 2, lsb: 1), dataEntryMSB: 0x05, dataEntryLSB: 0x20),
            channel: 0
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .nrpn(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .nrpn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_PitchBend_midiFileEvent() async throws {
        let event: MIDIEvent = .pitchBend(
            value: .midi1(.midpoint),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .pitchBend(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .pitchBend(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_Pressure_midiFileEvent() async throws {
        let event: MIDIEvent = .pressure(
            amount: .midi1(5),
            channel: 1,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .pressure(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .pressure(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_SysEx_midiFileEvent() async throws {
        let event: MIDIEvent = try .sysEx7(
            manufacturer: .educational(),
            data: [0x12, 0x34],
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .sysEx7(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .sysEx7(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_UniversalSysEx_midiFileEvent() async throws {
        let event: MIDIEvent = try .universalSysEx7(
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x02,
            data: [0x12, 0x34],
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // extract MIDIEvent payload
        guard case let .universalSysEx7(unwrappedEvent) = event else {
            Issue.record(); return
        }
        
        // extract MIDIFileEvent payload
        guard case let .universalSysEx7(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }
        
        // compare payloads to ensure they are the same
        #expect(unwrappedEvent == unwrappedSMFEvent)
    }
    
    @Test
    func midi_Event_TimecodeQuarterFrame_midiFileEvent() async {
        let event: MIDIEvent = .timecodeQuarterFrame(
            dataByte: 0x00,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_SongPositionPointer_midiFileEvent() async {
        let event: MIDIEvent = .songPositionPointer(
            midiBeat: 8,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_SongSelect_midiFileEvent() async {
        let event: MIDIEvent = .songSelect(
            number: 4,
            group: 2
        )
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_TuneRequest_midiFileEvent() async {
        let event: MIDIEvent = .tuneRequest(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_TimingClock_midiFileEvent() async {
        let event: MIDIEvent = .timingClock(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_Start_midiFileEvent() async {
        let event: MIDIEvent = .start(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_Continue_midiFileEvent() async {
        let event: MIDIEvent = .continue(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_Stop_midiFileEvent() async {
        let event: MIDIEvent = .stop(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_ActiveSensing_midiFileEvent() async {
        let event: MIDIEvent = .activeSensing(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        #expect(smfEvent == nil)
    }
    
    @Test
    func midi_Event_SystemReset_midiFileEvent() async {
        let event: MIDIEvent = .systemReset(group: 2)
        
        // convert MIDIEvent case to MIDIFileEvent case, preserving payloads
        let smfEvent = event.midiFileEvent()
        
        // not an event that can be stored in a MIDI file, only applicable to live MIDI I/O
        // (A system reset message byte (0xFF) is reserved in the MIDI file format as the start byte
        // for various MIDI file-specific event types.)
        #expect(smfEvent == nil)
    }
}

@Suite struct Event_Conversion_SMFEventToEvent_Tests {
    @Test
    func midi_File_Event_CC_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.cc(
            controller: .modWheel,
            value: .midi1(64),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .cc(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .cc(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_NoteOff_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.noteOff(
            note: 60,
            velocity: .midi1(0),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .noteOff(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .noteOff(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_NoteOn_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.noteOn(
            note: 60,
            velocity: .midi1(64),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .noteOn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .noteOn(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_NotePressure_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.notePressure(
            note: 60,
            amount: .midi1(64),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .notePressure(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .notePressure(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_PitchBend_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.pitchBend(
            value: .midi1(.midpoint),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .pitchBend(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .pitchBend(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_Pressure_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.pressure(
            amount: .midi1(.midpoint),
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .pressure(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .pressure(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_ProgramChange_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.programChange(
            program: 20,
            channel: 1
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .programChange(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .programChange(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_RPN_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.rpn(
            parameter: .channelFineTuning(123),
            change: .absolute,
            channel: 0
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .rpn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .rpn(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_NRPN_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.nrpn(
            parameter: .raw(
                parameter: .init(msb: 2, lsb: 1),
                dataEntryMSB: 0x05,
                dataEntryLSB: 0x20
            ),
            change: .absolute,
            channel: 0
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .nrpn(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .nrpn(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_SysEx7_midiEvent() async throws {
        let smfEvent = try MIDIFileEvent.sysEx7(
            manufacturer: .educational(),
            data: [0x12, 0x34]
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .sysEx7(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .sysEx7(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_UniversalSysEx7_midiEvent() async throws {
        let smfEvent = try MIDIFileEvent.universalSysEx7(
            universalType: .nonRealTime,
            deviceID: 0x7F,
            subID1: 0x01,
            subID2: 0x02,
            data: [0x12, 0x34]
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // extract MIDIFileEvent payload
        guard case let .universalSysEx7(unwrappedSMFEvent) = smfEvent else {
            Issue.record(); return
        }

        // extract MIDIEvent payload
        guard case let .universalSysEx7(unwrappedEvent) = event else {
            Issue.record(); return
        }

        // compare payloads to ensure they are the same
        #expect(unwrappedSMFEvent == unwrappedEvent)
    }

    @Test
    func midi_File_Event_ChannelPrefix_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.channelPrefix(
            channel: 4
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_KeySignature_midiEvent() async throws {
        let smfEvent = try #require(MIDIFileEvent.keySignature(
            flatsOrSharps: -2,
            isMajor: true
        ))

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_PortPrefix_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.portPrefix(
            port: 4
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_SequenceNumber_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.sequenceNumber(
            sequence: 4
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_SequencerSpecific_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.sequencerSpecific(
            data: [0x12, 0x34]
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_SMPTEOffset_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.smpteOffset(
            hr: 1,
            min: 2,
            sec: 3,
            fr: 4,
            subFr: 0,
            rate: .fps29_97d
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_Tempo_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.tempo(
            bpm: 140.0
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_Text_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.text(
            type: .trackOrSequenceName,
            string: "Piano"
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_TimeSignature_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.timeSignature(
            numerator: 2,
            denominator: 2
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_UnrecognizedMeta_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.unrecognizedMeta(
            metaType: 0x30,
            data: [0x12, 0x34]
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }

    @Test
    func midi_File_Event_XMFPatchTypePrefix_midiEvent() async throws {
        let smfEvent = MIDIFileEvent.xmfPatchTypePrefix(
            patchSet: .DLS
        )

        // convert MIDIFileEvent case to MIDIEvent case, preserving payloads
        let event = smfEvent.midiEvent()

        // event has no MIDIEvent I/O event equivalent; applicable only to MIDI files
        #expect(event == nil)
    }
}
