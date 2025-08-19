//
//  MIDIEventList Packets Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI
@testable import MIDIKitIO
import Testing

@Suite struct MIDIEventListPackets_Tests {
    // swiftformat:options --wrapcollections preserve
    // swiftformat:disable spaceInsideParens spaceInsideBrackets
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
    @Test
    func singlePacketWithOneUMP() throws {
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234]], // MIDI 2.0 Note On (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets(refCon: nil, refConKnown: false)
            
            #expect(
                packets.map { $0.bytes } ==
                    [[0x41, 0x91, 0x3C, 0x02,
                      0x80, 0x00, 0x12, 0x34]]
            )
            
            #expect(
                packets.map { $0.timeStamp } ==
                    [timeStamp]
            )
        }
        
        check(&eventList)
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
    @Test
    func singlePacketWithMultipleUMPs() throws {
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234,   // MIDI 2.0 Note On (2 words)
                     0x43B1_0100, 0x1234_5678]], // CC (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets(refCon: nil, refConKnown: false)
            
            #expect(
                packets.map { $0.bytes } ==
                    [[0x41, 0x91, 0x3C, 0x02,
                      0x80, 0x00, 0x12, 0x34],
                     [0x43, 0xB1, 0x01, 0x00,
                      0x12, 0x34, 0x56, 0x78]]
            )
            
            #expect(
                packets.map { $0.timeStamp } ==
                    [timeStamp,
                     timeStamp]
            )
        }
        
        check(&eventList)
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
    @Test
    func multiplePacketsWithSingleUMPs() throws {
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234],  // MIDI 2.0 Note On (2 words)
                    [0x43B1_0100, 0x1234_5678]], // CC (2 words)
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets(refCon: nil, refConKnown: false)
            
            #expect(
                packets.map { $0.bytes } ==
                    [[0x41, 0x91, 0x3C, 0x02,
                      0x80, 0x00, 0x12, 0x34],
                     [0x43, 0xB1, 0x01, 0x00,
                      0x12, 0x34, 0x56, 0x78]]
            )
            
            #expect(
                packets.map { $0.timeStamp } ==
                    [timeStamp,
                     timeStamp]
            )
        }
        
        check(&eventList)
    }
    
    @available(macOS 11, iOS 14, macCatalyst 14, tvOS 15.0, watchOS 8.0, *)
    @Test
    func multiplePacketsWithMultipleUMPs() throws {
        let timeStamp: MIDITimeStamp = 0 // mach_absolute_time()
        
        var eventList = try makeEventList(
            words: [[0x4191_3C02, 0x8000_1234,   // MIDI 2.0 Note On (2 words)
                     0x44CA_0000, 0x2000_0000],  // Program change (no bank select)
                    [0x43B1_0100, 0x1234_5678,   // CC (2 words)
                     0x45D8_0000, 0x1234_5678]], // Channel pressure
            timeStamp: timeStamp
        )
        
        func check(_ ptr: UnsafePointer<MIDIEventList>) {
            let packets = ptr.packets(refCon: nil, refConKnown: false)
            
            #expect(
                packets.map { $0.bytes } ==
                    [[0x41, 0x91, 0x3C, 0x02,
                      0x80, 0x00, 0x12, 0x34],
                     [0x44, 0xCA, 0x00, 0x00,
                      0x20, 0x00, 0x00, 0x00],
                     [0x43, 0xB1, 0x01, 0x00,
                      0x12, 0x34, 0x56, 0x78],
                     [0x45, 0xD8, 0x00, 0x00,
                      0x12, 0x34, 0x56, 0x78]]
            )
            
            #expect(
                packets.map { $0.timeStamp } ==
                    [timeStamp,
                     timeStamp,
                     timeStamp,
                     timeStamp]
            )
        }
        
        check(&eventList)
    }
    
    // MARK: - Helpers
    
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
