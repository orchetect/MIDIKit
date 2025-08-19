//
//  AdvancedMIDI2Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import Testing

@Suite struct AdvancedMIDI2Parser_Tests {
    private final actor Receiver {
        var parser: AdvancedMIDI2Parser
        func process(parsedEvents: inout [MIDIEvent]) { parser.process(parsedEvents: &parsedEvents) }
        
        var events: [MIDIEvent] = []
        func add(events: [MIDIEvent]) { self.events.append(contentsOf: events) }
        func reset() { events.removeAll() }
        
        init() {
            parser = AdvancedMIDI2Parser()
            parser.handleEvents = { [weak self] events, _, _ in
                Task {
                    await self?.add(events: events)
                }
            }
        }
    }
    
    private let receiver = Receiver()
    
    @Test
    func basic() async throws {
        let inputEvents: [MIDIEvent] = [
            .cc(1, value: .midi1(64), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        #expect(await receiver.events == inputEvents)
    }
    
    // MARK: - RPN
    
    @Test
    func holdOff_RPN_DataEntryMSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        #expect(await receiver.events == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOff_RPN_DataEntryMSBAndLSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // no bundling active, so events will just pass-thru as-is
        #expect(await receiver.events == inputEvents)
    }
    
    @Test
    func holdOn_RPN_DataEntryMSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        #expect(await receiver.events == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_RPN_DataEntryMSBAndLSB_Together() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_RPN_DataEntryMSBAndLSB_Apart() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        await receiver.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_RPN_DataEntryMSB_Duplicate_Together() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_RPN_DataEntryMSB_Duplicate_Apart() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    // MARK: - NRPN
    
    @Test
    func holdOff_NRPN_DataEntryMSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        #expect(await receiver.events == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOff_NRPN_DataEntryMSBAndLSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // no bundling active, so events will just pass-thru as-is
        #expect(await receiver.events == inputEvents)
    }
    
    @Test
    func holdOn_NRPN_DataEntryMSB() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        #expect(await receiver.events == inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_NRPN_DataEntryMSBAndLSB_Together() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    @Test
    func holdOn_NRPN_DataEntryMSBAndLSB_Apart() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        await receiver.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 1 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_NRPN_DataEntryMSB_Duplicate_Together() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        await receiver.process(parsedEvents: &events)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    @Test
    func holdOn_NRPN_DataEntryMSB_Duplicate_Apart() async throws {
        await receiver.parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        await receiver.process(parsedEvents: &events2)
        
        try await Task.sleep(seconds: 0.2) // allow time for extra events if a bug exists
        await wait(expect: { await receiver.events.count == 2 }, timeout: 10.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        #expect(await receiver.events == [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
}

#endif
