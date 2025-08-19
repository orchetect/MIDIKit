//
//  RPN NRPN IO Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if !targetEnvironment(simulator)

import CoreMIDI
import MIDIKitInternals
@testable import MIDIKitIO
import Testing

/// These tests are meant to test the translation Core MIDI performs between legacy MIDI 1.0 packets
/// and MIDI 2.0 UMP packets
@Suite(.serialized) struct RPN_NRPN_IO_Tests {
    private final actor Receiver {
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        private var managerLegacyAPI: MIDIManager!
        private var managerNewAPI: MIDIManager!
        
        /// Two managers are needed because we're testing sending events between
        /// legacy MIDI 1.0 Core MIDI API and new MIDI 2.0 Core MIDI API.
        func setupManagers() async throws {
            print("NRPN_IO_Tests setupManagers() starting")
            
            let isStable = isSystemTimingStable()
            
            managerLegacyAPI = MIDIManager(
                clientName: "MIDIKit_IO_NRPN_Tests_LegacyAPI",
                model: "MIDIKit123",
                manufacturer: "MIDIKit"
            )
            managerLegacyAPI.preferredAPI = .legacyCoreMIDI
            
            managerNewAPI = MIDIManager(
                clientName: "MIDIKit_IO_NRPN_Tests_NewAPI",
                model: "MIDIKit123",
                manufacturer: "MIDIKit"
            )
            managerNewAPI.preferredAPI = .newCoreMIDI(.midi2_0)
            
            // start midi clients
            
            try managerLegacyAPI.start()
            try managerNewAPI.start()
            
            try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
            
            print("NRPN_IO_Tests setupManagers() done")
        }
        
        func createOutputNew() throws { try createOutput(on: managerNewAPI) }
        func createOutputLegacy() throws { try createOutput(on: managerLegacyAPI) }
        
        private func createOutput(on manager: MIDIManager) throws {
            print("Creating output \(outputName.quoted) on \(manager.clientName)")
            try manager.addOutput(
                name: outputName,
                tag: outputTag,
                uniqueID: .adHoc // allow system to generate random ID each time, no persistence
            )
        }
        
        func createInputConnectionNew(to endpoint: MIDIOutputEndpoint) throws {
            try createInputConnection(on: managerNewAPI, to: endpoint)
        }
        
        func createInputConnectionLegacy(to endpoint: MIDIOutputEndpoint) throws {
            try createInputConnection(on: managerLegacyAPI, to: endpoint)
        }
        
        private func createInputConnection(on manager: MIDIManager, to endpoint: MIDIOutputEndpoint) throws {
            print("Creating input connection to \(endpoint.displayName.quoted) on \(manager.clientName)")
            try manager.addInputConnection(
                to: .outputs([endpoint]),
                tag: inputConnectionTag,
                receiver: .events { [weak self] events, _, _ in
                    Task {
                        await self?.add(events: events)
                    }
                }
            )
        }
        
        func outputNew() throws -> MIDIOutput { try output(on: managerNewAPI) }
        func outputLegacy() throws -> MIDIOutput { try output(on: managerLegacyAPI) }
        
        private func output(on manager: MIDIManager) throws -> MIDIOutput {
            try #require(manager.managedOutputs[outputTag])
        }
    }
    
    static let outputName = "MIDIKit NRPN Output \(UUID().uuidString)"
    fileprivate static let outputTag = UUID().uuidString
    
    fileprivate static let inputConnectionTag = UUID().uuidString
    
    // called before each method
    init() async throws {
        try await Task.sleep(seconds: 0.5)
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_SinglePacketRPN_DataMSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test event")
        
        // single packet containing RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40, // CC 101 value 0x40 on channel 3
            0xB2, 0x64, 0x41, // CC 100 value 0x41
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        await wait(expect: { await receiver.events.count == 1 }, timeout: isStable ? 2.0 : 10.0)
        
        #expect(await receiver.events == [
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_SinglePacketRPN_DataMSBLSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test event")
        
        // single packet containing RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40, // CC 101 value 0x40 on channel 3
            0xB2, 0x64, 0x41, // CC 100 value 0x41
            0xB2, 0x06, 0x10, // data entry MSB value 0x10
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        await wait(expect: { await receiver.events.count == 2 }, timeout: isStable ? 2.0 : 10.0)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        #expect(await receiver.events == [
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x20), // adds LSB
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_MultiplePacketRPN_DataMSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test events")
        
        // multiple packets adding up to an RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40 // CC 101 value 0x40 on channel 3
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x64, 0x41 // CC 100 value 0x41
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        // Unit test de-flake:
        // Filter received events in order to ignore a spurious initial CC message.
        //
        // Often systems that run these unit tests are slow or bogged down, so the discrete MIDI 1.0
        // packets may be fired with slightly too much delay between packets.
        // Core MIDI allows individual CC 0,6,32,38,98,99,100,101 messages to be received from a
        // MIDI 1.0 device/endpoint and be delivered to a MIDI 2.0 consumer.
        // But Core MIDI also has a heuristic which attempts to detect a series of RPN/NRPN CC
        // messages in discrete packets -- but only if it receives these messages in short enough
        // succession with nearly no delay between them. Then it will drop the individual CC
        // messages and produce a single MIDI 2.0 RPN/NRPN UMP packet containing all of the
        // pertinent bytes.
        // However, what happens when the MIDI 1.0 packets are sent with too much delay between them
        // is Core MIDI will pass the first CC message through as-is, assuming that it is a discrete
        // CC message. but once it sees the second CC message that defines the 2nd message in a
        // 2-message RPN/NRPN header (CC 101 and CC 100, or CC 99 and CC 98) then it realizes that
        // this 2nd message and any Data Entry MSB (CC 0) that follows should be all packaged up
        // into a MIDI 2.0 RPN/NRPN UMP packet.
        // The result is that we receive either a CC 101 or 99, followed by the expected RPN/NRPN
        // event.
        // The solution for de-flaking the unit test is to just ignore all non-RPN/NRPN events.
        
        // wait(sec: 1.0)
        await wait(
            expect: {
                await receiver.events.filter(chanVoice: .keepType(.rpn)).count == 1
            },
            timeout: isStable ? 2.0 : 10.0
        )
        
        #expect(await receiver.events.filter(chanVoice: .keepType(.rpn)) == [
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_MultiplePacketRPN_DataMSBLSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test events")
        
        // multiple packets adding up to an RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40 // CC 101 value 0x40 on channel 3
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x64, 0x41 // CC 100 value 0x41
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        // Unit test de-flake:
        // Filter received events in order to ignore a spurious initial CC message.
        //
        // Often systems that run these unit tests are slow or bogged down, so the discrete MIDI 1.0
        // packets may be fired with slightly too much delay between packets.
        // Core MIDI allows individual CC 0,6,32,38,98,99,100,101 messages to be received from a
        // MIDI 1.0 device/endpoint and be delivered to a MIDI 2.0 consumer.
        // But Core MIDI also has a heuristic which attempts to detect a series of RPN/NRPN CC
        // messages in discrete packets -- but only if it receives these messages in short enough
        // succession with nearly no delay between them. Then it will drop the individual CC
        // messages and produce a single MIDI 2.0 RPN/NRPN UMP packet containing all of the
        // pertinent bytes.
        // However, what happens when the MIDI 1.0 packets are sent with too much delay between them
        // is Core MIDI will pass the first CC message through as-is, assuming that it is a discrete
        // CC message. but once it sees the second CC message that defines the 2nd message in a
        // 2-message RPN/NRPN header (CC 101 and CC 100, or CC 99 and CC 98) then it realizes that
        // this 2nd message and any Data Entry MSB (CC 0) that follows should be all packaged up
        // into a MIDI 2.0 RPN/NRPN UMP packet.
        // The result is that we receive either a CC 101 or 99, followed by the expected RPN/NRPN
        // event.
        // The solution for de-flaking the unit test is to just ignore all non-RPN/NRPN events.
        
        // wait(sec: 1.0)
        await wait(
            expect: {
                await receiver.events.filter(chanVoice: .keepType(.rpn)).count == 2
            },
            timeout: isStable ? 1.0 : 5.0
        )
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        #expect(await receiver.events.filter(chanVoice: .keepType(.rpn)) == [
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
            .rpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x20), // adds LSB
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
}

// MARK: - NRPN Tests

extension RPN_NRPN_IO_Tests {
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_SinglePacketNRPN_DataMSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test event")
        
        // single packet containing NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
            0xB2, 0x62, 0x41, // CC 98 value 0x41
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        // wait(sec: 1.0)
        await wait(expect: { await receiver.events.count == 1 }, timeout: isStable ? 2.0 : 10.0)
        
        #expect(await receiver.events == [
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_SinglePacketNRPN_DataMSBLSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test event")
        
        // single packet containing NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
            0xB2, 0x62, 0x41, // CC 98 value 0x41
            0xB2, 0x06, 0x10, // data entry MSB value 0x10
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        await wait(expect: { await receiver.events.count == 2 }, timeout: isStable ? 2.0 : 10.0)
        print("Event received count:", await receiver.events.count)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        #expect(await receiver.events == [
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x20), // adds LSB
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_MultiplePacketNRPN_DataMSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test events")
        
        // multiple packets adding up to an NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40 // CC 99 value 0x40 on channel 3
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x62, 0x41 // CC 98 value 0x41
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        // Unit test de-flake:
        // Filter received events in order to ignore a spurious initial CC message.
        //
        // Often systems that run these unit tests are slow or bogged down, so the discrete MIDI 1.0
        // packets may be fired with slightly too much delay between packets.
        // Core MIDI allows individual CC 0,6,32,38,98,99,100,101 messages to be received from a
        // MIDI 1.0 device/endpoint and be delivered to a MIDI 2.0 consumer.
        // But Core MIDI also has a heuristic which attempts to detect a series of RPN/NRPN CC
        // messages in discrete packets -- but only if it receives these messages in short enough
        // succession with nearly no delay between them. Then it will drop the individual CC
        // messages and produce a single MIDI 2.0 RPN/NRPN UMP packet containing all of the
        // pertinent bytes.
        // However, what happens when the MIDI 1.0 packets are sent with too much delay between them
        // is Core MIDI will pass the first CC message through as-is, assuming that it is a discrete
        // CC message. but once it sees the second CC message that defines the 2nd message in a
        // 2-message RPN/NRPN header (CC 101 and CC 100, or CC 99 and CC 98) then it realizes that
        // this 2nd message and any Data Entry MSB (CC 0) that follows should be all packaged up
        // into a MIDI 2.0 RPN/NRPN UMP packet.
        // The result is that we receive either a CC 101 or 99, followed by the expected RPN/NRPN
        // event.
        // The solution for de-flaking the unit test is to just ignore all non-RPN/NRPN events.
        
        await wait(
            expect: {
                await receiver.events.filter(chanVoice: .keepType(.nrpn)).count == 1
            },
            timeout: isStable ? 2.0 : 10.0
        )
        
        #expect(await receiver.events.filter(chanVoice: .keepType(.nrpn)) == [
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
    
    @Test(.enabled(if: !shouldSkip))
    func legacyAPIToNewAPI_MultiplePacketNRPN_DataMSBLSB() async throws {
        let isStable = isSystemTimingStable()
        
        let receiver = Receiver()
        try await receiver.setupManagers()
        
        try await receiver.createOutputLegacy()
        let output = try await receiver.outputLegacy()
        
        try await receiver.createInputConnectionNew(to: output.endpoint)
        
        try await Task.sleep(seconds: isStable ? 0.3 : 2.0)
        
        print("Sending test events")
        
        // multiple packets adding up to an NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40 // CC 99 value 0x40 on channel 3
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x62, 0x41 // CC 98 value 0x41
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        try output.send(rawMessage: [
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        // Unit test de-flake:
        // Filter received events in order to ignore a spurious initial CC message.
        //
        // Often systems that run these unit tests are slow or bogged down, so the discrete MIDI 1.0
        // packets may be fired with slightly too much delay between packets.
        // Core MIDI allows individual CC 0,6,32,38,98,99,100,101 messages to be received from a
        // MIDI 1.0 device/endpoint and be delivered to a MIDI 2.0 consumer.
        // But Core MIDI also has a heuristic which attempts to detect a series of RPN/NRPN CC
        // messages in discrete packets -- but only if it receives these messages in short enough
        // succession with nearly no delay between them. Then it will drop the individual CC
        // messages and produce a single MIDI 2.0 RPN/NRPN UMP packet containing all of the
        // pertinent bytes.
        // However, what happens when the MIDI 1.0 packets are sent with too much delay between them
        // is Core MIDI will pass the first CC message through as-is, assuming that it is a discrete
        // CC message. but once it sees the second CC message that defines the 2nd message in a
        // 2-message RPN/NRPN header (CC 101 and CC 100, or CC 99 and CC 98) then it realizes that
        // this 2nd message and any Data Entry MSB (CC 0) that follows should be all packaged up
        // into a MIDI 2.0 RPN/NRPN UMP packet.
        // The result is that we receive either a CC 101 or 99, followed by the expected RPN/NRPN
        // event.
        // The solution for de-flaking the unit test is to just ignore all non-RPN/NRPN events.
        
        await wait(
            expect: {
                await receiver.events.filter(chanVoice: .keepType(.nrpn)).count == 2
            },
            timeout: isStable ? 2.0 : 10.0
        )
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        #expect(await receiver.events.filter(chanVoice: .keepType(.nrpn)) == [
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x00),
                channel: 0x02
            ),
            .nrpn(
                parameter: .init(msb: 0x40, lsb: 0x41),
                data: (msb: 0x10, lsb: 0x20), // adds LSB
                channel: 0x02
            )
        ])
        
        // dump(receiver.events)
        
        print("Done")
    }
}

// MARK: - Helpers

fileprivate let shouldSkip: Bool = {
    let legacyManager = MIDIManager(
        clientName: "MIDIKit_IO_NRPN_Tests_SkipCheck_LegacyAPI",
        model: "MIDIKit123",
        manufacturer: "MIDIKit"
    )
    legacyManager.preferredAPI = .legacyCoreMIDI
    guard legacyManager.preferredAPI == .legacyCoreMIDI else {
        // Test cannot be run on this platform.
        return true
    }
    
    let newManager = MIDIManager(
        clientName: "MIDIKit_IO_NRPN_Tests_SkipCheck_NewAPI",
        model: "MIDIKit123",
        manufacturer: "MIDIKit"
    )
    newManager.preferredAPI = .newCoreMIDI(.midi2_0)
    guard newManager.preferredAPI == .newCoreMIDI(.midi2_0) else {
        // Test cannot be run on this platform.
        return true
    }
    
    return false
}()

#endif
