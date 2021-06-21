//
//  Mode.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-25.
//

import MIDIKitCommon
@_implementationOnly import OTCoreTesting

// MARK: - Convenience typealias

public typealias MIDICCMode = MIDIEvent.ChannelVoiceMessage.ControllerChange.Mode

// MARK: - MIDIEvent.ChannelVoiceMessage.ControllerChange.Mode

extension MIDIEvent.ChannelVoiceMessage.ControllerChange {
	
	public enum Mode: Equatable, Hashable {
		
		/// [Channel Mode Message] All Sound Off
		/// (Int: 120, Hex: 0x78)
		case allSoundOff(value: MIDIUInt7 = 0)
		
		/// [Channel Mode Message] Reset All Controllers
		/// (See MMA RP-015)
		/// (Int: 121, Hex: 0x79)
		case resetAllControllers(value: MIDIUInt7 = 0)
		
		/// [Channel Mode Message] Local Control On/Off
		/// (Int: 122, Hex: 0x7A)
		case localControl(value: MIDIUInt7)
		
		/// [Channel Mode Message] All Notes Off
		/// (Int: 123, Hex: 0x7B)
		case allNotesOff(value: MIDIUInt7 = 0)
		
		/// [Channel Mode Message] Omni Mode Off (+ all notes off)
		/// (Int: 124, Hex: 0x7C)
		case omniModeOff(value: MIDIUInt7 = 0)
		
		/// [Channel Mode Message] Omni Mode On (+ all notes off)
		/// (Int: 125, Hex: 0x7D)
		case omniModeOn(value: MIDIUInt7 = 0)
		
		/// [Channel Mode Message] Mono Mode On (+ poly off, + all notes off)
		/// (Int: 126, Hex: 0x7E)
		case monoModeOn(value: MIDIUInt7)
		
		/// [Channel Mode Message] Poly Mode On (+ mono off, + all notes off)
		/// (Int: 127, Hex: 0x7F)
		case polyModeOn(value: MIDIUInt7 = 0)
		
	}
	
}

extension MIDIEvent.ChannelVoiceMessage.ControllerChange.Mode {
	
	/// Internal initializer to return specific enum case with the provided controller number.
	internal init(enumForController: MIDIUInt7, value: MIDIUInt7) {
		
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

extension MIDIEvent.ChannelVoiceMessage.ControllerChange.Mode {
	
	public func asEvent(channel: MIDIUInt4) -> MIDIEvent {
		
		MIDIEvent.chanVoice(.cc(.mode(self), channel: channel))
		
	}
	
}


extension MIDIEvent.ChannelVoiceMessage.ControllerChange.Mode {
	
	public var controller: MIDIUInt7 {
		
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
