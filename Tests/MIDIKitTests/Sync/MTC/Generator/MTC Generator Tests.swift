//
//  MTC Generator Tests.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(watchOS)

import XCTest
@testable import MIDIKit
import OTCoreTestingXCTest
import TimecodeKit

final class MTC_Generator_Generator_Tests: XCTestCase {
	
	func testMTC_Generator_Default() {
		
		let mtcGen1 = MIDI.MTC.Generator()
		mtcGen1.setMIDIEventSendHandler { [weak self] (midiMessage) in
			// send midi message here
			_ = midiMessage
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MIDI.MTC.Generator { [weak self] (midiMessage) in
			// send midi message here
			_ = midiMessage
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MIDI.MTC.Generator(midiEventSendHandler: { (midiMessage) in
			//yourMIDIPort.send(midiBytes)
			_ = midiMessage
		})
		
		let _ = MIDI.MTC.Generator { (midiMessage) in
			//yourMIDIPort.send(midiBytes)
			_ = midiMessage
		}
		
	}

}

#endif
