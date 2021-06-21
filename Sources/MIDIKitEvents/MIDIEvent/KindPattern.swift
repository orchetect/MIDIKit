//
//  KindPattern.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-13.
//

@_implementationOnly import OTCore

// KindPattern

extension MIDIEvent {
	
	public enum KindPattern: Equatable, Hashable, CaseIterable {
		
		case chanVoice([ChannelVoiceMessage.KindPattern]? = nil)
		case sysCommon([SystemCommon.Kind]? = nil)
		case sysRealTime([SystemRealTime.Kind]? = nil)
		case sysExclusive([SystemExclusive.Kind]? = nil)
		case raw
		
		public static var allCases: [Self] = [
			.chanVoice(nil),
			.sysCommon(nil),
			.sysRealTime(nil),
			.sysExclusive(nil),
			.raw
		]
		
	}
	
}


extension MIDIEvent.ChannelVoiceMessage {
	
	public enum KindPattern: Equatable, Hashable, CaseIterable {
		
		case noteOn
		case noteOff
		case polyAftertouch
		case controllerChange([ControllerChange.Kind]? = nil)
		case programChange
		case channelAftertouch
		case pitchBend
		
		public static var allCases: [Self] = [
			.noteOn,
			.noteOff,
			.polyAftertouch,
			.controllerChange(nil),
			.programChange,
			.channelAftertouch,
			.pitchBend
		]
		
	}
	
}

// MARK: - .flattened

//extension Collection where Element == MIDIEvent.KindPattern {
//
//	/// Flattens Kinds into an array of all of its individual message types.
//	/// If any elements contain `nil` as their associated value, then all of its kinds are included.
//	public var flattened: [MIDIEventKind] {
//
//		var array: [MIDIEventKind] = []
//
//		for item in self {
//			switch item {
//			case .chanVoice(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDIEvent.ChannelVoiceMessage.Kind.allCases.map { $0 })
//
//			case .sysCommon(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDIEvent.SystemCommon.Kind.allCases.map { $0 })
//
//			case .sysRealTime(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDIEvent.SystemRealTime.Kind.allCases.map { $0 })
//
//			case .sysExclusive(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDIEvent.SystemExclusive.Kind.allCases.map { $0 })
//
//			case .raw:
//				array.append(MIDIEvent.Kind.raw)
//
//			}
//		}
//
//		return array
//
//	}
//
//}

extension Collection where Element == MIDIEvent.KindPattern {
	
	/// Filters and consolidates all `.chanVoice` cases into a single case.
	public func filterChannelVoiceAndConsolidate() -> [MIDIEvent.ChannelVoiceMessage.KindPattern]? {
		
		var output: [MIDIEvent.ChannelVoiceMessage.KindPattern]? = nil
		
		// extract chanVoice-only pattern entries
		self.forEach { kindPattern in
			
			if let chanVoiceAssociatedValue = kindPattern.filterChannelVoice() {
				// pattern is a chanVoice case.
				
				if let unwrappedChanVoiceAssociatedValue = chanVoiceAssociatedValue {
					if output == nil {
						output = []
					}
					output?.formUnion(unwrappedChanVoiceAssociatedValue)
				} else {
					output?.formUnion(MIDIEvent.ChannelVoiceMessage.KindPattern.allCases)
				}
				
			}
			
		}
		
		return output
		
	}
	
}

extension MIDIEvent.KindPattern {
	
	/// Returns the associated value of `.chanVoice()` if `self` is a `.chanVoice()` case.
	/// Returns nil if `self` is not a `.chanVoice` case.
	public func filterChannelVoice() -> ([MIDIEvent.ChannelVoiceMessage.KindPattern]?)? {
		
		if case .chanVoice(let subPattern) = self {
			return subPattern
		}
		
		return nil
		
	}
	
}
