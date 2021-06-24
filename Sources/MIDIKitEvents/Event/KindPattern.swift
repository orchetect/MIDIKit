//
//  KindPattern.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore

// KindPattern

extension MIDI.Event {
	
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


extension MIDI.Event.ChannelVoiceMessage {
	
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

//extension Collection where Element == MIDI.Event.KindPattern {
//
//	/// Flattens Kinds into an array of all of its individual message types.
//	/// If any elements contain `nil` as their associated value, then all of its kinds are included.
//	public var flattened: [MIDIEventKindProtocol] {
//
//		var array: [MIDIEventKindProtocol] = []
//
//		for item in self {
//			switch item {
//			case .chanVoice(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDI.Event.ChannelVoiceMessage.Kind.allCases.map { $0 })
//
//			case .sysCommon(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDI.Event.SystemCommon.Kind.allCases.map { $0 })
//
//			case .sysRealTime(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDI.Event.SystemRealTime.Kind.allCases.map { $0 })
//
//			case .sysExclusive(let kinds):
//				array.append(contentsOf:
//								kinds ?? MIDI.Event.SystemExclusive.Kind.allCases.map { $0 })
//
//			case .raw:
//				array.append(MIDI.Event.Kind.raw)
//
//			}
//		}
//
//		return array
//
//	}
//
//}

extension Collection where Element == MIDI.Event.KindPattern {
	
	/// Filters and consolidates all `.chanVoice` cases into a single case.
	public func filterChannelVoiceAndConsolidate() -> [MIDI.Event.ChannelVoiceMessage.KindPattern]? {
		
		var output: [MIDI.Event.ChannelVoiceMessage.KindPattern]? = nil
		
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
					output?.formUnion(MIDI.Event.ChannelVoiceMessage.KindPattern.allCases)
				}
				
			}
			
		}
		
		return output
		
	}
	
}

extension MIDI.Event.KindPattern {
	
	/// Returns the associated value of `.chanVoice()` if `self` is a `.chanVoice()` case.
	/// Returns nil if `self` is not a `.chanVoice` case.
	public func filterChannelVoice() -> ([MIDI.Event.ChannelVoiceMessage.KindPattern]?)? {
		
		if case .chanVoice(let subPattern) = self {
			return subPattern
		}
		
		return nil
		
	}
	
}
