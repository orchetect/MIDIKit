//
//  LSB.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitCommon

// MARK: - Convenience typealias

public typealias MIDICCLSB = MIDI.Event.ChannelVoiceMessage.ControllerChange.LSB

// MARK: - MIDI.Event.ChannelVoiceMessage.ControllerChange.LSB

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	/// MIDI Controller Change Event (CC)
	public enum LSB: Equatable, Hashable {
		
		/// LSB for Control 0 (Bank Select)
		/// (Int: 32, Hex: 0x20)
		case bankSelect(value: MIDI.UInt7)
		
		/// LSB for Control 1 (Modulation Wheel)
		/// (Int: 33, Hex: 0x21)
		case modWheel(value: MIDI.UInt7)
		
		/// LSB for Control 2 (Breath Controller)
		/// (Int: 34, Hex: 0x22)
		case breath(value: MIDI.UInt7)
		
		// CC 35 undefined
		
		/// LSB for Control 4 (Foot Controller)
		/// (Int: 36, Hex: 0x24)
		case footController(value: MIDI.UInt7)
		
		/// LSB for Control 5 (Portamento Time)
		/// (Int: 37, Hex: 0x25)
		case portamentoTime(value: MIDI.UInt7)
		
		/// LSB for Control 6 (Data Entry)
		/// (Int: 38, Hex: 0x26)
		case dataEntry(value: MIDI.UInt7)
		
		/// LSB for Control 7 (Channel Volume)
		/// (Int: 39, Hex: 0x27)
		case channelVolume(value: MIDI.UInt7)
		
		/// LSB for Control 8 (Balance)
		/// (Int: 40, Hex: 0x28)
		case balance(value: MIDI.UInt7)
		
		// CC 41 undefined
		
		/// LSB for Control 10 (Pan)
		/// (Int: 42, Hex: 0x2A)
		case pan(value: MIDI.UInt7)
		
		/// LSB for Control 11 (Expression Controller)
		/// (Int: 43, Hex: 0x2B)
		case expression(value: MIDI.UInt7)
		
		/// LSB for Control 12 (Effect control 1)
		/// (Int: 44, Hex: 0x2C)
		case effectControl1(value: MIDI.UInt7)
		
		/// LSB for Control 13 (Effect control 2)
		/// (Int: 45, Hex: 0x2D)
		case effectControl2(value: MIDI.UInt7)
		
		// CC 46 ... 47 undefined
		
		/// LSB for Control 16 (General Purpose Controller 1)
		/// (Int: 48, Hex: 0x30)
		case generalPurpose1(value: MIDI.UInt7)
		
		/// LSB for Control 17 (General Purpose Controller 2)
		/// (Int: 49, Hex: 0x31)
		case generalPurpose2(value: MIDI.UInt7)
		
		/// LSB for Control 18 (General Purpose Controller 3)
		/// (Int: 50, Hex: 0x32)
		case generalPurpose3(value: MIDI.UInt7)
		
		/// LSB for Control 19 (General Purpose Controller 4)
		/// (Int: 51, Hex: 0x33)
		case generalPurpose4(value: MIDI.UInt7)
		
		// CC 52 ... 63 undefined
		
		/// Undefined
		case undefined(_ controller: MIDI.UInt7, value: MIDI.UInt7)
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange.LSB {
	
	public func asEvent(channel: MIDI.UInt4) -> MIDI.Event {
		
		MIDI.Event.chanVoice(.cc(.lsb(self), channel: channel))
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange.LSB {
	
	/// Internal initializer to return specific enum case with the provided controller number.
	internal init(enumForController: MIDI.UInt7, value: MIDI.UInt7) {
		
		switch enumForController {
		case 32:
			self = .bankSelect(value: value)
		case 33:
			self = .modWheel(value: value)
		case 34:
			self = .breath(value: value)
			
		// case 35: undefined
			
		case 36:
			self = .footController(value: value)
		case 37:
			self = .portamentoTime(value: value)
		case 38:
			self = .dataEntry(value: value)
		case 39:
			self = .channelVolume(value: value)
		case 40:
			self = .balance(value: value)
			
		// case 41: undefined
			
		case 42:
			self = .pan(value: value)
		case 43:
			self = .expression(value: value)
		case 44:
			self = .effectControl1(value: value)
		case 45:
			self = .effectControl2(value: value)
			
		// case 46...47: undefined
			
		case 48:
			self = .generalPurpose1(value: value)
		case 49:
			self = .generalPurpose2(value: value)
		case 50:
			self = .generalPurpose3(value: value)
		case 51:
			self = .generalPurpose4(value: value)
		
		// case 52...63: undefined
		
		case 35, 41, 46...47, 52...63:
			self = .undefined(enumForController, value: value)
			
		default:
			fatalError("Unexpected CC number encountered: \(enumForController.asInt)")
		
		}
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange.LSB {
	
	public var controller: MIDI.UInt7 {
		
		switch self {
		case .bankSelect:
			return 32
		case .modWheel:
			return 33
		case .breath:
			return 34
		case .footController:
			return 36
		case .portamentoTime:
			return 37
		case .dataEntry:
			return 38
		case .channelVolume:
			return 39
		case .balance:
			return 40
		case .pan:
			return 42
		case .expression:
			return 43
		case .effectControl1:
			return 44
		case .effectControl2:
			return 45
		case .generalPurpose1:
			return 48
		case .generalPurpose2:
			return 49
		case .generalPurpose3:
			return 50
		case .generalPurpose4:
			return 51
		case .undefined(let controller, _):
			return controller
		}
		
	}
	
}
