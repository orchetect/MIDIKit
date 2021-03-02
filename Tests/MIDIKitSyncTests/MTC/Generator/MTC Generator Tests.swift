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

extension MIDIKitSyncTests {
	
	func testMTC_Generator_Default() {
		
		let mtcGen1 = MTC.Generator()
		mtcGen1.setMIDIEventSendHandler { [weak self] (midiBytes) in
			// send midi message here
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MTC.Generator { [weak self] (midiBytes) in
			// send midi message here
			self?.XCTWait(sec: 0.0)
		}
		
		let _ = MTC.Generator(midiEventSendHandler: { (midiBytes) in
			//yourMIDIPort.send(midiBytes)
		})
		
		let _ = MTC.Generator { (midiMessageBytes) in
			//yourMIDIPort.send(midiBytes)
		}
		
	}

}

#endif
