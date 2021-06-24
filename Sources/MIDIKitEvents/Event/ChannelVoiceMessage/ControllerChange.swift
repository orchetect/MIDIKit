//
//  ControllerChange.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitCommon

// MARK: - Convenience typealias

public typealias MIDICC = MIDI.Event.ChannelVoiceMessage.ControllerChange

// MARK: - MIDI.Event.ChannelVoiceMessage.ControllerChange

extension MIDI.Event.ChannelVoiceMessage {
	
	/// MIDI Controller Change Event (CC)
	public enum ControllerChange: Equatable, Hashable {
		
		/// Bank Select
		/// (Int: 0, Hex: 0x00)
		case bankSelect(value: MIDI.UInt7)
		
		/// Modulation Wheel
		/// (Int: 1, Hex: 0x01)
		case modWheel(value: MIDI.UInt7)
		
		/// Breath Controller
		/// (Int: 2, Hex: 0x02)
		case breath(value: MIDI.UInt7)
		
		// CC 3 undefined
		
		/// Foot Controller
		/// (Int: 4, Hex: 0x04)
		case footController(value: MIDI.UInt7)
		
		/// Portamento Time
		/// (Int: 5, Hex: 0x05)
		case portamentoTime(value: MIDI.UInt7)
		
		/// Data Entry MSB
		/// (Int: 6, Hex: 0x06)
		case dataEntry(value: MIDI.UInt7)
		
		/// Channel Volume
		/// (Int: 7, Hex: 0x07)
		case channelVolume(value: MIDI.UInt7)
		
		/// Balance
		/// (Int: 8, Hex: 0x08)
		case balance(value: MIDI.UInt7)
		
		// CC 9 undefined
		
		/// Pan
		/// (Int: 10, Hex: 0x0A)
		case pan(value: MIDI.UInt7)
		
		/// Expression Controller
		/// (Int: 11, Hex: 0x0B)
		case expression(value: MIDI.UInt7)
		
		/// Effect Control 1
		/// (Int: 12, Hex: 0x0C)
		case effectControl1(value: MIDI.UInt7)
		
		/// Effect Control 2
		/// (Int: 13, Hex: 0x0D)
		case effectControl2(value: MIDI.UInt7)
		
		// CC 14 ... 15 undefined
		
		/// General Purpose Controller 1
		/// (Int: 16, Hex: 0x10)
		case generalPurpose1(value: MIDI.UInt7)
		
		/// General Purpose Controller 2
		/// (Int: 17, Hex: 0x11)
		case generalPurpose2(value: MIDI.UInt7)
		
		/// General Purpose Controller 3
		/// (Int: 18, Hex: 0x12)
		case generalPurpose3(value: MIDI.UInt7)
		
		/// General Purpose Controller 4
		/// (Int: 19, Hex: 0x13)
		case generalPurpose4(value: MIDI.UInt7)
		
		// CC 20 ... 31 undefined
		
		/// LSB cases for Controllers 0-31
		/// (Int: 32...63, Hex: 0x20...0x3F)
		case lsb(LSB)
		
		/// Sustain Pedal (Damper Pedal)
		/// (Int: 64, Hex: 0x40)
		///
		/// Values: 0...63 off, 64...127 on.
		///
		/// However, some hardware and synths respond variably to continuous values 0-127.
		case sustainPedal(value: MIDI.UInt7)
		
		/// Portamento
		/// (Int: 65, Hex: 0x41)
		///
		/// Values: 0...63 = Off, 64...127 = On.
		case portamento(value: MIDI.UInt7)
		
		/// Sostenuto Pedal
		/// (Int: 66, Hex: 0x42)
		///
		/// Values: 0...63 = Off, 64...127 = On.
		///
		/// However, some hardware and synths support variably to continuous values 0-127.
		case sostenutoPedal(value: MIDI.UInt7)
		
		/// Soft Pedal
		/// (Int: 67, Hex: 0x43)
		///
		/// Values: 0...63 = Off, 64...127 = On.
		///
		/// However, some hardware and synths support variably to continuous values 0-127.
		case softPedal(value: MIDI.UInt7)
		
		/// Legato Footswitch
		/// (Int: 68, Hex: 0x44)
		///
		/// Values: 0...63 = Normal, 64...127 = Legato.
		case legatoFootswitch(value: MIDI.UInt7)
		
		/// Hold 2
		/// (Int: 69, Hex: 0x45)
		///
		/// Values: 0...63 = Off, 64...127 = On.
		case hold2(value: MIDI.UInt7)
		
		/// Sound Controller 1 (default: Sound Variation)
		/// (Int: 70, Hex: 0x46)
		case soundCtrl1_soundVariation(value: MIDI.UInt7)
		
		/// Sound Controller 2 (default: Timbre/Harmonic Intens.)
		/// (Int: 71, Hex: 0x47)
		case soundCtrl2_timbreIntensity(value: MIDI.UInt7)
		
		/// Sound Controller 3 (default: Release Time)
		/// (Int: 72, Hex: 0x48)
		case soundCtrl3_releaseTime(value: MIDI.UInt7)
		
		/// Sound Controller 4 (default: Attack Time)
		/// (Int: 73, Hex: 0x49)
		case soundCtrl4_attackTime(value: MIDI.UInt7)
		
		/// Sound Controller 5 (default: Brightness)
		/// (Int: 74, Hex: 0x4A)
		case soundCtrl5_brightness(value: MIDI.UInt7)
		
		/// Sound Controller 6 (default: Decay Time - see MMA RP-021)
		/// (Int: 75, Hex: 0x4B)
		case soundCtrl6_decayTime(value: MIDI.UInt7)
		
		/// Sound Controller 7 (default: Vibrato Rate - see MMA RP-021)
		/// (Int: 76, Hex: 0x4C)
		case soundCtrl7_vibratoRate(value: MIDI.UInt7)
		
		/// Sound Controller 8 (default: Vibrato Depth - see MMA RP-021)
		/// (Int: 77, Hex: 0x4D)
		case soundCtrl8_vibratoDepth(value: MIDI.UInt7)
		
		/// Sound Controller 9 (default: Vibrato Delay - see MMA RP-021)
		/// (Int: 78, Hex: 0x4E)
		case soundCtrl9_vibratoDelay(value: MIDI.UInt7)
		
		/// Sound Controller 10 (default undefined - see MMA RP-021)
		/// (Int: 79, Hex: 0x4F)
		case soundCtrl10_defaultUndefined(value: MIDI.UInt7)
		
		/// General Purpose Controller 5
		/// (Int: 80, Hex: 0x50)
		case generalPurpose5(value: MIDI.UInt7)
		
		/// General Purpose Controller 6
		/// (Int: 81, Hex: 0x51)
		case generalPurpose6(value: MIDI.UInt7)
		
		/// General Purpose Controller 7
		/// (Int: 82, Hex: 0x52)
		case generalPurpose7(value: MIDI.UInt7)
		
		/// General Purpose Controller 8
		/// (Int: 83, Hex: 0x53)
		case generalPurpose8(value: MIDI.UInt7)
		
		/// Portamento Control
		/// (Int: 84, Hex: 0x54)
		case portamentoControl(value: MIDI.UInt7)
		
		// CC 85 ... 87 undefined
		
		/// High Resolution Velocity Prefix
		/// (Int: 88, Hex: 0x58)
		case highResolutionVelocityPrefix(value: MIDI.UInt7)
		
		// CC 89 ... 90 undefined
		
		/// Effects 1 Depth
		/// (default: Reverb Send Level - see MMA RP-023)
		/// (formerly External Effects Depth)
		/// (Int: 91, Hex: 0x5B)
		case effects1Depth_reverbSendLevel(value: MIDI.UInt7)
		
		/// Effects 2 Depth (formerly Tremolo Depth)
		/// (Int: 92, Hex: 0x5C)
		case effects2Depth(value: MIDI.UInt7)
		
		/// Effects 3 Depth
		/// (default: Chorus Send Level - see MMA RP-023)
		/// (formerly Chorus Depth)
		/// (Int: 93, Hex: 0x5D)
		case effects3Depth_chorusSendLevel(value: MIDI.UInt7)
		
		/// Effects 4 Depth
		/// (formerly Celeste [Detune] Depth)
		/// (Int: 94, Hex: 0x5E)
		case effects4Depth(value: MIDI.UInt7)
		
		/// Effects 5 Depth
		/// (formerly Phaser Depth)
		/// (Int: 95, Hex: 0x5F)
		case effects5Depth(value: MIDI.UInt7)
		
		/// Data Increment (Data Entry +1)
		/// (see MMA RP-018)
		/// (Int: 96, Hex: 0x60)
		///
		/// Typically this message does not contain a value byte,
		/// so it is recommended to pass `nil`.
		case dataIncrement(value: MIDI.UInt7? = nil)
		
		/// Data Decrement (Data Entry -1)
		/// (see MMA RP-018)
		/// (Int: 97, Hex: 0x61)
		///
		/// Typically this message does not contain a value byte,
		/// so it is recommended to pass `nil`.
		case dataDecrement(value: MIDI.UInt7? = nil)
		
		// CC 98 NRPN LSB
		
		// CC 99 NRPN MSB
		
		// CC 100 RPN LSB
		
		// CC 101 RPN MSB
		
		// CC 102 ... 119 undefined
		
		/// Channel Mode Message
		case mode(Mode)
		
		/// Meta-type for MIDI RPN messages
		case rpn(RPN)
		
		/// Undefined
		case undefined(_ controller: MIDI.UInt7, value: MIDI.UInt7)
		
		/// Raw CC number and value
		case raw(_ controller: MIDI.UInt7, value: MIDI.UInt7)
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	public func asEvent(channel: MIDI.UInt4) -> MIDI.Event {
		
		MIDI.Event.chanVoice(.cc(self, channel: channel))
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	/// Internal initializer to return specific enum case with the provided controller number.
	internal init(enumForController: MIDI.UInt7, value: MIDI.UInt7) {
		
		#warning("> finish this")
		
		switch enumForController {
		case 0:
			self = .bankSelect(value: value)
		case 1:
			self = .modWheel(value: value)
		case 2:
			self = .breath(value: value)
			
		// case 3: undefined
			
		case 4:
			self = .footController(value: value)
		case 5:
			self = .portamentoTime(value: value)
		case 6:
			self = .dataEntry(value: value)
		case 7:
			self = .channelVolume(value: value)
		case 8:
			self = .balance(value: value)
			
		// case 9: undefined
		
		case 10:
			self = .pan(value: value)
		case 11:
			self = .expression(value: value)
		case 12:
			self = .effectControl1(value: value)
		case 13:
			self = .effectControl2(value: value)
		case 16:
			self = .generalPurpose1(value: value)
		case 17:
			self = .generalPurpose2(value: value)
		case 18:
			self = .generalPurpose3(value: value)
		case 19:
			self = .generalPurpose4(value: value)
			
		// case 20...31: undefined
			
		case 32...63:
			self = .lsb(LSB(enumForController: enumForController, value: value))
		case 64:
			self = .sustainPedal(value: value)
		case 65:
			self = .portamento(value: value)
		case 66:
			self = .sostenutoPedal(value: value)
		case 67:
			self = .softPedal(value: value)
		case 68:
			self = .legatoFootswitch(value: value)
		case 69:
			self = .hold2(value: value)
		case 70:
			self = .soundCtrl1_soundVariation(value: value)
		case 71:
			self = .soundCtrl2_timbreIntensity(value: value)
		case 72:
			self = .soundCtrl3_releaseTime(value: value)
		case 73:
			self = .soundCtrl4_attackTime(value: value)
		case 74:
			self = .soundCtrl5_brightness(value: value)
		case 75:
			self = .soundCtrl6_decayTime(value: value)
		case 76:
			self = .soundCtrl7_vibratoRate(value: value)
		case 77:
			self = .soundCtrl8_vibratoDepth(value: value)
		case 78:
			self = .soundCtrl9_vibratoDelay(value: value)
		case 79:
			self = .soundCtrl10_defaultUndefined(value: value)
		case 80:
			self = .generalPurpose5(value: value)
		case 81:
			self = .generalPurpose6(value: value)
		case 82:
			self = .generalPurpose7(value: value)
		case 83:
			self = .generalPurpose8(value: value)
		case 84:
			self = .portamentoControl(value: value)
			
		// case 85...87: undefined
		
		case 88:
			self = .highResolutionVelocityPrefix(value: value)
			
		// case 89...90: undefined
			
		case 91:
			self = .effects1Depth_reverbSendLevel(value: value)
		case 92:
			self = .effects2Depth(value: value)
		case 93:
			self = .effects3Depth_chorusSendLevel(value: value)
		case 94:
			self = .effects4Depth(value: value)
		case 95:
			self = .effects5Depth(value: value)
		case 96:
			self = .dataIncrement(value: value)
		case 97:
			self = .dataDecrement(value: value)
		case 98...99: // technically both 98 (LSB) and 99 (MSB)
			fatalError("RPN message cannot be created from this initializer.")
		case 100...101: // technically both 100 (LSB) and 101 (MSB)
			fatalError("NRPN message cannot be created from this initializer.")
			
		// case 102...119: undefined
		
		case 120...127:
			self = .mode(Mode(enumForController: enumForController, value: value))
			
		case 3, 9, 20...31, 85...87, 89...90, 102...119:
			self = .undefined(enumForController, value: value)
			
		default:
			fatalError("Unexpected CC number encountered: \(enumForController.asInt)")
			
		}
		
	}
	
}

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	public var controller: MIDI.UInt7 {
		
		switch self {
		case .bankSelect:
			return 0
		case .modWheel:
			return 1
		case .breath:
			return 2
		case .footController:
			return 4
		case .portamentoTime:
			return 5
		case .dataEntry:
			return 6
		case .channelVolume:
			return 7
		case .balance:
			return 8
		case .pan:
			return 10
		case .expression:
			return 11
		case .effectControl1:
			return 12
		case .effectControl2:
			return 13
		case .generalPurpose1:
			return 16
		case .generalPurpose2:
			return 17
		case .generalPurpose3:
			return 18
		case .generalPurpose4:
			return 19
		case .lsb(let msg):
			return msg.controller
		case .sustainPedal:
			return 64
		case .portamento:
			return 65
		case .sostenutoPedal:
			return 66
		case .softPedal:
			return 67
		case .legatoFootswitch:
			return 68
		case .hold2:
			return 69
		case .soundCtrl1_soundVariation:
			return 70
		case .soundCtrl2_timbreIntensity:
			return 71
		case .soundCtrl3_releaseTime:
			return 72
		case .soundCtrl4_attackTime:
			return 73
		case .soundCtrl5_brightness:
			return 74
		case .soundCtrl6_decayTime:
			return 75
		case .soundCtrl7_vibratoRate:
			return 76
		case .soundCtrl8_vibratoDepth:
			return 77
		case .soundCtrl9_vibratoDelay:
			return 78
		case .soundCtrl10_defaultUndefined:
			return 79
		case .generalPurpose5:
			return 80
		case .generalPurpose6:
			return 81
		case .generalPurpose7:
			return 82
		case .generalPurpose8:
			return 83
		case .portamentoControl:
			return 84
		case .highResolutionVelocityPrefix:
			return 88
		case .effects1Depth_reverbSendLevel:
			return 91
		case .effects2Depth:
			return 92
		case .effects3Depth_chorusSendLevel:
			return 93
		case .effects4Depth:
			return 94
		case .effects5Depth:
			return 95
		case .dataIncrement:
			return 96
		case .dataDecrement:
			return 97
		case .rpn:
			return 99 // technically both 98 (LSB) and 99 (MSB)
		//case .nrpn:
		//	return 101
		case .mode(let msg):
			return msg.controller
		case .undefined(let controller, _):
			return controller
		case .raw(let controller, _):
			return controller
		}
		
	}
	
}


// MARK: - Kind

extension MIDI.Event.ChannelVoiceMessage.ControllerChange {
	
	#warning("> this should be expanded into cases for each controller type, not just a controller number")
	
	public enum Kind: MIDIEventKindProtocol, Equatable, Hashable {
		
		case controller(_ number: MIDI.UInt7)
		
	}
	
}
