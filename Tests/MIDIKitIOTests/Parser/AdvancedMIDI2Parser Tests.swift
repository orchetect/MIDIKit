//
//  AdvancedMIDI2Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite @MainActor class AdvancedMIDI2Parser_Tests: Sendable {
    // MARK: - State
    
    fileprivate var parser: AdvancedMIDI2Parser!
    fileprivate var receivedEvents: [MIDIEvent] = []
    
    init() throws {
        parser = AdvancedMIDI2Parser { [self] events, _, _ in
            Task { @MainActor in
                receivedEvents.append(contentsOf: events)
            }
        }
    }
}

// MARK: - Tests

extension AdvancedMIDI2Parser_Tests {
    @Test
    func basic() async throws {
        let inputEvents: [MIDIEvent] = [
            .cc(1, value: .midi1(64), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        #expect(receivedEvents == inputEvents)
    }
    
    // MARK: - RPN
    
    @Test
    func holdOff_RPN_DataEntryMSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        #expect(receivedEvents == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOff_RPN_DataEntryMSBAndLSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // no bundling active, so events will just pass-thru as-is
        #expect(receivedEvents == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    @Test
    func holdOn_RPN_DataEntryMSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        #expect(receivedEvents == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_RPN_DataEntryMSBAndLSB_Together() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_RPN_DataEntryMSBAndLSB_Apart() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_RPN_DataEntryMSB_Duplicate_Together() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_RPN_DataEntryMSB_Duplicate_Apart() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    // MARK: - NRPN
    
    @Test
    func holdOff_NRPN_DataEntryMSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        #expect(receivedEvents == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOff_NRPN_DataEntryMSBAndLSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // no bundling active, so events will just pass-thru as-is
        #expect(receivedEvents == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    @Test
    func holdOn_NRPN_DataEntryMSB() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        #expect(receivedEvents == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_NRPN_DataEntryMSBAndLSB_Together() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_NRPN_DataEntryMSBAndLSB_Apart() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 1 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_NRPN_DataEntryMSB_Duplicate_Together() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_NRPN_DataEntryMSB_Duplicate_Apart() async throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.200) // allow time for extra events if a bug exists
        try await wait(require: { await receivedEvents.count == 2 }, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(receivedEvents == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
}

#endif
