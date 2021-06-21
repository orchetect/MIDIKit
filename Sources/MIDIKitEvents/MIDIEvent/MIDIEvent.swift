//
//  MIDIEvent.swift
//  MIDIKit
//

// MARK: - MIDIEvent

public struct MIDIEvent: MIDIEventProtocol, Equatable, Hashable {
	
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
	
	public func asEvent() -> MIDIEvent {
		
		self
		
	}
	
}

// MARK: - Kind

extension MIDIEvent {
	
	public enum Kind: MIDIEventKind, Equatable, CaseIterable {
		
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
	
//	public var kindGeneralized: MIDIEventKind {
//		
//		kind
//		
//	}
	
}

extension MIDIEvent {
	
	public enum Message: Equatable, Hashable {
		
		case chanVoice(ChannelVoiceMessage)
		case sysCommon(SystemCommon)
		case sysRealTime(SystemRealTime)
		case sysExclusive(SystemExclusive)
		case raw
		
	}
	
}

extension MIDIEvent: CustomStringConvertible {

	public var description: String {
		"MIDIEvent(\(kind))"
	}

}
