//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - MIDI.Event

extension MIDI {
	
	public struct Event: MIDIEventProtocol, Equatable, Hashable {
		
		public let message: Message
		
		public let rawBytes: [Byte]
		
		// MARK: - init
		
		public init(_ message: ChannelVoiceMessage) {
			
			self.message = .chanVoice(message)
			
			#warning("> deal with rawBytes")
			rawBytes = []
			
		}
		
		public init(_ message: SystemCommon) {
			
			self.message = .sysCommon(message)
			
			#warning("> deal with rawBytes")
			rawBytes = []
			
		}
		
		public init(_ message: SystemRealTime) {
			
			self.message = .sysRealTime(message)
			
			#warning("> deal with rawBytes")
			rawBytes = []
			
		}
		
		public init(_ message: SystemExclusive) {
			
			self.message = .sysExclusive(message)
			
			#warning("> deal with rawBytes")
			rawBytes = []
			
		}
		
		public init(rawBytes: [Byte]) throws {
			
			self.message = .raw
			
			// prevent zero-byte events from being formed
			guard !rawBytes.isEmpty else {
				throw ParseError.rawBytesEmpty
			}
			
			self.rawBytes = rawBytes
			
		}
		
		public func asEvent() -> MIDI.Event {
			
			self
			
		}
		
	}
	
}

// MARK: - Kind

extension MIDI.Event {
	
	public enum Kind: MIDIEventKindProtocol, Equatable, CaseIterable {
		
		case chanVoice
		case sysCommon
		case sysRealTime
		case sysEx
		case raw
		
	}
	
	public var kind: Kind {
		
		switch message {
		case .chanVoice:
			return .chanVoice
		case .sysCommon:
			return .sysCommon
		case .sysRealTime:
			return .sysRealTime
		case .sysExclusive:
			return .sysEx
		case .raw:
			return .raw
		}
		
	}
	
	//	public var kindGeneralized: MIDIEventKindProtocol {
	//
	//		kind
	//
	//	}
	
}

extension MIDI.Event {
	
	public enum Message: Equatable, Hashable {
		
		case chanVoice(ChannelVoiceMessage)
		case sysCommon(SystemCommon)
		case sysRealTime(SystemRealTime)
		case sysExclusive(SystemExclusive)
		case raw
		
	}
	
}

extension MIDI.Event: CustomStringConvertible {
	
	public var description: String {
		"MIDI.Event(\(kind))"
	}
	
}
