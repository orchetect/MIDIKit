//
//  EventHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

protocol MIDIEventHandlerProtocol {
	
	func handle(_ event: MIDI.Event)
	
}

extension MIDI.Event {
	
	enum EventHandler {
		
		struct DebugLog: MIDIEventHandlerProtocol {
			
			public var verbose: Bool = true
			
			init(_ verbose: Bool = true) {
				
				self.verbose = verbose
				
			}
			
			func handle(_ event: MIDI.Event) {
				
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
