//
//  ChannelVoiceMessage.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitCommon

public typealias MIDICVMsg = MIDI.Event.ChannelVoiceMessage

// MARK: - MIDI.Event.ChannelVoiceMessage

extension MIDI.Event {
	
	public enum ChannelVoiceMessage: MIDIEventProtocol, Equatable, Hashable {
		
		#warning("> need associated values, and additional cases. check other midi lib.")
		#warning("> deal with noteOn velocity 0 as a noteOff")
		
		/// Channel Voice Message: Note On
		case noteOn(note: MIDI.UInt7, velocity: MIDI.UInt7, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Note Off
		case noteOff(note: MIDI.UInt7, velocity: MIDI.UInt7, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Polyphonic Aftertouch
		case polyAftertouch(note: MIDI.UInt7, pressure: MIDI.UInt7, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Controller Change (CC)
		case cc(_ type: MIDICC, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Program Change
		case programChange(program: MIDI.UInt7, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Channel Aftertouch
		case chanAftertouch(pressure: MIDI.UInt7, channel: MIDI.UInt4)
		
		/// Channel Voice Message: Pitch Bend
		case pitchBend(value: MIDI.UInt14, channel: MIDI.UInt4)
		
		public var rawBytes: [Byte] { [] }
		
		public init(rawBytes: [Byte]) throws {
			
			#warning("> code this")
			self = .noteOn(note: 1, velocity: 1, channel: 1)
			
		}
		
		public func asEvent() -> MIDI.Event {
			
			MIDI.Event(self)
			
		}
		
	}
	
}


// MARK: - Kind

extension MIDI.Event.ChannelVoiceMessage {
	
	public enum Kind: MIDIEventKindProtocol, Equatable, Hashable, CaseIterable {
		
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

extension MIDI.Event.ChannelVoiceMessage {
	
	public var channel: MIDI.UInt4 {
		
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
