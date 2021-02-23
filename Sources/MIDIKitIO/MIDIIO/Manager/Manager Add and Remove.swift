//
//  Manager Add and Remove.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

public typealias MIDIEndpointUniqueID = Int32

extension MIDIIO.Manager {
	
	public func addConnectedSource(
		named: String,
		tag: String
	) throws {
		
		let newCS = MIDIIO.ConnectedSource(named: named)
		
		// store the connection object in the manager,
		// even if subsequent connection fails
		connectedSources[tag] = newCS
		
		try newCS.connect(context: self)
		
	}
	
	public func addConnectedDestination(
		named: String,
		tag: String,
		receiveHandler: @escaping MIDIReadBlock
	) throws {
		
		let newCD = MIDIIO.ConnectedDestination(
			named: named,
			receiveHandler: receiveHandler
		)
		
		// store the connection object in the manager,
		// even if subsequent connection fails
		connectedDestinations[tag] = newCD
		
		try newCD.connect(context: self)
		
	}
	
	#warning("> update documentation here")
	/// Creates a MIDI play-through (thru) connection.
	///
	/// If connection is non-persistent, it will be added to the `connectedThrusNonPersistent` dictionary. Persistent connections are stored by the system and references will not be directly stored by the app.
	///
	/// To analyze or delete a persistent connection, access the `connectedThrusPersistent` property.
	///
	/// - Note: Max 8 sources and max 8 destinations are allowed when forming a thru connection.
	///
	/// - parameter sources: maximum of 8 `MIDIEndpointRef` references
	/// - parameter destinations: maximum of 8 `MIDIEndpointRef` references
	/// - parameter tag: Unique `String` key to refer to the new object that gets added to `connectedThrus` collection dictionary
	/// - parameter persistent: If `false`, thru connection will expire when the app terminates. If `true`, the connection persists in the system forever (but not sure if it survives after macOS account logout / Mac reboot?).
	public func addThruConnection(
		sources: [MIDIEndpointRef],
		destinations: [MIDIEndpointRef],
		params: MIDIThruConnectionParams? = nil,
		tag: String,
		persistent: Bool = false
	) throws {
		
		let newCT = MIDIIO.ConnectedThru(
			sources: sources,
			destinations: destinations,
			persistentOwnerID: persistent ? persistentDomain : nil,
			params: params
		)
		
		// if non-persistent, add to managed array
		if !persistent {
			// store the connection object in the manager,
			// even if subsequent connection fails
			connectedThrusNonPersistent[tag] = newCT
		}
		
		// otherwise, we won't store a reference to a persistent thru connection
		// persistent connections are stored by the system
		// to analyze or delete a persistent connection,
		// access the `connectedThrusPersistent` computed property,
		// first ensuring the correct `.domain` property (bundle ID) is set
		
		try newCT.create(context: self)
		
	}
	
	public func addVirtualDestination(
		name: String,
		tag: String,
		uniqueID: MIDIEndpointUniqueID? = nil,
		receiveHandler: @escaping MIDIReadBlock
	) throws -> MIDIEndpointUniqueID {
		
		let newVD = MIDIIO.VirtualDestination(
			name: name,
			uniqueID: uniqueID,
			receiveHandler: receiveHandler
		)
		
		virtualDestinations[tag] = newVD
		
		try newVD.create(context: self)
		
		guard let uniqueID = newVD.uniqueID else {
			throw MIDIIO.GeneralError.connectionError("Could not read virtual MIDI endpoint unique ID.")
		}
		
		return uniqueID
		
	}
	
	public func addVirtualSource(
		name: String,
		tag: String,
		uniqueID: MIDIEndpointUniqueID? = nil
	) throws -> MIDIEndpointUniqueID {
		
		let newVS = MIDIIO.VirtualSource(
			name: name,
			uniqueID: uniqueID
		)
		
		virtualSources[tag] = newVS
		
		try newVS.create(context: self)
		
		guard let uniqueID = newVS.uniqueID else {
			throw MIDIIO.GeneralError.connectionError("Could not read virtual MIDI endpoint unique ID.")
		}
		
		return uniqueID
		
	}
	
}

extension MIDIIO.Manager {
	
	public func removeConnectedDestination(tag: String) {
		
		connectedDestinations[tag] = nil
		
	}
	
	public func removeConnectedSource(tag: String) {
		
		connectedSources[tag] = nil
		
	}
	
	public func removeNonPersistentThruConnection(tag: String) {
		
		connectedThrusNonPersistent[tag] = nil
		
	}
	
	public func removeVirtualDestination(tag: String) {
		
		virtualDestinations[tag] = nil
		
	}
	
	public func removeVirtualSource(tag: String) {
		
		virtualSources[tag] = nil
		
	}
	
}
