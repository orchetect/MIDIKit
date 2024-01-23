//
//  RPN NRPN IO Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

// iOS Simulator XCTest testing does not give enough permissions to allow creating virtual MIDI
// ports, so skip these tests on iOS targets
#if shouldTestCurrentPlatform && !targetEnvironment(simulator)

import CoreMIDI
@testable import MIDIKitIO
import XCTest

/// These tests are meant to test the translation Core MIDI performs between legacy MIDI 1.0 packets
/// and MIDI 2.0 UMP packets
@available(macOS 10.15, macCatalyst 13, iOS 13, /* tvOS 13, watchOS 6, */ *)
final class RPN_NRPN_IO_Tests: XCTestCase {
    fileprivate var managerLegacyAPI: MIDIManager!
    fileprivate var managerNewAPI: MIDIManager!
    
    let outputName = "MIDIKit NRPN Output"
    fileprivate let outputTag = "1"
    
    fileprivate let inputConnectionTag = "2"
    
    fileprivate var receivedEvents: [MIDIEvent] = []
    
    // called before each method
    override func setUpWithError() throws {
        print("NRPN_IO_Tests setUpWithError() starting")
        
        // reset local results
        receivedEvents = []
        
        // two managers are needed because we're testing sending events between
        // legacy MIDI 1.0 Core MIDI API and new MIDI 2.0 Core MIDI API.
        try setupManagers()
        
        print("NRPN_IO_Tests setUpWithError() done")
    }
    
    override func tearDown() {
        print("NRPN_IO_Tests tearDown() starting")
        
        managerLegacyAPI.removeAll()
        managerNewAPI.removeAll()
        
        managerLegacyAPI = nil
        managerNewAPI = nil
        
        wait(sec: 0.3)
        
        print("NRPN_IO_Tests tearDown() done")
    }
    
    func setupManagers() throws {
        print("NRPN_IO_Tests setupManagers() starting")
        
        managerLegacyAPI = ObservableMIDIManager(
            clientName: "MIDIKit_IO_NRPN_Tests_LegacyAPI",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        managerLegacyAPI.preferredAPI = .legacyCoreMIDI
        
        guard managerLegacyAPI.preferredAPI == .legacyCoreMIDI else {
            throw XCTSkip("Test cannot be run on this platform.")
        }
        
        managerNewAPI = ObservableMIDIManager(
            clientName: "MIDIKit_IO_NRPN_Tests_NewAPI",
            model: "MIDIKit123",
            manufacturer: "MIDIKit"
        )
        
        managerNewAPI.preferredAPI = .newCoreMIDI(.midi2_0)
        
        guard managerNewAPI.preferredAPI == .newCoreMIDI(.midi2_0) else {
            throw XCTSkip("Test cannot be run on this platform.")
        }
        
        // start midi clients
        
        do {
            try managerLegacyAPI.start()
            try managerNewAPI.start()
        } catch {
            XCTFail("Could not start MIDIManager. \(error.localizedDescription)")
            return
        }
        
        wait(sec: 0.3)
        
        print("NRPN_IO_Tests setupManagers() done")
    }
    
    func createOutput(on manager: MIDIManager) {
        print("Creating output \(outputName) on \(manager.clientName)")
        do {
            try manager.addOutput(
                name: outputName,
                tag: outputTag,
                uniqueID: .adHoc // allow system to generate random ID each time, no persistence
            )
        } catch let err as MIDIIOError {
            XCTFail(err.localizedDescription); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
    }
    
    func createInputConnection(on manager: MIDIManager, to endpoint: MIDIOutputEndpoint) {
        print("Creating input connection to \(endpoint.displayName) on \(manager.clientName)")
        do {
            try manager.addInputConnection(
                to: .outputs([endpoint]),
                tag: inputConnectionTag,
                receiver: .events { [weak self] events, _, _ in
                    DispatchQueue.main.async {
                        self?.receivedEvents.append(contentsOf: events)
                    }
                }
            )
        } catch let err as MIDIIOError {
            XCTFail("\(err)"); return
        } catch {
            XCTFail(error.localizedDescription); return
        }
    }
    
    func output(on manager: MIDIManager) throws -> MIDIOutput {
        try XCTUnwrap(manager.managedOutputs[outputTag])
    }
    
    // MARK: - RPN Tests
    
    func testLegacyAPIToNewAPI_SinglePacketRPN_DataMSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
        print("Sending test event")
        
        // single packet containing RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40, // CC 101 value 0x40 on channel 3
            0xB2, 0x64, 0x41, // CC 100 value 0x41
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        // wait(sec: 1.0)
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x00),
                 channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_SinglePacketRPN_DataMSBLSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
        print("Sending test event")
        
        // single packet containing RPN
        
        try output.send(rawMessage: [
            0xB2, 0x65, 0x40, // CC 101 value 0x40 on channel 3
            0xB2, 0x64, 0x41, // CC 100 value 0x41
            0xB2, 0x06, 0x10, // data entry MSB value 0x10
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        // wait(sec: 1.0)
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x00),
                 channel: 0x02),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x20), // adds LSB
                 channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_MultiplePacketRPN_DataMSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
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
        func filteredEvents() -> [MIDIEvent] {
            receivedEvents.filter(chanVoice: .keepType(.rpn))
        }
        
        // wait(sec: 1.0)
        wait(for: filteredEvents().count == 1, timeout: 1.0)
        
        XCTAssertEqual(filteredEvents(), [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x00),
                 channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_MultiplePacketRPN_DataMSBLSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
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
        func filteredEvents() -> [MIDIEvent] {
            receivedEvents.filter(chanVoice: .keepType(.rpn))
        }
        
        // wait(sec: 1.0)
        wait(for: filteredEvents().count == 2, timeout: 1.0)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        XCTAssertEqual(filteredEvents(), [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x00),
                 channel: 0x02),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41),
                 data: (msb: 0x10, lsb: 0x20), // adds LSB
                 channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    // MARK: - NRPN Tests
    
    func testLegacyAPIToNewAPI_SinglePacketNRPN_DataMSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
        print("Sending test event")
        
        // single packet containing NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
            0xB2, 0x62, 0x41, // CC 98 value 0x41
            0xB2, 0x06, 0x10 // data entry MSB value 0x10
        ])
        
        // wait(sec: 1.0)
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x00),
                  channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_SinglePacketNRPN_DataMSBLSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
        print("Sending test event")
        
        // single packet containing NRPN
        
        try output.send(rawMessage: [
            0xB2, 0x63, 0x40, // CC 99 value 0x40 on channel 3
            0xB2, 0x62, 0x41, // CC 98 value 0x41
            0xB2, 0x06, 0x10, // data entry MSB value 0x10
            0xB2, 0x26, 0x20 // data entry LSB value 0x20
        ])
        
        // wait(sec: 1.0)
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x00),
                  channel: 0x02),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x20), // adds LSB
                  channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_MultiplePacketNRPN_DataMSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
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
        func filteredEvents() -> [MIDIEvent] {
            receivedEvents.filter(chanVoice: .keepType(.nrpn))
        }
        
        // wait(sec: 1.0)
        wait(for: filteredEvents().count == 1, timeout: 1.0)
        
        XCTAssertEqual(filteredEvents(), [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x00),
                  channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
    
    func testLegacyAPIToNewAPI_MultiplePacketNRPN_DataMSBLSB() throws {
        createOutput(on: managerLegacyAPI)
        
        let output = try output(on: managerLegacyAPI)
        
        createInputConnection(on: managerNewAPI, to: output.endpoint)
        
        wait(sec: 0.3)
        
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
        func filteredEvents() -> [MIDIEvent] {
            receivedEvents.filter(chanVoice: .keepType(.nrpn))
        }
        
        // wait(sec: 1.0)
        wait(for: filteredEvents().count == 2, timeout: 1.0)
        
        // Core MIDI translates MIDI 1.0 NRPN to a MIDI 2.0 UMP packet with MSB first,
        // then a second UMP packet adding the LSB to the same base packet data.
        XCTAssertEqual(filteredEvents(), [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x00),
                  channel: 0x02),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41),
                  data: (msb: 0x10, lsb: 0x20), // adds LSB
                  channel: 0x02)
        ])
        
        dump(receivedEvents)
        
        print("Done")
    }
}

#endif
