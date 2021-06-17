//
//  MTC Generator State.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-06-09.
//

// MARK: - State

extension MTC.Generator {
	
	public enum State: Equatable {
		
		/// Idle:
		/// No activity (outgoing continuous data stream stopped).
		case idle
		
		/// Generating:
		/// Generator is actively generating messages.
		case generating
		
	}
	
}

extension MTC.Generator.State: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .idle:
			return "idle"
		case .generating:
			return "generating"
		}
		
	}
	
}
