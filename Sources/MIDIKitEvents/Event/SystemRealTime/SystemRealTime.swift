//
//  SystemRealTime.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

public typealias MIDISysRT = MIDI.Event.SystemRealTime

// MARK: - MIDI.Event.SystemRealTime

extension MIDI.Event {
	
	public enum SystemRealTime: MIDIEventProtocol, Equatable, Hashable {
		
		#warning("> need associated values, and additional cases. check other midi lib.")
		
		case clock
		case start
		case stop
		case `continue`
		case activeSense
		case reset
		
		public var rawBytes: [Byte] { [] }
		
		public init(rawBytes: [Byte]) throws {
			
			#warning("> code this")
			self = .activeSense
			
		}
		
		public func asEvent() -> MIDI.Event {
			
			MIDI.Event(self)
			
		}
		
	}
	
}

// MARK: - Kind

extension MIDI.Event.SystemRealTime {
	
	public enum Kind: MIDIEventKindProtocol, Equatable, Hashable, CaseIterable {
		
		case clock
		case start
		case stop
		case `continue`
		case activeSense
		case reset
		
	}
	
	public var kind: Kind {
		
		switch self {
		case .clock:
			return .clock
		case .start:
			return .start
		case .stop:
			return .stop
		case .continue:
			return .continue
		case .activeSense:
			return .activeSense
		case .reset:
			return .reset
		}
		
	}
	
}

//extension MIDI.Event {
//	
//	/// MIDI Real Time Event
//	public struct RealTime {
//		
//		public enum Content {
//			#warning("> need associated values, and additional cases. check other midi lib.")
//			case clock
//			case start
//			case stop
//			case `continue`
//			case activeSense
//			case reset
//		}
//		
//		public internal(set) var rawBytes: [Byte] = []
//		
//		public var kind: MIDI.Event.Kind {
//			switch content {
//			case .clock:
//				return .realTimeClock
//			case .start:
//				return .realTimeStart
//			case .stop:
//				return .realTimeStop
//			case .continue:
//				return .realTimeContinue
//			case .activeSense:
//				return .realTimeActiveSense
//			case .reset:
//				return .realTimeReset
//			}
//		}
//		
//		public let category: MIDI.Event.Category = .systemRealTime
//		
//		internal var content: Content
//		
//		public init(_ content: Content) {
//			self.content = content
//			
//			#warning("> generate rawbytes here, maybe lazily generate first time rawBytes is accessed then cache after that? might not work if struct is immutable.")
//		}
//		
//		public init(rawBytes: [Byte]) throws {
//			self.rawBytes = []
//			self.content = .activeSense
//		}
//		
//	}
//	
//}
