//
//  MTC Generator Tests.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-08.
//

#if !os(watchOS)

import XCTest
@testable import MIDIKitSync
import OTCoreTestingXCTest

import TimecodeKit

final class MTC_Generator_Generator_Tests: XCTestCase {
	
	func testMTC_Generator_Default() {
		
		let mtcGen1 = MTC.Generator()
		mtcGen1.setMIDIEventSendHandler { [weak self] (midiMessage) in
			// send midi message here
			_ = midiMessage
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MTC.Generator { [weak self] (midiMessage) in
			// send midi message here
			_ = midiMessage
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MTC.Generator(midiEventSendHandler: { (midiMessage) in
			//yourMIDIPort.send(midiBytes)
			_ = midiMessage
		})
		
		let _ = MTC.Generator { (midiMessage) in
			//yourMIDIPort.send(midiBytes)
			_ = midiMessage
		}
		
	}

}

#endif
