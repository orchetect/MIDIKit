//
//  MIDIKitSyncTests Constants.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-21.
//

#if !os(watchOS)

import Foundation
import MIDIKitCommon
import MIDIKitTestsCommon

extension MIDIKitSyncTests {
	
	/// Tests Constants: Raw MIDI messages
	enum kRawMIDI {
		
	}
	
}

extension MIDIKitSyncTests.kRawMIDI {
	
	enum MTC_FullFrame {
		
		// Full Timecode message
		// ---------------------
		// F0 7F 7F 01 01 hh mm ss ff F7
		
		// hour byte includes base framerate info
		/*	0rrhhhhh: Rate (0–3) and hour (0–23).
		rr == 00: 24 frames/s
		rr == 01: 25 frames/s
		rr == 10: 29.97d frames/s (SMPTE drop-frame timecode)
		rr == 11: 30 frames/s
		*/
		
		static var _00_00_00_00_at_24fps: [Byte] {
			var msg: [Byte]
			
			let hh: Byte = 0b00000000 // 24fps, 1 hours
			let mm: Byte = 0
			let ss: Byte = 0
			let ff: Byte = 0
			
			msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
				   hh, mm, ss, ff,               // timecode info
				   0xF7]                         // sysex end
			
			return msg
		}
		
		static var _01_02_03_04_at_24fps: [Byte] {
			var msg: [Byte]
			
			let hh: Byte = 0b00000001 // 24fps, 1 hours
			let mm: Byte = 2
			let ss: Byte = 3
			let ff: Byte = 4
			
			msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
				   hh, mm, ss, ff,               // timecode info
				   0xF7]                         // sysex end
			
			return msg
		}
		
		static var _02_11_17_20_at_25fps: [Byte] {
			var msg: [Byte]
			
			let hh: Byte = 0b00100010 // 25fps, 2 hours
			let mm: Byte = 11
			let ss: Byte = 17
			let ff: Byte = 20
			
			msg = [0xF0, 0x7F, 0x7F, 0x01, 0x01, // preamble
				   hh, mm, ss, ff,               // timecode info
				   0xF7]                         // sysex end
			
			return msg
		}
		
	}
	
}

#endif
