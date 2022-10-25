//
//  MIDISyncKitTests Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if shouldTestCurrentPlatform

@testable import MIDIKitSync
import Foundation

/// Sync Tests Constants: Raw MIDI messages
enum kRawMIDI { }

extension kRawMIDI {
    // swiftformat:options --wrapcollections preserve
    
    enum MTC_FullFrame {
        // Full Timecode message
        // ---------------------
        // F0 7F 7F 01 01 hh mm ss ff F7
        
        // hour byte includes base framerate info
        //  0rrhhhhh: Rate (0–3) and hour (0–23).
        // rr == 00: 24 frames/s
        // rr == 01: 25 frames/s
        // rr == 10: 29.97d frames/s (SMPTE drop-frame timecode)
        // rr == 11: 30 frames/s
        
        static var _00_00_00_00_at_24fps: [UInt8] {
            var msg: [UInt8]
            
            let hh: UInt8 = 0b00000000 // 24fps, 1 hours
            let mm: UInt8 = 0
            let ss: UInt8 = 0
            let ff: UInt8 = 0
            
            msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
                   hh, mm, ss, ff,               // timecode info
                   0xF7]                         // sysex end
            
            return msg
        }
        
        static var _01_02_03_04_at_24fps: [UInt8] {
            var msg: [UInt8]
            
            let hh: UInt8 = 0b00000001 // 24fps, 1 hours
            let mm: UInt8 = 2
            let ss: UInt8 = 3
            let ff: UInt8 = 4
            
            msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
                   hh, mm, ss, ff,               // timecode info
                   0xF7]                         // sysex end
            
            return msg
        }
        
        static var _02_11_17_20_at_25fps: [UInt8] {
            var msg: [UInt8]
            
            let hh: UInt8 = 0b00100010 // 25fps, 2 hours
            let mm: UInt8 = 11
            let ss: UInt8 = 17
            let ff: UInt8 = 20
            
            msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
                   hh, mm, ss, ff,               // timecode info
                   0xF7]                         // sysex end
            
            return msg
        }
    }
}

/// Sync Tests Constants: Raw MIDI messages
enum kMIDIEvent {
    enum MTC_FullFrame {
        static var _00_00_00_00_at_24fps: MIDIEvent {
            let hh: UInt8 = 0b00000000 // 24fps, 1 hours
            let mm: UInt8 = 0
            let ss: UInt8 = 0
            let ff: UInt8 = 0
            
            let msg = MIDIEvent.universalSysEx7(
                universalType: .realTime,
                deviceID: 0x7F,
                subID1: 0x01,
                subID2: 0x01,
                data: [hh, mm, ss, ff]
            )
            
            return msg
        }
        
        static var _01_02_03_04_at_24fps: MIDIEvent {
            let hh: UInt8 = 0b00000001 // 24fps, 1 hours
            let mm: UInt8 = 2
            let ss: UInt8 = 3
            let ff: UInt8 = 4
            
            let msg = MIDIEvent.universalSysEx7(
                universalType: .realTime,
                deviceID: 0x7F,
                subID1: 0x01,
                subID2: 0x01,
                data: [hh, mm, ss, ff]
            )
            
            return msg
        }
        
        static var _02_11_17_20_at_25fps: MIDIEvent {
            let hh: UInt8 = 0b00100010 // 25fps, 2 hours
            let mm: UInt8 = 11
            let ss: UInt8 = 17
            let ff: UInt8 = 20
            
            let msg = MIDIEvent.universalSysEx7(
                universalType: .realTime,
                deviceID: 0x7F,
                subID1: 0x01,
                subID2: 0x01,
                data: [hh, mm, ss, ff]
            )
            
            return msg
        }
    }
}

#endif
