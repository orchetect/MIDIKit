//
//  MTC MessageType.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-22.
//

extension MTC {
	
	public enum MessageType {
		
		/// MTC Full-Frame Message
		///
		/// Timecode changed as a result of a full-frame message, which a MTC transmitter will send while not playing back but locating to a new timecode
		case fullFrame
		
		/// MTC Quarter-Frame Message
		///
		/// Timecode changed as a result of MTC quarter-frame data stream
		case quarterFrame
		
	}
	
}
