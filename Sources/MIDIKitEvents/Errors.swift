//
//  Errors.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-01-21.
//

extension MIDIEvent {
	
	public enum ParseError: Error {
		
		case rawBytesEmpty
		
		case malformed
		
		case invalidType
		
	}
	
}
