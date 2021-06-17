//
//  MIDI Endpoints.swift
//  MIDIKitSyncTestHarness
//
//  Created by Steffan Andrews on 2020-12-02.
//

import Foundation

import OTCore
import MIDIKit

enum midiSources {
	
    enum MTCGen {
        static let name = "MIDIKit MTC Gen"
		static let tag = "MTCGen"
    }

    enum MTCRec {
        static let name = "MIDIKit MTC Rec"
		static let tag = "MTCRec"
    }
	
}
