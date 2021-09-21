//
//  Sandbox.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
import MIDIKit
import CoreMIDI

final class Sandbox: XCTestCase {
    
//    func testSandbox() {
//
//        // MIDI.Event
//
//        _ = MIDI.Event.noteOn(note: 2, velocity: 100, channel: 0)
//
//        _ = MIDI.Event.noteOff(note: 2, velocity: 100, channel: 0)
//
//        _ = MIDI.Event.cc(.rpn(.channelFineTuning(.midpoint)), channel: 0)
//
//        _ = try? MIDI.Event(rawBytes: [0xFF])
//
//        // MIDI.Event sub events
//
//        _ = MIDI.Event.noteOn(note: 2, velocity: 100, channel: 0)
//
//        _ = MIDI.Event.cc(.modWheel(value: 127), channel: 0)
//
//        _ = MIDI.Event.CC.modWheel(value: 127)
//
//        _ = MIDI.Event.CC.RPN.null
//
//        // collections
//
//        let _: [MIDI.Event] = [
//            .noteOn(note: 2, velocity: 100, channel: 0),
//            .cc(.modWheel(value: 127), channel: 0),
//            .cc(.lsb(.dataEntry(value: 64)), channel: 0),
//            .cc(.raw(1, value: 127), channel: 0),
//            .cc(.rpn(.null), channel: 0),
//            .timecodeQuarterFrame(byte: 0x00),
//            .activeSensing,
//            .sysEx(manufacturer: .oneByte(0x41)!, data: [0x6F])
//        ]
//
//        let _: [MIDI.Event?] = [
//            .noteOn(note: 2, velocity: 100, channel: 0)
//        ].compactMap { $0 }
//
//        let _: [MIDI.Event] = [
//            .modWheel(value: 127),
//            .expression(value: 127),
//            .lsb(.dataEntry(value: 64)),
//            .raw(1, value: 127)
//        ]
//
//        // properties
//
//        _ = MIDI.Event.ChanVoice.CC.modWheel(value: 64).controller
//
//        // parsing (receiver)
//
//        [MIDI.Event]([.chanVoice(.noteOn(note: 60, velocity: 64, channel: 0))])
//            .forEach { event in
//
//                switch event.message {
//                case .chanVoice(let msg):
//
//                    switch msg {
//                    case .noteOn(let note, let velocity, let channel):
//                        _ = note
//                        _ = velocity
//                        _ = channel
//
//                    case .noteOff(let note, let velocity, let channel):
//                        _ = note
//                        _ = velocity
//                        _ = channel
//
//                    case .polyAftertouch(let note, let pressure, let channel):
//                        _ = note
//                        _ = pressure
//                        _ = channel
//
//                    case .cc(let cc, let channel):
//                        switch cc {
//                        case .modWheel(let value):
//                            _ = value
//                        default: break
//                        }
//
//                        _ = channel
//
//                    case .programChange(let program, let channel):
//                        _ = program
//                        _ = channel
//
//                    case .chanAftertouch(let pressure, let channel):
//                        _ = pressure
//                        _ = channel
//
//                    case .pitchBend(let value, let channel):
//                        _ = value
//                        _ = channel
//
//                    }
//
//                case .sysCommon(let msg):
//
//                    switch msg {
//                    case .timecodeQuarterFrame:
//                        break
//                    case .songPositionPointer:
//                        break
//                    case .songSelect:
//                        break
//                    case .unofficialBusSelect:
//                        break
//                    case .tuneRequest:
//                        break
//                    }
//
//                case .sysRealTime(let msg):
//
//                    switch msg {
//                    case .timingClock:
//                        break
//                    case .start:
//                        break
//                    case .stop:
//                        break
//                    case .continue:
//                        break
//                    case .activeSensing:
//                        break
//                    case .systemReset:
//                        break
//                    }
//
//                case .sysEx(let msg):
//
//                    switch msg {
//                    case .sysEx(manufacturer: let manufacturer,
//                                data: let data):
//                        _ = manufacturer
//                        _ = data
//                    case .universalSysEx(let type,
//                                         deviceID: let deviceID,
//                                         subID1: let subID1,
//                                         subID2: let subID2,
//                                         data: let data):
//                        _ = type
//                        _ = deviceID
//                        _ = subID1
//                        _ = subID2
//                        _ = data
//                    }
//
//                case .raw:
//
//                    _ = event.rawBytes
//
//                }
//
//            }
//
//        // custom types, conforming to MIDIEventProtocol
//
//        struct CustomMIDIEvent: MIDIEventProtocol {
//
//            enum Kind: MIDIEventKindProtocol, Equatable, Hashable {
//                case dummy
//            }
//
//            var kind: Kind = .dummy
//
//            var rawBytes: [MIDI.Byte]
//
//            init(rawBytes: [MIDI.Byte]) throws {
//                self.rawBytes = []
//            }
//
//            func asEvent() -> MIDI.Event {
//                try! .init(rawBytes: rawBytes)
//            }
//
//        }
//
//        //_ = AnyMIDIEventMessageKind.p
//
//        _ = MIDI.Event.ChanVoice.Kind.controllerChange
//
//        _ = [MIDI.Event]([.chanVoice(.noteOn(note: 60, velocity: 64, channel: 0))])
//            .filter(pattern: [.raw])
//
//        _ = [MIDI.Event]([.chanVoice(.noteOn(note: 60, velocity: 64, channel: 0))])
//            .filter(pattern: [.chanVoice([.noteOn, .noteOff])])
//            .filter([MIDI.Event.Kind.raw])
//
//    }
//
//    func testSandbox2() {
//
//        _ = (MIDI.Event.ChanVoice.Kind.noteOn == MIDI.Event.ChanVoice.Kind.noteOn)
//
//        _ = (MIDI.Event.ChanVoice.Kind.noteOn.asAnyHashable() == MIDI.Event.ChanVoice.Kind.noteOn.asAnyHashable())
//
//        _ = (MIDI.Event.ChanVoice.Kind.noteOn as AnyHashable == MIDI.Event.ChanVoice.Kind.noteOn as AnyHashable)
//
//        _ = (MIDI.Event.Kind.chanVoice.asAnyHashable() == MIDI.Event.ChanVoice.Kind.noteOn.asAnyHashable())
//
//        let _ : AnyHashable = 123
//        let _ : AnyHashable = "test"
//        let _ = "test" as AnyHashable
//        let _ : AnyHashable = MIDI.Event.ChanVoice.Kind.noteOn
//
//        let _ : [AnyHashable] = [.init(123), 123]
//
//        let _ : [AnyMIDIEventKind] = [.init(MIDI.Event.ChanVoice.Kind.noteOn),
//                                      MIDI.Event.ChanVoice.Kind.noteOn]
//
//        //123 as AnyHashable
//
//        let aha: [AnyHashable] = [.init(MIDI.Event.ChanVoice.Kind.noteOn),
//                                  MIDI.Event.ChanVoice.Kind.noteOn,
//                                  MIDI.Event.Kind.chanVoice]
//
//        print(aha[0] == aha[1])
//        print(aha[0] == aha[2])
//
//    }
    
}

#endif
