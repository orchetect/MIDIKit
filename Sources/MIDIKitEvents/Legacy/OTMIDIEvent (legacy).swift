//
//  OTMIDIEvent (legacy).swift
//  MIDIKit (legacy)
//

import Foundation
import CoreMIDI
@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

/// A container for the values that define a MIDI event.
/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
public struct OTMIDIEvent {
	
	// MARK: - Properties
	
	/// Raw MIDI event data bytes
	public var rawData = [UInt8]()
	
	/// Status nibble
	public var status: OTMIDIStatus? {
		guard rawData.count > 0 else { return nil }
		
		let statusNibble = rawData[0] >> 4
		return OTMIDIStatus(rawValue: statusNibble)
	}
	
	/// Returns System Command message type if it matches a valid command message, otherwise returns nil
	public var command: OTMIDISystemCommand? {
		guard rawData.count > 0 else { return nil }
		
		return OTMIDISystemCommand(rawValue: rawData[0])
	}
	
	/// Returns MIDI Channel of `rawData`
	public var channel: UInt8? {
		guard rawData.count > 0 else { return nil }
		
		// return nil if message type does not contain channel information
		if let getStatus = status {
			if !getStatus.hasAssociatedChannel { return nil }
		}
		return rawData[0] & 0x0F
	}
	
	/// Returns data1 byte from `rawData`
	public var data1: UInt8? {
		guard rawData.count > 1 else { return nil }
		return rawData[1]
	}
	
	/// Returns data2 byte from `rawData`
	public var data2: UInt8? {
		guard rawData.count > 2 else { return nil }
		return rawData[2]
	}
	
	/// Computes 14-bit value of data1 and data2 bytes from `rawData`
	public var data14bit: UInt16? {
		guard data1 != nil, data2 != nil else { return nil }
		
		let x = UInt16(data1!)
		let y = UInt16(data2!) << 7
		return y + x
	}
	
	/// Returns `rawData` as Data
	var rawDataBytes: Data {
		Data(rawData)
	}
	
	static private let statusBitMask:	UInt8 = 0b10000000
	static private let dataMask:		UInt8 = 0b01111111
	static private let messageMask:		UInt8 = 0b01110000
	static private let channelMask:		UInt8 = 0b00001111
	
	// MARK: - Initialization
	
	/// Initialize the MIDI Event from a `MIDIPacket`
	/// - parameter packet: MIDIPacket
	init?(packet: MIDIPacket) {
		self.init(data: packet.data)
	}
	
	/// Initialize the MIDI Event from `MIDIPacketRawData` (aka `MIDIPacket.data`)
	/// - parameter data: MIDIPacket.data
	init?(data: MIDIPacketRawData) {
		// not a system command; system commands require a status nibble
		if data.0 <= 0xF {
			// fail if status is not valid
			guard let status = OTMIDIStatus(rawValue: data.0 >> 4) else {
				Log.error("OTMIDI: OTMIDIEvent init error: Could not look up OTMIDIStatus rawValue from packet byte 0: \(data.0.hex.stringValue). Aborting init.")
				return nil
				// ***** provide default packet contents here?
			}
			let channel = UInt8(data.0 & 0xF)
			fillWithStatus(status: status, channel: channel, byte1: data.1, byte2: data.2)
			
			
		} else {
			// probably a system command
			
			// first check if it's sysex
			if isSysEx(data: data) {
				rawData = [] // empty internalData because we're going to start filling it
				//voodoo
				let mirrorData = Mirror(reflecting: data) // packet.data ???
				for (_, value) in mirrorData.children {
					// (value is type Any)
					guard let val = value as? UInt8 else {
						Log.error("OTMIDI: OTMIDIEvent init error: Could not cast value packet data '\(value)' to UInt8. Aborting init.")
						return nil
					}
					rawData.append(val)
					if val == OTMIDISystemCommand.sysExEnd.rawValue {
						break // we're done - end of sysex block
					}
				}//end voodoo
				
			// otherwise, probably another system command
			} else {
				guard let cmd = OTMIDISystemCommand(rawValue: data.0) else {
					Log.error("OTMIDI: OTMIDIEvent init error: Could not look up OTMIDISystemCommand rawValue from packet byte 0: \(data.0.hex.stringValue). Aborting init.")
					return nil
				}
				
				fillWithCommand(
					command: cmd,
					byte1: data.1,
					byte2: data.2)
			}
		}
	}
	
	/// Initialize the MIDI Event from `MIDIPacketData`
	/// - parameter data: MIDIPacketData
	init?(data: MIDIPacketData) {
		self.init(data: data.rawData)
	}
	
	/// Initialize the MIDI Event with internalData populated by the raw contents of a MIDIPacket
	/// - parameter rawPacket: MIDIPacket
	init(rawData: [UInt8]) {
		self.rawData = rawData
	}
	
	/// Initialize the MIDI Event from a status message
	/// - parameter status:  MIDI Status
	/// - parameter channel: Channel on which the event occurs
	/// - parameter byte1:   First data byte
	/// - parameter byte2:   Second data byte
	init(status: OTMIDIStatus, channel: UInt8, byte1: UInt8? = nil, byte2: UInt8? = nil) {
		fillWithStatus(status: status, channel: channel, byte1: byte1, byte2: byte2)
	}
	
	/// Internal use.
	private mutating func fillWithStatus(status: OTMIDIStatus, channel: UInt8, byte1: UInt8? = nil, byte2: UInt8? = nil) {
		rawData.removeAll()
		rawData.append(UInt8(status.rawValue << 4) | UInt8((channel) & 0xf))
		if let getByte1 = byte1 { rawData.append(getByte1 & 0x7F) }
		if let getByte2 = byte2 { rawData.append(getByte2 & 0x7F) }
	}
	
	/// Initialize the MIDI Event from a system command message
	/// - parameter command: MIDI System Command
	/// - parameter byte1:   First data byte
	/// - parameter byte2:   Second data byte
	init(command: OTMIDISystemCommand, byte1: UInt8? = nil, byte2: UInt8? = nil) {
		fillWithCommand(command: command, byte1: byte1, byte2: byte2)
	}
	
	/// Internal use.
	private mutating func fillWithCommand(command: OTMIDISystemCommand, byte1: UInt8? = nil, byte2: UInt8? = nil) {
		rawData.removeAll()
		rawData.append(command.rawValue)
		if let getByte1 = byte1 { rawData.append(getByte1 & 0x7F) }
		if let getByte2 = byte2 { rawData.append(getByte2 & 0x7F) }
	}
	
	// MARK: - ancillary functions
	
	/// Determine whether a given byte is the status byte for a MIDI event
	/// - parameter byte: Byte to test
	static func isStatusByte(byte: UInt8) -> Bool {
		(byte & OTMIDIEvent.statusBitMask) == OTMIDIEvent.statusBitMask
	}
	
	/// Determine whether a given byte is a data byte for a MIDI Event
	/// - parameter byte: Byte to test
	static func isDataByte(byte: UInt8) -> Bool {
		(byte & OTMIDIEvent.statusBitMask) == 0
	}
	
	/// Convert a byte into a MIDI Status
	/// - parameter byte: Byte to convert
	static func statusFrom(byte: UInt8) -> OTMIDIStatus? {
		let status = byte >> 4
		guard let lookup = OTMIDIStatus(rawValue: status) else {
			Log.error("OTMIDI: OTMIDIEvent statusFromValue(...) error: Could not look up OTMIDIStatus rawValue from byte: \(byte.hex.stringValue).")
			return nil
		}
		return lookup
	}
	
	/// Returns true if first byte is a SysEx start byte
	private func isSysEx(packet: MIDIPacket) -> Bool {
		isSysEx(data: packet.data)
	}
	
	/// Returns true if first byte is a SysEx start byte
	private func isSysEx(data: MIDIPacketRawData) -> Bool {
		data.0 == OTMIDISystemCommand.sysExStart.rawValue
	}
	
}

// MARK: - Convenience common MIDI event creators

extension OTMIDIEvent {
	/// Create note on event
	/// - parameter note:     MIDI Note number
	/// - parameter velocity: MIDI Note velocity (0-127)
	/// - parameter channel:  Channel on which the note appears
	static public func eventWithNoteOn(note: UInt8,
									   velocity: UInt8,
									   channel: UInt8) -> OTMIDIEvent {
		OTMIDIEvent(status: .noteOn,
					channel: channel,
					byte1: note,
					byte2: velocity)
	}
	
	/// Create note off event
	/// - parameter note:     MIDI Note number
	/// - parameter velocity: MIDI Note velocity (0-127)
	/// - parameter channel:  Channel on which the note appears
	static public func eventWithNoteOff(note: UInt8,
										velocity: UInt8,
										channel: UInt8) -> OTMIDIEvent {
		OTMIDIEvent(status: .noteOff,
					channel: channel,
					byte1: note,
					byte2: velocity)
	}
	
	/// Create controller event
	/// - parameter controller: Controller number
	/// - parameter value:      Value of the controller
	/// - parameter channel:    Channel on which the controller value has changed
	static public func eventWithController(controller: UInt8,
										   value: UInt8,
										   channel: UInt8) -> OTMIDIEvent {
		OTMIDIEvent(status: .controllerChange,
					channel: channel,
					byte1: controller, byte2: value)
	}
	
	/// Create program change event
	/// - parameter program: Program change byte
	/// - parameter channel: Channel on which the program change appears
	static public func eventWithProgramChange(program: UInt8,
											  channel: UInt8) -> OTMIDIEvent {
		OTMIDIEvent(status: .programChange,
					channel: channel, byte1:
						program, byte2: 0)
	}
	
	static public func eventWithPressure(pressure: UInt8,
										 channel: UInt8) -> OTMIDIEvent {
		OTMIDIEvent(status: .channelAftertouch,
					channel: channel)
	}
	
}
