//
//  EventHandler.swift
//  MIDIKit
//

protocol MIDIEventHandler {
	
	func handle(_ event: MIDIEvent)
	
}

extension MIDIEvent {
	
	enum EventHandler {
		
		struct DebugLog: MIDIEventHandler {
			
			public var verbose: Bool = true
			
			init(_ verbose: Bool = true) {
				
				self.verbose = verbose
				
			}
			
			func handle(_ event: MIDIEvent) {
				
//				switch event {
//				case let e as Event:
//					
//				case let e as RawEvent:
//					
//				}
				
			}
			
		}
		
	}
	
}
