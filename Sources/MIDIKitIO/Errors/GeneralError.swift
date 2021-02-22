//
//  GeneralError.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

extension MIDIIOManager {
	
	public enum GeneralError: Error {
		
		case readError(_ verboseError: String)
		
	}
	
}
