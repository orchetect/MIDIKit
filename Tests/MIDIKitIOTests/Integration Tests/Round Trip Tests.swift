//
//  Round Trip Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite(.serialized) @MainActor class RoundTrip_Tests_Base {
    // swiftformat:options --wrapcollections preserve
    
    fileprivate var manager: MIDIManager!
    
    fileprivate let outputTag = "1"
    fileprivate let inputConnectionTag = "2"
    
    fileprivate var receivedEvents: [MIDIEvent] = []
    
    // called before each method
    init() async throws {
        print("RoundTrip_Tests init starting")
        
        try await Task.sleep(seconds: 0.500)
        
        manager = .init(
            clientName: "MIDIKit_IO_RoundTrip_Input_Tests",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        // start midi client
        
        do {
            try manager.start()
        } catch {
            Issue.record("Could not start MIDIManager. \(error.localizedDescription)")
            return
        }
        
        try await Task.sleep(seconds: 0.500)
        
        try await createPorts()
        
        // reset local results
        
        receivedEvents = []
        
        try await Task.sleep(seconds: 0.500)
        
        print("RoundTrip_Tests init done")
    }
    
    func createPorts() async throws {
        print("RoundTrip_Tests createPorts() starting")
        
        // add new output endpoint
        
        try manager.addOutput(
            name: "MIDIKit Round Trip Tests Output",
            tag: outputTag,
            uniqueID: .adHoc // allow system to generate random ID each time, no persistence
        )
        
        let output = try #require(manager.managedOutputs[outputTag])
        
        let outputID = try #require(output.uniqueID)
        
        try await Task.sleep(seconds: 0.200)
        
        // output connection
        
        try manager.addInputConnection(
            to: .outputs(matching: [.uniqueID(outputID)]),
            tag: inputConnectionTag,
            receiver: .events { events, _, _ in
                DispatchQueue.main.async {
                    self.receivedEvents.append(contentsOf: events)
                }
            }
        )
        
        #expect(manager.managedInputConnections[inputConnectionTag] != nil)
        
        print("RoundTrip_Tests createPorts() done")
    }
    
    func takedown() {
        print("RoundTrip_Tests tearDown starting")
        
        // remove endpoints
        
        manager.remove(.output, .withTag(outputTag))
        #expect(manager.managedOutputs[outputTag] == nil)
        
        manager.remove(.inputConnection, .withTag(inputConnectionTag))
        #expect(manager.managedInputConnections[inputConnectionTag] == nil)
        
        manager = nil
        
        print("RoundTrip_Tests tearDown done")
    }
    
    // ------------------------------------------------------------
    
    func runRapidMIDIEvents() async throws {
        print("RoundTrip_Tests runRapidMIDIEvents() starting")
        
        let output = try #require(manager.managedOutputs[outputTag])
        
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
        
        try sourceEvents.append(
            .sysEx7(
                manufacturer: .educational(),
                data: [0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
                       0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C,
                       0x0D]
            )
        )
        
        try sourceEvents.append(
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
        if output.api == .newCoreMIDI(.midi2_0) {
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
        
        try await Task.sleep(seconds: 1.0)
        
        // ensure all events are received correctly
        
        #expect(sourceEvents.count == receivedEvents.count)
        
        let isEventsEqual = sourceEvents == receivedEvents
        
        if !isEventsEqual {
            Issue.record("Source events and received events are not equal.")
            print("Sent \(sourceEvents.count) events, received \(receivedEvents.count) events.")
            
            // itemize which source event(s) are missing from the received events, if any.
            // this may reveal events that failed silently, were eaten by Core MIDI, or could not be
            // parsed by the receiver.
            for sourceEvent in sourceEvents {
                if !receivedEvents.contains(sourceEvent) {
                    print("Missing from received events:", sourceEvent)
                }
            }
            
            // itemize which received events do not exist in source event(s), if any.
            // this may catch any potentially malformed events.
            for receivedEvent in receivedEvents {
                if !sourceEvents.contains(receivedEvent) {
                    print("Present in received events but not source events:", receivedEvent)
                }
            }
        }
        
        print("RoundTrip_Tests runRapidMIDIEvents() done")
    }
    
    // MARK: - Tests
    
    @Test(arguments: [.legacyCoreMIDI, .newCoreMIDI(.midi1_0), .newCoreMIDI(.midi2_0)] as [CoreMIDIAPIVersion])
    func rapidMIDIEvents(api: CoreMIDIAPIVersion) async throws {
        manager.preferredAPI = api
        try await Task.sleep(seconds: 0.500)
        try await createPorts()
        try await Task.sleep(seconds: 0.500)
        try await runRapidMIDIEvents()
        takedown()
    }
}

#endif
