//
//  Mode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitCommon
@_implementationOnly import OTCoreTesting

// MARK: - Convenience typealias

public typealias MIDICCMode = MIDI.Event.ChannelVoiceMessage.ControllerChange.Mode

// MARK: - MIDI.Event.ChannelVoiceMessage.ControllerChange.Mode

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	public enum Mode: Equatable, Hashable {
		
		/// [Channel Mode Message] All Sound Off
		/// (Int: 120, Hex: 0x78)
		case allSoundOff(value: MIDI.UInt7 = 0)
		
		/// [Channel Mode Message] Reset All Controllers
		/// (See MMA RP-015)
		/// (Int: 121, Hex: 0x79)
		case resetAllControllers(value: MIDI.UInt7 = 0)
		
		/// [Channel Mode Message] Local Control On/Off
		/// (Int: 122, Hex: 0x7A)
		case localControl(value: MIDI.UInt7)
		
		/// [Channel Mode Message] All Notes Off
		/// (Int: 123, Hex: 0x7B)
		case allNotesOff(value: MIDI.UInt7 = 0)
		
		/// [Channel Mode Message] Omni Mode Off (+ all notes off)
		/// (Int: 124, Hex: 0x7C)
		case omniModeOff(value: MIDI.UInt7 = 0)
		
		/// [Channel Mode Message] Omni Mode On (+ all notes off)
		/// (Int: 125, Hex: 0x7D)
		case omniModeOn(value: MIDI.UInt7 = 0)
		
		/// [Channel Mode Message] Mono Mode On (+ poly off, + all notes off)
		/// (Int: 126, Hex: 0x7E)
		case monoModeOn(value: MIDI.UInt7)
		
		/// [Channel Mode Message] Poly Mode On (+ mono off, + all notes off)
		/// (Int: 127, Hex: 0x7F)
		case polyModeOn(value: MIDI.UInt7 = 0)
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange.Mode {
	
	/// Internal initializer to return specific enum case with the provided controller number.
	internal init(enumForController: MIDI.UInt7, value: MIDI.UInt7) {
		
		switch enumForController {
		case 120:
			self = .allSoundOff(value: value)
		case 121:
			self = .resetAllControllers(value: value)
		case 122:
			self = .localControl(value: value)
		case 123:
			self = .allNotesOff(value: value)
		case 124:
			self = .omniModeOff(value: value)
		case 125:
			self = .omniModeOn(value: value)
		case 126:
			self = .monoModeOn(value: value)
		case 127:
			self = .polyModeOn(value: value)
		default:
			fatalError("Unexpected CC number encountered: \(enumForController.asInt)")
		}
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange.Mode {
	
	public func asEvent(channel: MIDI.UInt4) -> MIDI.Event {
		
		MIDI.Event.chanVoice(.cc(.mode(self), channel: channel))
		
	}
	
}


extension MIDI.Event.ChannelVoiceMessage.ControllerChange.Mode {
	
	public var controller: MIDI.UInt7 {
		
		switch self {
		case .allSoundOff:
			return 120
		case .resetAllControllers:
			return 121
		case .localControl:
			return 122
		case .allNotesOff:
			return 123
		case .omniModeOff:
			return 124
		case .omniModeOn:
			return 125
		case .monoModeOn:
			return 126
		case .polyModeOn:
			return 127
		}
		
	}
	
}
