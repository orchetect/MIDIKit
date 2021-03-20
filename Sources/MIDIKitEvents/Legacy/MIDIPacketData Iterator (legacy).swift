//
//  MIDIPacketData Iterator (legacy).swift
//  MIDIKit (legacy)
//
//  Created by Steffan Andrews on 2021-03-17.
//  Copyright © 2021 orchetect. All rights reserved.
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIPacketData {
	
	/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
	public func makeEventIterator() -> AnyIterator<OTMIDIEvent> {
		
		let generator = makeIterator()
		var index: UInt16 = 0
		
		return AnyIterator {
			
			if index >= self.length {
				return nil
			}
			
			func pop() -> UInt8 {
				assert(index < self.length)
				index += 1
				if let ret = generator.next() { return ret }
				return 0 // this isn't right, but can help avoid a crash
			}
			
			// get next byte
			// it should be a status message unless data stream is malformed somehow
			let status = pop()
			
			if OTMIDIEvent.isStatusByte(byte: status) && status != OTMIDISystemCommand.sysExStart.rawValue
			{
				
				var data1: UInt8 = 0
				var data2: UInt8 = 0
				guard var mstat = OTMIDIEvent.statusFrom(byte: status) else {
					Log.error("OTMIDI: MIDI Packet makeIterator() error: determined element was a status byte but failed to lookup event type.")
					return nil
				}
				
				switch mstat {
				case .noteOff, .noteOn, .polyphonicAftertouch, .controllerChange, .pitchWheel:
					data1 = pop(); data2 = pop()
				case .programChange, .channelAftertouch:
					data1 = pop()
				case .systemCommand: break
				}
				
				if mstat == .noteOn && data2 == 0 {
					// turn noteOn with velocity 0 to noteOff
					mstat = .noteOff
				}
				
				let chan = (status & 0xF)
				
				return OTMIDIEvent(status: mstat, channel: chan, byte1: data1, byte2: data2)
				
			} else if status == OTMIDISystemCommand.sysExStart.rawValue {
				
				// SysEx: CoreMIDI guarantees them to be the only event in the packet
				index = self.length.uint16
				
				return OTMIDIEvent(data: self)
				
			} else {
				
				var data1: UInt8? = nil
				var data2: UInt8? = nil
				
				// only some commands have additional bytes; deal with them specifically here
				if let cmd = OTMIDISystemCommand(rawValue: status) {
					switch cmd {
					case .songPosition:
						data1 = pop()
						data2 = pop()
					case .songSelect:
						data1 = pop()
					case .unofficialBusSelect:
						data1 = pop()
					default: break
					}
				}
				
				var eventData: [UInt8] = [status]
				if let getData1 = data1 { eventData.append(getData1) }
				if let getData2 = data2 { eventData.append(getData2) }
				
				return OTMIDIEvent(rawData: eventData)
			}
			
		}
		
	}
	
}
