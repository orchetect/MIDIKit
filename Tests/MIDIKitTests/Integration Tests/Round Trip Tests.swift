//
//  Round Trip Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI ports, so skip these tests on iOS targets
#if !os(watchOS) && !targetEnvironment(simulator)

import XCTest
import MIDIKit
import CoreMIDI

class RoundTrip_Tests_Base: XCTestCase {
    
    fileprivate var manager: MIDI.IO.Manager! = nil
    
    fileprivate let outputTag = "1"
    fileprivate let inputConnectionTag = "2"
    
    fileprivate var receivedEvents: [MIDI.Event] = []
    
    override func setUp() {
        
        print("RoundTrip_Tests setUp() starting")
        
        XCTWait(sec: 0.5)
        
        manager = .init(clientName: "MIDIKit_IO_RoundTrip_Input_Tests",
                        model: "MIDIKit123",
                        manufacturer: "MIDIKit")
        
        // start midi client
        
        do {
            try manager.start()
        } catch {
            XCTFail("Could not start MIDI Manager. \(error.localizedDescription)")
            return
        }
        
        XCTWait(sec: 0.3)
        
        createPorts()
        
        // reset local results
        
        receivedEvents = []
        
        XCTWait(sec: 0.5)
        
        print("RoundTrip_Tests setUp() done")
        
    }
    
    func createPorts() {
        
        print("RoundTrip_Tests createPorts() starting")
        
        // add new output endpoint
        
        do {
            try manager.addOutput(
                name: "MIDIKit Round Trip Tests Output",
                tag: outputTag,
                uniqueID: .none // allow system to generate random ID
            )
        } catch let err as MIDI.IO.MIDIError {
            XCTFail(err.localizedDescription) ; return
        } catch {
            XCTFail(error.localizedDescription) ; return
        }
        
        guard let output = manager.managedOutputs[outputTag] else {
            XCTFail("Could not reference managed output.")
            return
        }
        
        guard let outputID = output.uniqueID else {
            XCTFail("Could not reference managed output.")
            return
        }
        
        XCTWait(sec: 0.2)
        
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
        } catch let err as MIDI.IO.MIDIError {
            XCTFail("\(err)") ; return
        } catch {
            XCTFail(error.localizedDescription) ; return
        }
        
        XCTAssertNotNil(manager.managedInputConnections[inputConnectionTag])
        
        print("RoundTrip_Tests createPorts() done")
        
    }
    
    override func tearDown() {
        
        print("RoundTrip_Tests tearDown starting")
        
        // remove endpoints
        
        manager.remove(.output, .withTag(outputTag))
        XCTAssertNil(manager.managedOutputs[outputTag])
        
        manager.remove(.inputConnection, .withTag(inputConnectionTag))
        XCTAssertNil(manager.managedInputConnections[inputConnectionTag])
        
        manager = nil
        XCTWait(sec: 0.3)
        
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
        
        var sourceEvents: [MIDI.Event] = []
        
        sourceEvents.append(contentsOf: (0...127).map {
            .noteOn($0.toMIDIUInt7,
                    velocity: .midi1((1...0x7F).randomElement()!),
                    channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...127).map {
            .noteOff($0.toMIDIUInt7,
                     velocity: .midi1((0...0x7F).randomElement()!),
                     channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...127).map {
            .cc($0.toMIDIUInt7,
                value: .midi1((0...0x7F).randomElement()!),
                channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...127).map {
            .notePressure(note: $0.toMIDIUInt7,
                          amount: .midi1(20),
                          channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...127).map {
            .programChange(program: $0.toMIDIUInt7,
                           channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...100).map { _ in
            .pitchBend(value: .midi1((0...16383).randomElement()!.toMIDIUInt14),
                       channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.append(contentsOf: (0...127).map {
            .pressure(amount: .midi1($0.toMIDIUInt7),
                      channel: (0...0xF).randomElement()!)
        })
        
        sourceEvents.shuffle()
        
        // rapidly transmit events from output to input connection
        // to ensure rigor
        
        receivedEvents.reserveCapacity(sourceEvents.count)
        
        for event in sourceEvents {
            try output.send(event: event)
        }
        
        XCTWait(sec: 0.5)
        
        // ensure all events are received correctly
        
        XCTAssertEqual(sourceEvents.count, receivedEvents.count)
        
        XCTAssertEqual(sourceEvents, receivedEvents)
        
        print("RoundTrip_Tests runRapidMIDIEvents() done")
        
    }
    
}

final class RoundTrip_OldCoreMIDIAPI_Tests: RoundTrip_Tests_Base {
    
    func testRapidMIDIEvents_OldCoreMIDIAPI() throws {
        
        manager.preferredAPI = .legacyCoreMIDI
        XCTWait(sec: 0.5)
        createPorts()
        XCTWait(sec: 0.5)
        try runRapidMIDIEvents()
        
    }
    
}

final class RoundTrip_NewCoreMIDIAPI_1_0_Protocol_Tests: RoundTrip_Tests_Base {
    
    func testRapidMIDIEvents_NewCoreMIDIAPI_1_0_Protocol() throws {
        
        manager.preferredAPI = .newCoreMIDI(._1_0)
        XCTWait(sec: 0.5)
        createPorts()
        XCTWait(sec: 0.5)
        try runRapidMIDIEvents()
        
    }
    
}

final class RoundTrip_NewCoreMIDIAPI_2_0_Protocol_Tests: RoundTrip_Tests_Base {
    
#warning("> TODO: enable this test once MIDI 2.0 is fully implemented")
//    func testRapidMIDIEvents_NewCoreMIDIAPI_2_0_Protocol() throws {
//
//        manager.preferredAPI = .newCoreMIDI(._2_0)
//        XCTWait(sec: 0.5)
//        createPorts()
//        XCTWait(sec: 0.5)
//        try runRapidMIDIEvents()
//
//    }
    
}

#endif

