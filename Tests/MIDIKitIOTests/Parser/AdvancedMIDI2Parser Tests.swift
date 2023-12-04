//
//  AdvancedMIDI2Parser Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

@testable import MIDIKitIO
import XCTest

final class AdvancedMIDI2Parser_Tests: XCTestCase {
    // MARK: - State
    
    fileprivate var parser: AdvancedMIDI2Parser!
    fileprivate var receivedEvents: [MIDIEvent] = []
    
    override func setUpWithError() throws {
        parser = AdvancedMIDI2Parser { [self] events, _, _ in
            receivedEvents.append(contentsOf: events)
        }
        
        receivedEvents = []
    }
    
    // MARK: - Tests
    
    func testBasic() throws {
        let inputEvents: [MIDIEvent] = [
            .cc(1, value: .midi1(64), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        XCTAssertEqual(receivedEvents, inputEvents)
    }
    
    // MARK: - RPN
    
    func testHoldOff_RPN_DataEntryMSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        XCTAssertEqual(receivedEvents, inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOff_RPN_DataEntryMSBAndLSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // no bundling active, so events will just pass-thru as-is
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    func testHoldOn_RPN_DataEntryMSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        XCTAssertEqual(receivedEvents, inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOn_RPN_DataEntryMSBAndLSB_Together() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOn_RPN_DataEntryMSBAndLSB_Apart() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    func testHoldOn_RPN_DataEntryMSB_Duplicate_Together() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    func testHoldOn_RPN_DataEntryMSB_Duplicate_Apart() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .rpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    // MARK: - NRPN
    
    func testHoldOff_NRPN_DataEntryMSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        XCTAssertEqual(receivedEvents, inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOff_NRPN_DataEntryMSBAndLSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = false
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // no bundling active, so events will just pass-thru as-is
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    func testHoldOn_NRPN_DataEntryMSB() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: nil), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // we never received a 2nd UMP with Data Entry LSB, so hold timer should have expired and
        // let the single message through
        XCTAssertEqual(receivedEvents, inputEvents)
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOn_NRPN_DataEntryMSBAndLSB_Together() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// This mimics the two UMP events that Core MIDI will produce when
    /// translating MIDI 1.0 RPN to UMP when a Data Entry LSB is present.
    func testHoldOn_NRPN_DataEntryMSBAndLSB_Apart() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 1, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x20), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    func testHoldOn_NRPN_DataEntryMSB_Duplicate_Together() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        let inputEvents: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        
        var events = inputEvents
        parser.process(parsedEvents: &events)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
    
    /// Two PN events with 0 data entry LSB.
    func testHoldOn_NRPN_DataEntryMSB_Duplicate_Apart() throws {
        parser.bundleRPNAndNRPNDataEntryLSB = true
        
        var events1: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events1)
        
        var events2: [MIDIEvent] = [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ]
        parser.process(parsedEvents: &events2)
        
        wait(sec: 0.2) // allow time for extra events if a bug exists
        wait(for: receivedEvents.count == 2, timeout: 1.0)
        
        // bundleRPNAndNRPNDataEntryLSB should wait for 2nd UMP and bundle them together
        XCTAssertEqual(receivedEvents, [
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2),
            .nrpn(parameter: .init(msb: 0x40, lsb: 0x41), data: (msb: 0x10, lsb: 0x00), channel: 2)
        ])
    }
}

#endif
