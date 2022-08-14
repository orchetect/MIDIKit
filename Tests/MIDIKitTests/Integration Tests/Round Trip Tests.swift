//
//  Round Trip Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import XCTest
@testable import MIDIKit
import CoreMIDI

open class RoundTrip_Tests_Base: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    
    fileprivate var manager: MIDIManager!
    
    fileprivate let outputTag = "1"
    fileprivate let inputConnectionTag = "2"
    
    fileprivate var receivedEvents: [MIDIEvent] = []
    
    override open func setUp() {
        print("RoundTrip_Tests setUp() starting")
        
        wait(sec: 0.5)
        
        manager = .init(
            clientName: "MIDIKit_IO_RoundTrip_Input_Tests",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        
        do {
            try manager.start()
        } catch {
            XCTFail("Could not start MIDIManager. \(error.localizedDescription)")
            return
        }
        
        wait(sec: 0.3)
        
        createPorts()
        
        // reset local results
        
        receivedEvents = []
        
        wait(sec: 0.5)
        
        print("RoundTrip_Tests setUp() done")
    }
    
    func createPorts() {
        print("RoundTrip_Tests createPorts() starting")
        
        // add new output endpoint
        
        do {
            try manager.addOutput(
                name: "MIDIKit Round Trip Tests Output",
                tag: outputTag,
                uniqueID: .adHoc // allow system to generate random ID each time, without persistence
            )
        } catch let err as MIDIIOError {
            XCTFail(err.localizedDescription); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
        
        guard let output = manager.managedOutputs[outputTag] else {
            XCTFail("Could not reference managed output.")
            return
        }
        
        guard let outputID = output.uniqueID else {
            XCTFail("Could not reference managed output.")
            return
        }
        
        wait(sec: 0.2)
        
        // output connection
        
        do {
            try manager.addInputConnection(
                toOutputs: [.uniqueID(outputID)],
                tag: inputConnectionTag,
                receiveHandler: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false)
                    { events in
                        self.receivedEvents.append(contentsOf: events)
                    }
            )
        } catch let err as MIDIIOError {
            XCTFail("\(err)"); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
        
        XCTAssertNotNil(manager.managedInputConnections[inputConnectionTag])
        
        print("RoundTrip_Tests createPorts() done")
    }
    
    override open func tearDown() {
        print("RoundTrip_Tests tearDown starting")
        
        // remove endpoints
        
        manager.remove(.output, .withTag(outputTag))
        XCTAssertNil(manager.managedOutputs[outputTag])
        
        manager.remove(.inputConnection, .withTag(inputConnectionTag))
        XCTAssertNil(manager.managedInputConnections[inputConnectionTag])
        
        manager = nil
        wait(sec: 0.3)
        
        print("RoundTrip_Tests tearDown done")
    }
    
    // ------------------------------------------------------------
    
    func runRapidMIDIEvents() throws {
        print("RoundTrip_Tests runRapidMIDIEvents() starting")
        
        guard let output = manager.managedOutputs[outputTag] else {
            XCTFail("Could not reference managed output.")
            return
        }
        
        // generate events list
        
        var sourceEvents: [MIDIEvent] = []
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .noteOn(
                $0.toUInt7,
                velocity: .midi1((1 ... 0x7F).randomElement()!),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .noteOff(
                $0.toUInt7,
                velocity: .midi1((0 ... 0x7F).randomElement()!),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .cc(
                $0.toUInt7,
                value: .midi1((0 ... 0x7F).randomElement()!),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .notePressure(
                note: $0.toUInt7,
                amount: .midi1(20),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .programChange(
                program: $0.toUInt7,
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 100).map { _ in
            .pitchBend(
                value: .midi1((0 ... 16383).randomElement()!.toUInt14),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(contentsOf: (0 ... 127).map {
            .pressure(
                amount: .midi1($0.toUInt7),
                channel: (0 ... 0xF).randomElement()!
            )
        })
        
        sourceEvents.append(
            .sysEx7(
                manufacturer: .educational(),
                data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                       0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                       0x0D]
            )
        )
        
        sourceEvents.append(
            .universalSysEx7(
                universalType: .realTime,
                deviceID: 0x01,
                subID1: 0x02,
                subID2: 0x03,
                data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                       0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                       0x0D]
            )
        )
        
        // add MIDI 2.0-only events if applicable
        if output.api == .newCoreMIDI(._2_0) {
            sourceEvents.append(contentsOf: (0 ... 127).map {
                .noteOn(
                    $0.toUInt7,
                    velocity: .midi1((1 ... 0x7F).randomElement()!),
                    attribute: .pitch7_9(coarse: 123, fine: 456),
                    channel: (0 ... 0xF).randomElement()!,
                    group: (0 ... UInt4.max).randomElement()!
                )
            })
            
            sourceEvents.append(contentsOf: (0 ... 127).map {
                .noteOff(
                    $0.toUInt7,
                    velocity: .midi1((0 ... 0x7F).randomElement()!),
                    attribute: .profileSpecific(data: 0x1234),
                    channel: (0 ... 0xF).randomElement()!,
                    group: (0 ... UInt4.max).randomElement()!
                )
            })
            
            sourceEvents.append(contentsOf: (0 ... 127).map {
                .noteCC(
                    note: $0.toUInt7,
                    controller: .registered(.expression),
                    value: .midi2((0 ... UInt32.max).randomElement()!),
                    channel: (0 ... 0xF).randomElement()!,
                    group: (0 ... UInt4.max).randomElement()!
                )
            })
            
            sourceEvents.append(contentsOf: (0 ... 127).map {
                .notePitchBend(
                    note: $0.toUInt7,
                    value: .midi2((0 ... UInt32.max).randomElement()!),
                    channel: (0 ... 0xF).randomElement()!,
                    group: (0 ... UInt4.max).randomElement()!
                )
            })
            
            sourceEvents.append(contentsOf: (0 ... 127).map {
                .noteManagement(
                    note: $0.toUInt7,
                    flags: [.resetPerNoteControllers],
                    channel: (0 ... 0xF).randomElement()!,
                    group: (0 ... UInt4.max).randomElement()!
                )
            })
            
            sourceEvents.append(
                .sysEx8(
                    manufacturer: .educational(),
                    data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                           0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                           0xE6]
                )
            )
            
            sourceEvents.append(
                .universalSysEx8(
                    universalType: .realTime,
                    deviceID: 0x01,
                    subID1: 0x02,
                    subID2: 0x03,
                    data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                           0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                           0xE6]
                )
            )
            
            sourceEvents.append(contentsOf: (0x0 ... 0xF).map {
                .noOp(group: $0)
            })
            
            sourceEvents.append(contentsOf: (0x0 ... 0xF).map {
                .jrClock(time: 0x4321, group: $0)
            })
            
            sourceEvents.append(contentsOf: (0x0 ... 0xF).map {
                .jrTimestamp(time: 0x4321, group: $0)
            })
        }
        
        sourceEvents.shuffle()
        
        // rapidly transmit events from output to input connection
        // to ensure rigor
        
        receivedEvents.reserveCapacity(sourceEvents.count)
        
        // send several events at once to test packing
        // multiple packets into a single MIDIPacketList / MIDIEventList
        for eventGroup in sourceEvents.split(every: 2) {
            try output.send(events: Array(eventGroup))
        }
        
        wait(sec: 0.5)
        
        // ensure all events are received correctly
        
        XCTAssertEqual(sourceEvents.count, receivedEvents.count)
        
        let isEventsEqual = sourceEvents == receivedEvents
        
        if !isEventsEqual {
            XCTFail("Source events and received events are not equal.")
            print("Sent \(sourceEvents.count) events, received \(receivedEvents.count) events.")
            
            // itemize which source event(s) are missing from the received events, if any.
            // this may reveal events that failed silently, were eaten by Core MIDI, or could not be parsed by the receiver.
            sourceEvents.forEach {
                if !receivedEvents.contains($0) {
                    print("Missing from received events:", $0)
                }
            }
            
            // itemize which received events do not exist in source event(s), if any.
            // this may catch any potentially malformed events.
            receivedEvents.forEach {
                if !sourceEvents.contains($0) {
                    print("Present in received events but not source events:", $0)
                }
            }
        }
        
        print("RoundTrip_Tests runRapidMIDIEvents() done")
    }
}

final class RoundTrip_OldCoreMIDIAPI_Tests: RoundTrip_Tests_Base {
    func testRapidMIDIEvents_OldCoreMIDIAPI() throws {
        manager.preferredAPI = .legacyCoreMIDI
        wait(sec: 0.5)
        createPorts()
        wait(sec: 0.5)
        try runRapidMIDIEvents()
    }
}

final class RoundTrip_NewCoreMIDIAPI_1_0_Protocol_Tests: RoundTrip_Tests_Base {
    func testRapidMIDIEvents_NewCoreMIDIAPI_1_0_Protocol() throws {
        manager.preferredAPI = .newCoreMIDI(._1_0)
        wait(sec: 0.5)
        createPorts()
        wait(sec: 0.5)
        try runRapidMIDIEvents()
    }
}

final class RoundTrip_NewCoreMIDIAPI_2_0_Protocol_Tests: RoundTrip_Tests_Base {
    func testRapidMIDIEvents_NewCoreMIDIAPI_2_0_Protocol() throws {
        manager.preferredAPI = .newCoreMIDI(._2_0)
        wait(sec: 0.5)
        createPorts()
        wait(sec: 0.5)
        try runRapidMIDIEvents()
    }
}

#endif
