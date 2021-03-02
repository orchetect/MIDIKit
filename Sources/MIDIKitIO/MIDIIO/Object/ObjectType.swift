//
//  ObjectType.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-27.
//

import Foundation

// MARK: - MIDIIO.ObjectType

extension MIDIIO {
	
	public enum ObjectType: CaseIterable, Hashable {
		
		case device
		case entity
		case endpoint
		
	}
	
}
