//
//  MIDIKitTests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

import XCTest
import MIDIKit
import CoreMIDI

final class MIDIKit_Tests: XCTestCase {
    // no tests in this file, this is the module root test file
	
    func testEmpty() {
//        _ = MIDIEvent.noteOn(60, velocity: .midi1(64), channel: 0)
//        _ = MIDIEvent.Note.On(note: 60, velocity: .midi1(64), channel: 0)
//        _ = MIDIEvent.Note.On(note: 60, velocity: .midi1(64), channel: 0)
//            .midi1RawBytes()
//        _ = MIDIEvent.doesntExist(60, velocity: .midi1(0))
//
//        var events: [MIDIEvent] = []
//
//        events = [
//            .noteOn(60, velocity: .midi1(64), channel: 0)
//        ]
//
//        events.forEach {
//            switch $0 {
//            case let .noteOn(payload):
//                print(payload.note, payload.velocity)
//            case let .noteOff(payload):
//                print(payload.note, payload.velocity)
//            }
//        }
//
//        let midiManager = MIDI.IO.Manager(clientName: "", model: "", manufacturer: "")
//
//        MIDI.IO.setMIDINetworkSession(policy: .anyone)
//
//        let n: MIDI.UInt4 = 1
//
//        let i: [MIDIIdentifier] = []
//        _ = i.asCriteria()
//
//        let p: MIDIIdentifierPersistence = .none
    }
}

#endif
