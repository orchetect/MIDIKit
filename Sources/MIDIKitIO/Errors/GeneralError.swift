//
//  GeneralError.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

extension MIDIIO {
	
	public enum GeneralError: Error {
		
		case connectionError(_ verboseError: String)
		
		case readError(_ verboseError: String)
		
	}
	
}
