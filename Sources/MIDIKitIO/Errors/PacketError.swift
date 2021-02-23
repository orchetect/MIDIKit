//
//  PacketError.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

extension MIDIIO {
	
	public enum PacketError: Error {
		
		case internalInconsistency(_ verboseError: String)
		
		case malformed(_ verboseError: String)
		
	}
	
}
