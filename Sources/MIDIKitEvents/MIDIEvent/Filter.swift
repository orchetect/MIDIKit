//
//  Filter.swift
//  MIDIKit
//  

extension Collection where Element == MIDIEvent {
	
	// filter category
	
	/// Filters voice messages, producing a typed array of `[MIDIEvent.ChannelVoiceMessage]`, which will expose contextual category methods & properties pertaining to Channel Voice messages.
	public func filterChannelVoice() -> [MIDIEvent.ChannelVoiceMessage] {
		
		self.compactMap { item -> MIDIEvent.ChannelVoiceMessage? in
			
			if case .chanVoice(let msg) = item.message {
				return msg
			}
			return nil
			
		}
		
	}
	
	/// Filters voice messages, producing a typed array of `[MIDIEvent.SystemCommon]`, which will expose contextual category methods & properties pertaining to System Common messages.
	public func filterSystemCommon() -> [MIDIEvent.SystemCommon] {
		
		self.compactMap { item -> MIDIEvent.SystemCommon? in
			
			if case .sysCommon(let msg) = item.message {
				return msg
			}
			return nil
			
		}
		
	}
	
	/// Filters voice messages, producing a typed array of `[MIDIEvent.SystemRealTime]`, which will expose contextual category methods & properties pertaining to Real Time messages.
	public func filterRealTime() -> [MIDIEvent.SystemRealTime] {
		
		self.compactMap { item -> MIDIEvent.SystemRealTime? in
			
			if case .sysRealTime(let msg) = item.message {
				return msg
			}
			return nil
			
		}
		
	}
	
	/// Filters voice messages, producing a typed array of `[MIDIEvent.SystemExclusive]`, which will expose contextual category methods & properties pertaining to System Exclusive messages.
	public func filterSystemExclusive() -> [MIDIEvent.SystemExclusive] {
		
		self.compactMap { item -> MIDIEvent.SystemExclusive? in
			
			if case .sysExclusive(let msg) = item.message {
				return msg
			}
			return nil
			
		}
		
	}
	
	// filterRaw() ?
	
	// filter kinds
	
	/// Returns an array of `MIDIEvent`s matching the specified `kinds`.
	public func filter(_ kinds: [MIDIEventKind]) -> [MIDIEvent] {
		
		guard !kinds.isEmpty else { return [] }
		
		return self.compactMap { item -> MIDIEvent? in
			
			switch item.message {
			case .chanVoice(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? item : nil

			case .sysCommon(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? item : nil

			case .sysRealTime(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? item : nil

			case .sysExclusive(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? item : nil

			case .raw:
				return kinds.contains(where: { $0.equals(MIDIEvent.Kind.raw) })
					? item : nil
				
			}
			
		}
		
	}
	
	/// Returns an array of `MIDIEvent`s matching the specified `pattern`.
	/// - Complexity: O(n) lazily
	public func filter(pattern: [MIDIEvent.KindPattern]) -> [MIDIEvent] {
		
		guard !pattern.isEmpty else { return [] }
		
		// iterate over self
		return self.compactMap { item -> MIDIEvent? in
			
			switch item.message {
			case .chanVoice(let msg):
				
				// filters the pattern to just channel voice and flattens if nil
				let typedKindPattern = pattern.filterChannelVoiceAndConsolidate()
				
				let cvFilter = [msg].filter(pattern: typedKindPattern)
				
				return !cvFilter.isEmpty
					? item : nil
				
				
			case .sysCommon(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysCommon(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? item : nil
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return item
						}
						
					}
					
				}
				
			case .sysRealTime(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysRealTime(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? item : nil
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return item
						}
						
					}
					
				}
				
			case .sysExclusive(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysExclusive(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? item : nil
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return item
						}
						
					}
					
				}
				
			case .raw:
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .raw = patternEntry {
						return item
					} else {
						return nil
					}
					
				}
			
			}
			
			return nil
			
		}
		
	}
	
	// dropkinds
	
	/// Returns an array of `MIDIEvent`s excluding events matching the specified `kinds`.
	public func drop(_ kinds: [MIDIEventKind]) -> [MIDIEvent] {
		
		guard !kinds.isEmpty else {
			// return self without modifying contents

			if let selfArray = self as? [MIDIEvent] {
				// self is an Array, return as-is
				return selfArray
			} else {
				// self is not an Array, convert to Array then return it
				return self.map { $0 }
			}
		}

		return self.compactMap { item -> MIDIEvent? in
			switch item.message {
			case .chanVoice(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? nil : item

			case .sysCommon(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? nil : item

			case .sysRealTime(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? nil : item

			case .sysExclusive(let msg):
				return kinds.contains(where: { $0.equals(msg.kind) })
					? nil : item

			case .raw:
				return kinds.contains(where: { $0.equals(MIDIEvent.Kind.raw) })
					? nil : item

			}
		}
		
	}
	
	/// Returns an array of `MIDIEvent`s excluding events matching the specified `pattern`.
	public func drop(pattern: [MIDIEvent.KindPattern]) -> [MIDIEvent] {
		
		guard !pattern.isEmpty else {
			// return self without modifying contents

			if let selfArray = self as? [MIDIEvent] {
				// self is an Array, return as-is
				return selfArray
			} else {
				// self is not an Array, convert to Array then return it
				return self.map { $0 }
			}
		}
		
		// iterate over self
		return self.compactMap { item -> MIDIEvent? in
			
			switch item.message {
			case .chanVoice(let msg):
				
				let typedKindPattern = pattern.filterChannelVoiceAndConsolidate()
				
				let cvFilter = [msg].filter(pattern: typedKindPattern)
				
				return cvFilter.isEmpty
					? nil : item
				
			case .sysCommon(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysCommon(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? nil : item
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return nil
						}
						
					}
					
				}
				
			case .sysRealTime(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysRealTime(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? nil : item
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return nil
						}
						
					}
					
				}
				
			case .sysExclusive(let msg):
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .sysExclusive(let subPattern) = patternEntry {
						
						if let subPattern = subPattern {
							return subPattern.contains(msg.kind)
								? nil : item
						} else {
							// nil sub-pattern array; wildcard match all of the parent kind
							return nil
						}
						
					}
					
				}
				
			case .raw:
				
				// iterate over pattern collection
				for patternEntry in pattern {
					
					if case .raw = patternEntry {
						return nil
					} else {
						return item
					}
					
				}
			
			}
			
			return item
			
		}
		
	}
	
}

extension Collection where Element == MIDIEvent.ChannelVoiceMessage {
	
	/// Returns an array of `MIDIEvent.ChannelVoiceMessage`s matching the specified `pattern`.
	/// Complexity: O(n) lazily
	public func filter(pattern: [MIDIEvent.ChannelVoiceMessage.KindPattern]?) -> [MIDIEvent.ChannelVoiceMessage] {
		
		guard let pattern = pattern,
			  !pattern.isEmpty else {
			
			return []
			
		}
		
		return self.compactMap { item -> MIDIEvent.ChannelVoiceMessage? in
			
			// iterate over pattern collection
			for patternEntry in pattern {
				
				switch patternEntry {
				case .noteOn:
					return item.kind == .noteOn ? item : nil
					
				case .noteOff:
					return item.kind == .noteOff ? item : nil
					
				case .polyAftertouch:
					return item.kind == .polyAftertouch ? item : nil
					
				case .controllerChange(let controllerChangePattern):
					guard case .cc(let cc, _) = item else { return nil }
					return [cc].filter(pattern: controllerChangePattern).isEmpty ? nil : item
					
				case .programChange:
					return item.kind == .programChange ? item : nil
					
				case .channelAftertouch:
					return item.kind == .channelAftertouch ? item : nil
					
				case .pitchBend:
					return item.kind == .pitchBend ? item : nil
					
				}
				
			}
			
			return nil
			
		}
		
		
//		self.compactMap { item -> MIDIEvent.ChannelVoiceMessage? in
//
//
//
//			switch item {
//			case .cc(let cc, let channel):
//
//				// iterate over pattern collection
//				for patternEntry in pattern {
//
//					if case .chanVoice(let subPattern1) = patternEntry,
//					   case .controllerChange(let subPattern2) = subPattern1 {
//
//						if let subPattern2 = subPattern2 {
//							return subPattern2.contains(where: { $0 == 1 })
//								? item : nil
//						} else {
//							// nil sub-pattern array; wildcard match all of the parent kind
//							return item
//						}
//
//					}
//
//				}
//
//
//			default: return nil // code this for each other enum case *****
//			}
//
//		}
		
	}
	
	/// Returns an array of `MIDIEvent`s excluding events matching the specified `pattern`.
	public func drop(pattern: [MIDIEvent.ChannelVoiceMessage.KindPattern]) -> [MIDIEvent] {
		
		#warning("> code this")
		
		return []
		
	}
	
}

extension Collection where Element == MIDIEvent.ChannelVoiceMessage.ControllerChange {
	
	/// Returns an array of `MIDIEvent.ChannelVoiceMessage`s matching the specified `pattern`.
	/// Complexity: O(n) lazily
	public func filter(pattern: [MIDIEvent.ChannelVoiceMessage.ControllerChange.Kind]?) -> [MIDIEvent.ChannelVoiceMessage.ControllerChange] {
		
		guard let pattern = pattern,
			  !pattern.isEmpty else {
			
			return []
			
		}
		
		return self.compactMap { item -> MIDIEvent.ChannelVoiceMessage.ControllerChange? in
			
			// iterate over pattern collection
			for patternEntry in pattern {
				
				guard case .controller(let ccNum) = patternEntry else {
					return nil
				}
				
				return item.controller == ccNum
					? item : nil
				
			}
			
			return nil
			
		}
		
	}
	
}

extension Collection where Element == MIDIEvent {
	
	func filter(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 == element.kind }
		}

	}
	
	func drop(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 != element.kind }
		}

	}
	
}

extension Collection where Element == MIDIEvent.ChannelVoiceMessage {

	func filter(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 == element.kind }
		}

	}
	
	func drop(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 != element.kind }
		}

	}

}

extension Collection where Element == MIDIEvent.SystemCommon {

	func filter(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 == element.kind }
		}

	}
	
	func drop(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 != element.kind }
		}

	}

}

extension Collection where Element == MIDIEvent.SystemRealTime {

	func filter(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 == element.kind }
		}

	}
	
	func drop(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 != element.kind }
		}

	}

}

extension Collection where Element == MIDIEvent.SystemExclusive {

	func filter(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 == element.kind }
		}

	}
	
	func drop(_ kinds: [Element.Kind]) -> [Element] {

		filter { element in
			return kinds.contains { $0 != element.kind }
		}

	}

}






























//protocol MIDIIOEventFilter {
//	func filter(_ event: MIDIEventProtocol) -> MIDIEventProtocol?
//	func filter(_ events: [MIDIEventProtocol]) -> [MIDIEventProtocol]
//}
//
//extension MIDIIOEventFilter {
//
//	public func filter(_ events: [MIDIEventProtocol]) -> [MIDIEventProtocol] {
//		events.compactMap { filter($0) }
//	}
//}
//
//extension MIDIEvent {
//
//	public struct Filter: MIDIIOEventFilter {
//
//		public var filterClosure: (_ event: MIDIEventProtocol) -> MIDIEventProtocol?
//
//		public init(_ closure: @escaping (_ event: MIDIEventProtocol) -> MIDIEventProtocol?) {
//			filterClosure = closure
//		}
//
//		public func filter(_ event: MIDIEventProtocol) -> MIDIEventProtocol? {
//			filterClosure(event)
//		}
//
//	}
//
//}
//
//extension MIDIEventProtocol {
//
//	// filter types
//
//	/// Include only events with specified category
//	public func filterCategory(_ categories: [MIDIEvent.Category]) -> MIDIEventProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//	/// Exclude events with specified category
//	public func dropCategory(_ categories: [MIDIEvent.Category]) -> MIDIEventProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//	/// Include only events with specified kind
//	public func filterKind(_ kinds: [MIDIEvent.Kind]) -> MIDIEventProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//	/// Exclude events with specified kind
//	public func dropKind(_ kinds: [MIDIEvent.Kind]) -> MIDIEventProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//}
//
//extension MIDIEventVoiceMessageProtocol {
//
//	// filter parameters
//
//	/// Include only events with specified channels
//	public func filterChannel(_ channels: [Int]) -> MIDIEventVoiceMessageProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//	/// Exclude events with specified channels
//	public func dropChannel(_ channels: [Int]) -> MIDIEventVoiceMessageProtocol? {
//		#warning("> code this")
//		return nil
//	}
//
//}
//
//extension Collection where Element == MIDIEventProtocol {
//
//	// filter types
//
//	/// Include only events with specified category
//	public func filterCategory(_ categories: [MIDIEvent.Category]) -> [MIDIEventProtocol] {
//		compactMap { $0.filterCategory(categories) }
//	}
//
//	/// Exclude events with specified category
//	public func dropCategory(_ categories: [MIDIEvent.Category]) -> [MIDIEventProtocol] {
//		compactMap { $0.dropCategory(categories) }
//	}
//
//	/// Include only events with specified kind
//	public func filterKind(_ kinds: [MIDIEvent.Kind]) -> [MIDIEventProtocol] {
//		compactMap { $0.filterKind(kinds) }
//	}
//
//	/// Exclude events with specified kind
//	public func dropKind(_ kinds: [MIDIEvent.Kind]) -> [MIDIEventProtocol] {
//		compactMap { $0.dropKind(kinds) }
//	}
//
//}
//
//// experimental
//
//extension Collection where Element == MIDIEventVoiceMessageProtocol {
//
//	// filter parameters
//
//	/// Include only events with specified channels
//	public func filterChannel(_ channels: [Int]) -> [MIDIEventVoiceMessageProtocol] {
//		compactMap { $0.filterChannel(channels) }
//	}
//
//	/// Exclude events with specified channels
//	public func dropChannel(_ channels: [Int]) -> [MIDIEventVoiceMessageProtocol] {
//		compactMap { $0.dropChannel(channels) }
//	}
//
//}
//
//extension Collection where Element : MIDIEventVoiceMessageProtocol {
//
//	// filter parameters
//
//	/// Include only events with specified channels
//	public func filterChannel(_ channels: [Int]) -> [MIDIEventVoiceMessageProtocol] {
//		compactMap { $0.filterChannel(channels) }
//	}
//
//	/// Exclude events with specified channels
//	public func dropChannel(_ channels: [Int]) -> [MIDIEventVoiceMessageProtocol] {
//		compactMap { $0.dropChannel(channels) }
//	}
//
//}
//
//extension MIDIEvent.Filter {
//
//	// filter types
//
//	/// Filter events with specified category, either including or excluding
//	public static func category(_ categories: [MIDIEvent.Category], include: Bool) -> Self {
//		switch include {
//		case true:
//			return Self { $0.filterCategory(categories) }
//		case false:
//			return Self { $0.dropCategory(categories) }
//		}
//	}
//
//	/// Filter events with specified kind, either including or excluding
//	public static func kind(_ kinds: [MIDIEvent.Kind], include: Bool) -> Self {
//		switch include {
//		case true:
//			return Self { $0.filterKind(kinds) }
//		case false:
//			return Self { $0.dropKind(kinds) }
//		}
//	}
//
//	// filter parameters
//
//	/// Filter events with specified channels, either including or excluding
//	public static func channel(_ channels: [Int], include: Bool) -> Self {
//		switch include {
//		case true:
//			return Self { $0.filterChannel(channels) }
//		case false:
//			return Self { $0.dropChannel(channels) }
//		}
//	}
//
//}
