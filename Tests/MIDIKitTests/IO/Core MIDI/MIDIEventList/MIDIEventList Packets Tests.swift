//
//  MIDIEventList Packets Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if shouldTestCurrentPlatform

import XCTest
@testable import MIDIKit
import CoreMIDI

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
final class MIDIEventListPackets_Tests: XCTestCase {
	
	func testSinglePacketWithOneUMP() throws {
        
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x41913C02, 0x80001234]], // MIDI 2.0 Note On (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
            
            XCTAssertEqual(packets.map { $0.bytes },
                           [[0x41, 0x91, 0x3C, 0x02,
                             0x80, 0x00, 0x12, 0x34]])
            
            XCTAssertEqual(packets.map { $0.timeStamp },
                           [timeStamp])
            
        }
        
        check(&eventList)
        
    }
    
    func testSinglePacketWithMultipleUMPs() throws {
        
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x41913C02, 0x80001234,   // MIDI 2.0 Note On (2 words)
                     0x43B10100, 0x12345678]], // CC (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
            
            XCTAssertEqual(packets.map { $0.bytes },
                           [[0x41, 0x91, 0x3C, 0x02,
                             0x80, 0x00, 0x12, 0x34],
                            [0x43, 0xB1, 0x01, 0x00,
                             0x12, 0x34, 0x56, 0x78]])
            
            XCTAssertEqual(packets.map { $0.timeStamp },
                           [timeStamp,
                            timeStamp])
            
        }
        
        check(&eventList)
        
    }
    
    func testMultiplePacketsWithSingleUMPs() throws {
        
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x41913C02, 0x80001234],  // MIDI 2.0 Note On (2 words)
                    [0x43B10100, 0x12345678]], // CC (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
            
            XCTAssertEqual(packets.map { $0.bytes },
                           [[0x41, 0x91, 0x3C, 0x02,
                             0x80, 0x00, 0x12, 0x34],
                            [0x43, 0xB1, 0x01, 0x00,
                             0x12, 0x34, 0x56, 0x78]])
            
            XCTAssertEqual(packets.map { $0.timeStamp },
                           [timeStamp,
                            timeStamp])
            
        }
        
        check(&eventList)
        
    }
    
    func testMultiplePacketsWithMultipleUMPs() throws {
        
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x41913C02, 0x80001234,   // MIDI 2.0 Note On (2 words)
                     0x44CA0000, 0x20000000],  // Program change (no bank select)
                    [0x43B10100, 0x12345678,   // CC (2 words)
                     0x45D80000, 0x12345678]], // Channel pressure
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets()
            
            XCTAssertEqual(packets.map { $0.bytes },
                           [[0x41, 0x91, 0x3C, 0x02,
                             0x80, 0x00, 0x12, 0x34],
                            [0x44, 0xCA, 0x00, 0x00,
                             0x20, 0x00, 0x00, 0x00],
                            [0x43, 0xB1, 0x01, 0x00,
                             0x12, 0x34, 0x56, 0x78],
                            [0x45, 0xD8, 0x00, 0x00,
                             0x12, 0x34, 0x56, 0x78]])
            
            XCTAssertEqual(packets.map { $0.timeStamp },
                           [timeStamp,
                            timeStamp,
                            timeStamp,
                            timeStamp])
            
        }
        
        check(&eventList)
        
    }
    
    fileprivate func makeEventList(words: [[MIDI.UMPWord]],
                                   timeStamp: MIDITimeStamp) throws -> MIDIEventList {
        
        var eventList: MIDIEventList = .init()
        let packet = MIDIEventListInit(&eventList, ._2_0)
        
        for packetWords in words {
            MIDIEventListAdd(&eventList,
                             1024,
                             packet,
                             timeStamp,
                             packetWords.count,
                             packetWords)
        }
        
        return eventList
        
    }
    
}

#endif

