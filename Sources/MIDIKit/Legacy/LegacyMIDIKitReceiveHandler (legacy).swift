//
//  LegacyMIDIKitReceiveHandler (legacy).swift
//  MIDIKit (legacy)
//
//  Created by Steffan Andrews on 2021-03-19.
//

import CoreMIDI

// MARK: - LegacyMIDIKitReceiveHandler

/// MIDI packet data receive handler that stores an `MIDIListener` class.
public struct LegacyMIDIKitReceiveHandler: MIDIIOReceiveHandler {
	
	public var midiListener: MIDIListener
	
	@inline(__always) public func midiReadBlock(
		_ packetListPtr: UnsafePointer<MIDIPacketList>,
		_ srcConnRefCon: UnsafeMutableRawPointer?
	) {
		
		packetListPtr.pointee
			.forEach {
				midiListener.receivedRawData($0.packetData)
			}
		
	}
	
	/// Retains strong reference to `MIDIListener` instance
	public init(_ midiListener: MIDIListener) {
		
		self.midiListener = midiListener
		
	}
	
}
