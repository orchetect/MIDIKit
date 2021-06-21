//
//  ChannelVoiceMessage.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-22.
//

import MIDIKitCommon

public typealias MIDICVMsg = MIDIEvent.ChannelVoiceMessage

// MARK: - MIDIEvent.ChannelVoiceMessage

extension MIDIEvent {
	
	public enum ChannelVoiceMessage: MIDIEventProtocol, Equatable, Hashable {
		
		#warning("> need associated values, and additional cases. check other midi lib.")
		#warning("> deal with noteOn velocity 0 as a noteOff")
		
		/// Channel Voice Message: Note On
		case noteOn(note: MIDIUInt7, velocity: MIDIUInt7, channel: MIDIUInt4)
		
		/// Channel Voice Message: Note Off
		case noteOff(note: MIDIUInt7, velocity: MIDIUInt7, channel: MIDIUInt4)
		
		/// Channel Voice Message: Polyphonic Aftertouch
		case polyAftertouch(note: MIDIUInt7, pressure: MIDIUInt7, channel: MIDIUInt4)
		
		/// Channel Voice Message: Controller Change (CC)
		case cc(_ type: MIDICC, channel: MIDIUInt4)
		
		/// Channel Voice Message: Program Change
		case programChange(program: MIDIUInt7, channel: MIDIUInt4)
		
		/// Channel Voice Message: Channel Aftertouch
		case chanAftertouch(pressure: MIDIUInt7, channel: MIDIUInt4)
		
		/// Channel Voice Message: Pitch Bend
		case pitchBend(value: MIDIUInt14, channel: MIDIUInt4)
		
		public var rawBytes: [Byte] { [] }
		
		public init(rawBytes: [Byte]) throws {
			
			#warning("> code this")
			self = .noteOn(note: 1, velocity: 1, channel: 1)
			
		}
		
		public func asEvent() -> MIDIEvent {
			
			MIDIEvent(self)
			
		}
		
	}
	
}


// MARK: - Kind

extension MIDIEvent.ChannelVoiceMessage {
	
	public enum Kind: MIDIEventKind, Equatable, Hashable, CaseIterable {
		
		case noteOn
		case noteOff
		case polyAftertouch
		case controllerChange
		case programChange
		case channelAftertouch
		case pitchBend
		
	}
	
	public var kind: Kind {
		
		switch self {
		case .noteOn:
			return .noteOn
		case .noteOff:
			return .noteOff
		case .polyAftertouch:
			return .polyAftertouch
		case .cc:
			return .controllerChange
		case .programChange:
			return .programChange
		case .chanAftertouch:
			return .channelAftertouch
		case .pitchBend:
			return .pitchBend
		}
		
	}
	
}


// MARK: - Attributes

extension MIDIEvent.ChannelVoiceMessage {
	
	public var channel: MIDIUInt4 {
		
		switch self {
		case .noteOn(_, _, let channel):
			return channel
		case .noteOff(_, _, let channel):
			return channel
		case .polyAftertouch(_, _, let channel):
			return channel
		case .cc(_, let channel):
			return channel
		case .programChange(_, let channel):
			return channel
		case .chanAftertouch(_, let channel):
			return channel
		case .pitchBend(_, let channel):
			return channel
		}
		
	}
	
}
