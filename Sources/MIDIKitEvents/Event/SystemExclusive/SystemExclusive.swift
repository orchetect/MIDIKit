//
//  SystemExclusive.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public typealias MIDISysEx = MIDI.Event.SystemExclusive

// MARK: - MIDI.Event.SystemExclusive

extension MIDI.Event {
	
	public enum SystemExclusive: MIDIEventProtocol, Equatable, Hashable {
		
		case sysEx(manufacturer: Byte, message: [Byte])
		
		public var rawBytes: [Byte] {
			
			switch self {
			case .sysEx(let manufacturer, let message):
				return [0xF0, manufacturer] + message + [0xF7]
			}
			
		}
		
		public init(rawBytes: [Byte]) throws {
			
			// prevent zero-byte events from being formed
			guard !rawBytes.isEmpty else {
				throw ParseError.rawBytesEmpty
			}
			
			// minimum length
			guard rawBytes.count >= 3 else {
				throw ParseError.malformed
			}
			
			// sysex must start and end with specific bytes
			guard rawBytes.first == 0xF0,
				  rawBytes.last == 0xF7 else {
				throw ParseError.malformed
			}
			
			// manufacturer byte
			
			let manufacturer = rawBytes[rawBytes.startIndex.advanced(by: 1)]
			
			// message bytes
			
			let messageBytes: [Byte]
			
			if rawBytes.count > 3 {
				let mbRange =
					rawBytes.startIndex.advanced(by: 2) ...
					rawBytes.endIndex.advanced(by: -2)
					
				messageBytes = Array(rawBytes[mbRange])
			} else {
				messageBytes = []
			}
			
			// return
			
			self = .sysEx(manufacturer: manufacturer,
						  message: messageBytes)
			
		}
		
		public func asEvent() -> MIDI.Event {
			
			MIDI.Event(self)
			
		}
		
	}
	
}

// MARK: - Kind

extension MIDI.Event.SystemExclusive {
	
	public enum Kind: MIDIEventKindProtocol, Equatable, Hashable, CaseIterable {
		
		case systemExclusive
		
	}
	
	public var kind: Kind {
		
		switch self {
		case .sysEx:
			return .systemExclusive
		}
		
	}
	
}

// MARK: - Attributes

extension MIDI.Event.SystemExclusive {
	
	#warning("> this could return a name from kManufacturerSysExID too")
	
	public var manufacturer: Byte {
		
		switch self {
		case .sysEx(let manufacturer, _):
			return manufacturer
		}
		
	}
	
	public var messageBytes: [Byte] {
		
		switch self {
		case .sysEx(_, let messageBytes):
			return messageBytes
		}
		
	}
	
}
