//
//  SystemCommon.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-22.
//

public typealias MIDISysCom = MIDIEvent.SystemCommon

// MARK: - MIDIEvent.SystemCommon

extension MIDIEvent {
	
	public enum SystemCommon: MIDIEventProtocol, Equatable, Hashable {
		
		#warning("> need associated values, and additional cases. check other midi lib.")
		
		
		case timecode
		
		/// Song Position Pointer
		///
		/// - remark: MIDI Spec: "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
		case songPositionPointer
		
		/// Song Select
		///
		/// - remark: MIDI Spec: "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
		case songSelect
		
		/// Tune Request
		///
		/// - remark: MIDI Spec: "Used with analog synthesizers to request that all oscillators be tuned."
		case tuneRequest
		
		public var rawBytes: [Byte] { [] }
		
		public init(rawBytes: [Byte]) throws {
			
			#warning("> code this")
			self = .timecode
			
		}
		
		public func asEvent() -> MIDIEvent {
			
			MIDIEvent(self)
			
		}
		
	}
	
}

// MARK: - Kind

extension MIDIEvent.SystemCommon {
	
	public enum Kind: MIDIEventKind, Equatable, Hashable, CaseIterable {
		
		case timecode
		case songPositionPointer
		case songSelect
		case tuneRequest
		
	}
	
	public var kind: Kind {
		
		switch self {
		case .timecode:
			return .timecode
		case .songPositionPointer:
			return .songPositionPointer
		case .songSelect:
			return .songSelect
		case .tuneRequest:
			return .tuneRequest
		}
		
	}
	
}

//extension MIDIEvent {
//	
//	/// MIDI System Common Event
//	public struct SystemCommon {
//		
//		public enum Content {
//			#warning("> need associated values, and additional cases. check other midi lib.")
//			case timecode
//			case songPositionPointer
//			case songSelect
//			case tuneRequest
//		}
//		
//		public internal(set) var rawBytes: [Byte] = []
//		
//		public var kind: MIDIEvent.Kind {
//			switch content {
//			case .timecode:
//				return .systemCommonTimecode
//			case .songPositionPointer:
//				return .systemCommonSongPosition
//			case .songSelect:
//				return .systemCommonSongSelect
//			case .tuneRequest:
//				return .systemCommonTuneRequest
//			}
//		}
//		
//		public let category: MIDIEvent.Category = .systemCommon
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
//			self.content = .timecode
//		}
//		
//	}
//	
//}
