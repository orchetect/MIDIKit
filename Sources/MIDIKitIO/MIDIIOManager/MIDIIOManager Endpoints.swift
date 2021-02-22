//
//  MIDIIOManager Endpoints.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

public typealias MIDIEndpointUniqueID = Int32

extension MIDIIOManager {
	
	public func createConnectedDestination(
		named: String,
		tag: String
	) {
		
		let newCD = ConnectedDestination(named: named)
		
		#warning("> code this")
		_ = newCD
		_ = tag
		
	}
	
	public func createConnectedSource(
		named: String,
		tag: String,
		receiveHandler: @escaping () -> Void
	) {
		
		let newCS = ConnectedSource(named: named,
									receiveHandler: receiveHandler)
		
		#warning("> code this")
		_ = newCS
		_ = tag
		
	}
	
	/// Creates a connection and adds it to the `connectedThrusNonPersistent` dictionary.
	///
	/// If connection is non-persistent, it will be added to the `connectedThrusNonPersistent` dictionary. Persistent connections are stored by the system and references will not be directly stored by the app.
	///
	/// To analyze or delete a persistent connection, access the `MIDIIOConnectedThrusPersistentEntries` function.
	///
	/// - Note: Max 8 sources and max 8 destinations are allowed when forming a thru connection.
	///
	/// - parameter sources: maximum of 8 `MIDIEndpointRef` references
	/// - parameter destinations: maximum of 8 `MIDIEndpointRef` references
	/// - parameter tag: Unique `String` key to refer to the new `MIDIIOConnectedThru` object that gets added to `connectedThrus` collection dictionary
	/// - parameter persistent: If `false`, thru connection will expire when the app terminates. If `true`, the connection persists in the system forever (but not sure if it survives after macOS account logout / Mac reboot?).
	public func createThruConnection(
		sources: [MIDIEndpointRef],
		destinations: [MIDIEndpointRef],
		tag: String,
		persistent: Bool = false
	) {
		
		let newCT = ConnectedThru(sources: sources,
								  destinations: destinations,
								  persistentOwnerID: persistent ? domain : nil)
		
		// if non-persistent, add to managed array
		if !persistent {
			//connectedThrusNonPersistent[tag] = newTC
		}
		
		// otherwise, we won't store a reference to a persistent thru connection
		// persistent connections are stored by the system
		// to analyze or delete a persistent connection, access the `MIDIIOConnectedThrusPersistentEntries` function
		
		#warning("> code this")
		_ = newCT
		_ = tag
		
	}
	
	public func createVirtualDestination(
		name: String,
		tag: String,
		uniqueID: MIDIEndpointUniqueID? = nil,
		receiveHandler: @escaping () -> Void
	) -> MIDIEndpointUniqueID {
		
		let newVD = VirtualDestination(name: name,
									   uniqueID: uniqueID,
									   receiveHandler: receiveHandler)
		
		#warning("> code this")
		_ = newVD
		_ = tag
		return 0
	}
	
	public func createVirtualSource(
		name: String,
		tag: String,
		uniqueID: MIDIEndpointUniqueID? = nil
	) -> MIDIEndpointUniqueID {
		
		let newVS = VirtualSource(name: name,
								  uniqueID: uniqueID)
		
		#warning("> code this")
		_ = newVS
		_ = tag
		return 0
	}
	
}
