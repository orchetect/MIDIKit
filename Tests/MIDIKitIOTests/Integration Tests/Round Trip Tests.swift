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

@Suite(.serialized) struct RoundTrip_Tests_Base {
    // swiftformat:options --wrapcollections preserve
    
    private static let outputTag = UUID().uuidString
    private static let inputConnectionTag = UUID().uuidString
    
    /// Note that there is an important distinction between making `Receiver` an actor itself,
    /// versus making it a class bound to a serial global actor. Making it an actor itself
    /// seems to imply concurrent (non-serial) behavior and the result is that calls to `Task { await ... }`
    /// could execute out of order, thus failing our unit test with incorrect received MIDI event order.
    /// `@MainActor` also works, but to keep it clean, we'll use our own actor.
    @TestActor private final class Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        let manager = MIDIManager(
            clientName: UUID().uuidString,
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        nonisolated init() { }
        
        func createPorts() async throws {
            print("RoundTrip_Tests createPorts() starting")
            
            // add new output endpoint
            
            try manager.addOutput(
                name: UUID().uuidString,
                tag: outputTag,
                uniqueID: .adHoc // allow system to generate random ID each time, no persistence
            )
            
            let output = try #require(manager.managedOutputs[outputTag])
            let outputID = try #require(output.uniqueID)
            
            try await Task.sleep(seconds: 0.2)
            
            // output connection
            
            try manager.addInputConnection(
                to: .outputs(matching: [.uniqueID(outputID)]),
                tag: inputConnectionTag,
                receiver: .events { [weak self] events, _, _ in
                    Task { @TestActor in
                        self?.add(events: events)
                    }
                }
            )
            
            try await Task.sleep(seconds: 0.5)
            
            print("RoundTrip_Tests createPorts() done")
        }
        
        func prep(forMessageCount count: Int) {
            events.reserveCapacity(count)
        }
    }
    
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.2)
    }
    
    // ------------------------------------------------------------
    
    @Test(arguments: [.legacyCoreMIDI, .newCoreMIDI(.midi1_0), .newCoreMIDI(.midi2_0)] as [CoreMIDIAPIVersion])
    func runRapidMIDIEvents(api: CoreMIDIAPIVersion) async throws {
        print("RoundTrip_Tests runRapidMIDIEvents() starting")
        
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        
        receiver.manager.preferredAPI = api
        try receiver.manager.start()
        try await Task.sleep(seconds: isStable ? 0.2 : 1.0)
        
        try await receiver.createPorts()
        try await Task.sleep(seconds: isStable ? 0.5 : 5.0)
        
        let output = try #require(receiver.manager.managedOutputs[Self.outputTag])
        
        // prepare - send a test event until one is received.
        // once received, Core MIDI is ready to continue the test.
        try await wait(
            require: {
                print("Sending test event")
                try output.send(event: .start())
                try await Task.sleep(seconds: 0.5)
                return await receiver.events.contains(.start())
            },
            timeout: 10.0,
            pollingInterval: 0.1
        )
        await receiver.reset() // remove test event
        
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
        
        await receiver.prep(forMessageCount: sourceEvents.count)
        
        print("Using \(sourceEvents.count) source MIDI events. Sending...")
        
        // Send several events at once to test packing
        // multiple packets into a single MIDIPacketList / MIDIEventList.
        // Core MIDI will start dropping events if too many are sent too quickly, as a failsafe against things like feedback loops,
        // so we want to throttle the send frequency.
        var sentEvents: [MIDIEvent] = []
        for eventGroup in sourceEvents.split(every: 2) {
            try output.send(events: Array(eventGroup))
            sentEvents.append(contentsOf: eventGroup)
            try await Task.sleep(seconds: isStable ? 0.002 : 0.005)
        }
        // sanity check - ensure events were sent in the correct order
        #expect(sentEvents == sourceEvents)
        
        print("Done sending.")
        
        try await Task.sleep(seconds: 1.0)
        
        // ensure all events are received correctly
        
        let sourceEventCount = sourceEvents.count
        await wait(expect: { await receiver.events.count >= sourceEventCount }, timeout: 30.0)
        
        let receivedEventCount = await receiver.events.count
        #expect(receivedEventCount == sourceEventCount)
        
        let isEventsEqual = await receiver.events == sourceEvents
        
        // sanity check - ensure there isn't something fundamentally wrong with event equatability
        #expect(sourceEvents == sourceEvents)
        
        if !isEventsEqual {
            Issue.record("Source events and received events are not equal. (\(api))")
            print("Sent \(sourceEvents.count) events, received \(receivedEventCount) events.")
            
            // itemize which source event(s) are missing from the received events, if any.
            // this may reveal events that failed silently, were eaten by Core MIDI, or could not be
            // parsed by the receiver.
            for sourceEvent in sourceEvents {
                if await !receiver.events.contains(sourceEvent) {
                    print("Missing from received events:", sourceEvent)
                }
            }
            
            // itemize which received events do not exist in source event(s), if any.
            // this may catch any potentially malformed events.
            for receivedEvent in await receiver.events {
                if !sourceEvents.contains(receivedEvent) {
                    print("Present in received events but not source events:", receivedEvent)
                }
            }
        }
        
        print("RoundTrip_Tests runRapidMIDIEvents() done")
    }
}

#endif
