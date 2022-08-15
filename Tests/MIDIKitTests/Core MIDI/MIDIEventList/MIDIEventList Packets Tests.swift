//
//  MIDIEventList Packets Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform && !os(tvOS) && !os(watchOS)

import XCTest
@testable import MIDIKit
import CoreMIDI

final class MIDIEventListPackets_Tests: XCTestCase {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    func testSinglePacketWithOneUMP() throws {
        guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
        else { return }
    
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
    
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234]], // MIDI 2.0 Note On (2 words)
            timeStamp: timeStamp
        )
    
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
    
            XCTAssertEqual(
                packets.map { $0.bytes },
                [[0x41, 0x91, 0x3C, 0x02,
                  0x80, 0x00, 0x12, 0x34]]
            )
    
            XCTAssertEqual(
                packets.map { $0.timeStamp },
                [timeStamp]
            )
        }
    
        check(&eventList)
    }
    
    func testSinglePacketWithMultipleUMPs() throws {
        guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
        else { return }
    
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
    
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234,   // MIDI 2.0 Note On (2 words)
                     0x43B1_0100, 0x1234_5678]], // CC (2 words)
            timeStamp: timeStamp
        )
    
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
    
            XCTAssertEqual(
                packets.map { $0.bytes },
                [[0x41, 0x91, 0x3C, 0x02,
                  0x80, 0x00, 0x12, 0x34],
                 [0x43, 0xB1, 0x01, 0x00,
                  0x12, 0x34, 0x56, 0x78]]
            )
    
            XCTAssertEqual(
                packets.map { $0.timeStamp },
                [timeStamp,
                 timeStamp]
            )
        }
    
        check(&eventList)
    }
    
    func testMultiplePacketsWithSingleUMPs() throws {
        guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
        else { return }
    
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
    
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234],  // MIDI 2.0 Note On (2 words)
                    [0x43B1_0100, 0x1234_5678]], // CC (2 words)
            timeStamp: timeStamp
        )
    
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
    
            XCTAssertEqual(
                packets.map { $0.bytes },
                [[0x41, 0x91, 0x3C, 0x02,
                  0x80, 0x00, 0x12, 0x34],
                 [0x43, 0xB1, 0x01, 0x00,
                  0x12, 0x34, 0x56, 0x78]]
            )
    
            XCTAssertEqual(
                packets.map { $0.timeStamp },
                [timeStamp,
                 timeStamp]
            )
        }
    
        check(&eventList)
    }
    
    func testMultiplePacketsWithMultipleUMPs() throws {
        guard #available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
        else { return }
    
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
    
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234,   // MIDI 2.0 Note On (2 words)
                     0x44CA_0000, 0x2000_0000],  // Program change (no bank select)
                    [0x43B1_0100, 0x1234_5678,   // CC (2 words)
                     0x45D8_0000, 0x1234_5678]], // Channel pressure
            timeStamp: timeStamp
        )
    
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
    
            XCTAssertEqual(
                packets.map { $0.bytes },
                [[0x41, 0x91, 0x3C, 0x02,
                  0x80, 0x00, 0x12, 0x34],
                 [0x44, 0xCA, 0x00, 0x00,
                  0x20, 0x00, 0x00, 0x00],
                 [0x43, 0xB1, 0x01, 0x00,
                  0x12, 0x34, 0x56, 0x78],
                 [0x45, 0xD8, 0x00, 0x00,
                  0x12, 0x34, 0x56, 0x78]]
            )
    
            XCTAssertEqual(
                packets.map { $0.timeStamp },
                [timeStamp,
                 timeStamp,
                 timeStamp,
                 timeStamp]
            )
        }
    
        check(&eventList)
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
    fileprivate func makeEventList(
        words: [[UMPWord]],
        timeStamp: MIDITimeStamp
    ) throws -> MIDIEventList {
        var eventList: MIDIEventList = .init()
        let packet = MIDIEventListInit(&eventList, ._2_0)
    
        for packetWords in words {
            MIDIEventListAdd(
                &eventList,
                1024,
                packet,
                timeStamp,
                packetWords.count,
                packetWords
            )
        }
    
        return eventList
    }
}

#endif
