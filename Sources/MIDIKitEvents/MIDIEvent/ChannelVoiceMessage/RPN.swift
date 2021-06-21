//
//  RPN.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-25.
//

import MIDIKitCommon

// MARK: - Convenience typealias

public typealias MIDICCRPN = MIDIEvent.ChannelVoiceMessage.ControllerChange.RPN

// MARK: - MIDIEvent.ChannelVoiceMessage.ControllerChange.RPN

extension MIDIEvent.ChannelVoiceMessage.ControllerChange {
	
	/// Cases describing MIDI CC RPNs (Registered Parameter Numbers)
	///
	/// As per MIDI 1.0 spec:
	///
	///	To set or change the value of a Registered Parameter:
	///
	/// 1. Send two Control Change messages using Control Numbers 101 (0x65) and 100 (0x64) to select the desired Registered Parameter Number.
	///
	/// 2. To set the selected Registered Parameter to a specific value, send a Control Change messages to the Data Entry MSB controller (Control Number 6). If the selected Registered Parameter requires the LSB to be set, send another Control Change message to the Data Entry LSB controller (Control Number 38).
	///
	/// 3. To make a relative adjustment to the selected Registered Parameter's current value, use the Data Increment or Data Decrement controllers (Control Numbers 96 and 97).
	///
	/// Currently undefined RPN parameter numbers are all RESERVED for future MMA Definition.
	///
	/// For custom Parameter Number use, see NRPN (non-Registered Parameter Numbers).
	public enum RPN: Equatable, Hashable {
		
		/// Pitch Bend Sensitivity
		case pitchBendSensitivity(semitones: MIDIUInt7, cents: MIDIUInt7)
		
		/// Channel Fine Tuning
		/// (formerly Fine Tuning - see MMA RP-022)
		///
		/// Resolution: 100/8192 cents
		/// Midpoint = A440, min/max -/+ 100 cents
		case channelFineTuning(MIDIUInt14)
		
		/// Channel Coarse Tuning
		/// (formerly Coarse Tuning - see MMA RP-022)
		///
		/// Resolution: 100 cents
		/// 0x00 = -6400 cents
		/// 0x40 = A440
		/// 0x7F = +6300 cents
		case channelCoarseTuning(MIDIUInt7)
		
		/// Tuning Program Change
		case tuningProgramChange(number: Int)
		
		/// Tuning Bank Select
		case tuningBankSelect(number: Int)
		
		/// Modulation Depth Range
		/// (see MMA General MIDI Level 2 Specification)
		///
		/// For GM2, defined in GM2 Specification.
		/// For other systems, defined by manufacturer.
		case modulationDepthRange(dataEntryMSB: MIDIUInt7?,
								  dataEntryLSB: MIDIUInt7?)
		
		/// MPE Configuration Message
		/// (see MPE Specification)
		case MPEConfigurationMessage
		
		/// Null Function Number for RPN/NRPN
		///
		/// Will disable the data entry, data increment, and data decrement controllers until a new RPN or NRPN is selected.
		case null
		
		/// Form an RPM message from a raw parameter number byte pair
		case raw(parameter: BytePair,
				 dataEntryMSB: MIDIUInt7?,
				 dataEntryLSB: MIDIUInt7?)
		
	}
	
}

extension MIDIEvent.ChannelVoiceMessage.ControllerChange.RPN {
	
	/// Parameter number byte pair
	public var parameter: BytePair {
		
		switch self {
		case .pitchBendSensitivity:
			return .init(MSB: 0x00, LSB: 0x00)
			
		case .channelFineTuning:
			return .init(MSB: 0x00, LSB: 0x01)
			
		case .channelCoarseTuning:
			return .init(MSB: 0x00, LSB: 0x02)
			
		case .tuningProgramChange:
			return .init(MSB: 0x00, LSB: 0x03)
			
		case .tuningBankSelect:
			return .init(MSB: 0x00, LSB: 0x04)
			
		case .modulationDepthRange:
			return .init(MSB: 0x00, LSB: 0x05)
			
		case .MPEConfigurationMessage:
			return .init(MSB: 0x00, LSB: 0x06)
			
		case .null:
			return .init(MSB: 0x7F, LSB: 0x7F)
			
		case .raw(let param, _, _):
			return param
			
		}
		
	}
	
}

extension MIDIEvent.ChannelVoiceMessage.ControllerChange.RPN {
	
	public func asEvent(channel: MIDIUInt4) -> MIDIEvent {
		
		MIDIEvent.chanVoice(.cc(.rpn(self), channel: channel))
		
	}
	
}
