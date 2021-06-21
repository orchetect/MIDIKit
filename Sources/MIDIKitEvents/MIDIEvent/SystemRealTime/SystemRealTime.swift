//
//  SystemRealTime.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-22.
//

public typealias MIDISysRT = MIDIEvent.SystemRealTime

// MARK: - MIDIEvent.SystemRealTime

extension MIDIEvent {
	
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
		
		public func asEvent() -> MIDIEvent {
			
			MIDIEvent(self)
			
		}
		
	}
	
}

// MARK: - Kind

extension MIDIEvent.SystemRealTime {
	
	public enum Kind: MIDIEventKind, Equatable, Hashable, CaseIterable {
		
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

//extension MIDIEvent {
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
//		public var kind: MIDIEvent.Kind {
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
//		public let category: MIDIEvent.Category = .systemRealTime
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
