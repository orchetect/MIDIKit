//
//  LegacyMIDIKitReceiveHandler (legacy).swift
//  MIDIKit (legacy)
//
//  Created by Steffan Andrews on 2021-03-19.
//

import CoreMIDI

// MARK: - LegacyMIDIKitReceiveHandler

/// MIDI packet data receive handler that stores an `MIDIListener` class.
/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
public struct LegacyMIDIKitReceiveHandler: MIDIIOReceiveHandler {
	
	public var midiListener: MIDIListener
	
	@inline(__always)
	public func midiReadBlock(
		_ packetListPtr: UnsafePointer<MIDIPacketList>,
		_ srcConnRefCon: UnsafeMutableRawPointer?
	) {
		
		packetListPtr.forEach {
			midiListener.receivedRawData($0)
		}
		
	}
	
	/// Retains strong reference to `MIDIListener` instance
	public init(_ midiListener: MIDIListener) {
		
		self.midiListener = midiListener
		
	}
	
}
