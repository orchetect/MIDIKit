//
//  MIDIIOObject.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-26.
//

import CoreMIDI

// MARK: - MIDIIOObject

public protocol MIDIIOObject: Identifiable {
	
	static var objectType: MIDIIO.ObjectType { get }
	
	var name: String { get }
	var uniqueID: UniqueID { get }
	
}

extension MIDIIOObject {
	
	public typealias UniqueID = Int32
	
}

// MARK: - MIDIIO.ObjectType

extension MIDIIO {
	
	public enum ObjectType: CaseIterable, Hashable {
		
		case device
		case entity
		case endpoint
		
	}
	
}
