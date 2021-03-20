//
//  MIDIListener (legacy).swift
//  MIDIKit (legacy)
//
//  Created by Steffan Andrews on 2021-03-04.
//  Copyright © 2021 orchetect. All rights reserved.
//

/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
public protocol MIDIListener {
	
	/// `MIDIListener` protocol function
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func receivedRawData(_ data: MIDIPacketData)
	
	/// `MIDIListener` protocol function
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func receivedMIDINoteOn(note: Int, velocity: Int, channel: Int)
	
	/// `MIDIListener` protocol function
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func receivedMIDINoteOff(note: Int, velocity: Int, channel: Int)
	
	/// `MIDIListener` protocol function
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func receivedMIDIController(controller: Int, value: Int, channel: Int)
	
	/// `MIDIListener` protocol function
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	func receivedMIDISystemCommand(data: [UInt8])
	
}

// Default implementation

extension MIDIListener {
	
	func receivedRawData(_ data: MIDIPacketData) {
		
		for event in data.makeEventIterator() {
			switch event.status {
			case .noteOn, .noteOff, .controllerChange:
				guard let note = event.data1?.int,
					  let val = event.data2?.int,
					  let chan = event.channel?.int
				else { continue }
				
				switch event.status {
				case .noteOn:
					receivedMIDINoteOn(note: note, velocity: val, channel: chan)
					
				case .noteOff:
					receivedMIDINoteOff(note: note, velocity: val, channel: chan)
					
				case .controllerChange:
					receivedMIDIController(controller: note, value: val, channel: chan)
					
				default: break
				}
				
			case .systemCommand:
				receivedMIDISystemCommand(data: event.rawData)
			
			default: break
			}
		}
		
	}
	
	func receivedMIDINoteOn(note: Int, velocity: Int, channel: Int) { }
	func receivedMIDINoteOff(note: Int, velocity: Int, channel: Int) { }
	func receivedMIDIController(controller: Int, value: Int, channel: Int) { }
	func receivedMIDISystemCommand(data: [Byte]) { }
	
}
