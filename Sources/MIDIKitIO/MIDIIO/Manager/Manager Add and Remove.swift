//
//  Manager Add and Remove.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

extension MIDIIO.Manager {
	
	/// Adds a managed connected destination to the `managedInputConnections` dictionary of the `Manager`.
	///
	/// - Parameters:
	///   - toSource: Unique ID of existing MIDI endpoint in the system to connect to.
	///   - tag: Internal unique tag to reference the managed item in the `Manager`.
	///   - receiveHandler: Event handler for received MIDI packets.
	///
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`
	public func addInputConnection(
		toSource: MIDIIO.Endpoint.IDCriteria,
		tag: String,
		receiveHandler: MIDIIO.ReceiveHandler
	) throws {
		
		#warning("> add withUniqueID param; match ID when connecting")
		
		let newCD = MIDIIO.InputConnection(
			toSource: toSource,
			receiveHandler: receiveHandler
		)
		
		// store the connection object in the manager,
		// even if subsequent connection fails
		managedInputConnections[tag] = newCD
		
		try newCD.connect(context: self)
		
	}
	
	/// Adds a managed connected source to the `managedOutputConnections` dictionary of the `Manager`.
	///
	/// - Parameters:
	///   - toDestination: Unique ID of existing MIDI endpoint in the system to connect to.
	///   - tag: Internal unique tag to reference the managed item in the `Manager`.
	///
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`
	public func addOutputConnection(
		toDestination: MIDIIO.Endpoint.IDCriteria,
		tag: String
	) throws {
		
		let newCS = MIDIIO.OutputConnection(
			toDestination: toDestination
		)
		
		// store the connection object in the manager,
		// even if subsequent connection fails
		managedOutputConnections[tag] = newCS
		
		try newCS.connect(context: self)
		
	}
	
	/// Creates a MIDI play-through (thru) connection.
	///
	/// If connection is non-persistent, a managed thru connection will be added to the `managedThruConnections` dictionary of the `Manager` and its lifecycle will be that of the `Manager` or until removeThruConnection is called for the connection.
	///
	/// If the connection is persistent, it is instead stored persistently by the system and references will not be directly stored in the `Manager`.
	///
	/// To analyze or delete a persistent connection, access the `unmanagedPersistentThrus` property.
	///
	/// - Note: Max 8 sources and max 8 destinations are allowed when forming a thru connection.
	///
	/// - parameter sources: Maximum of 8 `Endpoint`s.
	/// - parameter destinations: Maximum of 8 `Endpoint`s.
	/// - parameter tag: Unique `String` key to refer to the new object that gets added to `managedThruConnections` collection dictionary.
	/// - parameter persistent: If `false`, thru connection will expire when the app terminates. If `true`, the connection persists in the system forever (but not sure if it survives after macOS account logout / Mac reboot?).
	public func addThru(
		sources: MIDIIO.EndpointArray,
		destinations: MIDIIO.EndpointArray,
		tag: String,
		_ lifecycle: MIDIIO.ThruConnection.Lifecycle = .nonPersistent,
		params: MIDIThruConnectionParams? = nil
	) throws {
		
		let newCT = MIDIIO.ThruConnection(
			sources: sources,
			destinations: destinations,
			lifecycle,
			params: params
		)
		
		// if non-persistent, add to managed array
		if lifecycle == .nonPersistent {
			// store the connection object in the manager,
			// even if subsequent connection fails
			managedThruConnections[tag] = newCT
		}
		
		// otherwise, we won't store a reference to a persistent thru connection
		// persistent connections are stored by the system
		// to analyze or delete a persistent connection,
		// access the `unmanagedPersistentThrus` method.
		
		try newCT.create(context: self)
		
	}
	
	/// Adds a managed virtual destination to the `managedInputs` dictionary of the `Manager` and creates the MIDI port in the system.
	///
	/// The lifecycle of the MIDI port exists for as long as the `Manager` instance exists, or until `.remove(::)` is called.
	///
	/// - Parameters:
	///   - name: Name of the endpoint as seen in the system.
	///   - tag: Internal unique tag to reference the managed item in the `Manager`.
	///   - uniqueID: System-global unique identifier for the port. If nil, a random available ID will be assigned and returned if successful.
	///   - receiveHandler: Event handler for received MIDI packets.
	///
	/// A note on `uniqueID`:
	///
	/// It is required that the `uniqueID` be stored persistently in a data store of your choosing, and supplied when recreating the same port. This allows other applications to identify the port and reconnect to it, as the port name is not used to identify a MIDI port since MIDI ports are allowed to have the same name, but must have unique IDs.
	///
	/// It is best practise to re-store the `uniqueID` every time this method is called, since these IDs are temporal and not registered or reserved in the system in any way. Since ID collisions are possible, a new available random ID will be obtained and returned if that happens, and that updated ID should be stored in-place of the old one in your data store.
	///
	/// Do not generate the number yourself. Rather, if no ID is yet stored, pass `nil` for `uniqueID` and allow the method to generate the new ID for you, then store it. Next time the same port is added, fetch that ID and supply it as the `uniqueID`, remembering to re-store the returned `uniqueID` once more in the event that there was a collision and a new ID has been returned.
	///
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`.
	/// - Returns: The port's effective `uniqueID`.
	public func addInput(
		name: String,
		tag: String,
		uniqueID: MIDIIO.Endpoint.UniqueID? = nil,
		receiveHandler: MIDIIO.ReceiveHandler
	) throws -> MIDIIO.Endpoint.UniqueID {
		
		let newVD = MIDIIO.Input(
			name: name,
			uniqueID: uniqueID,
			receiveHandler: receiveHandler
		)
		
		managedInputs[tag] = newVD
		
		try newVD.create(context: self)
		
		guard let uniqueID = newVD.uniqueID else {
			throw MIDIIO.GeneralError.connectionError("Could not read virtual MIDI endpoint unique ID.")
		}
		
		return uniqueID
		
	}
	
	/// Adds a managed virtual source to the `managedOutputs` dictionary of the `Manager`.
	///
	/// The lifecycle of the MIDI port exists for as long as the `Manager` instance exists, or until `.remove(::)` is called.
	///
	/// - Parameters:
	///   - name: Name of the endpoint as seen in the system.
	///   - tag: Internal unique tag to reference the managed item in the `Manager`.
	///   - uniqueID: System-global unique identifier for the port. If nil, a random available ID will be assigned and returned if successful.
	///
	/// A note on `uniqueID`:
	///
	/// It is required that the `uniqueID` be stored persistently in a data store of your choosing, and supplied when recreating the same port. This allows other applications to identify the port and reconnect to it, as the port name is not used to identify a MIDI port since MIDI ports are allowed to have the same name, but must have unique IDs.
	///
	/// It is best practise to re-store the `uniqueID` every time this method is called, since these IDs are temporal and not registered or reserved in the system in any way. Since ID collisions are possible, a new available random ID will be obtained and returned if that happens, and that updated ID should be stored in-place of the old one in your data store.
	///
	/// Do not generate the number yourself. Rather, if no ID is yet stored, pass `nil` for `uniqueID` and allow the method to generate the new ID for you, then store it. Next time the same port is added, fetch that ID and supply it as the `uniqueID`, remembering to re-store the returned `uniqueID` once more in the event that there was a collision and a new ID has been returned.
	///
	/// - Throws: `MIDIIO.GeneralError` or `MIDIIO.OSStatusResult`.
	/// - Returns: The port's effective `uniqueID`.
	public func addOutput(
		name: String,
		tag: String,
		uniqueID: MIDIIO.Endpoint.UniqueID? = nil
	) throws -> MIDIIO.Endpoint.UniqueID {
		
		let newVS = MIDIIO.Output(
			name: name,
			uniqueID: uniqueID
		)
		
		managedOutputs[tag] = newVS
		
		try newVS.create(context: self)
		
		guard let uniqueID = newVS.uniqueID else {
			throw MIDIIO.GeneralError.connectionError("Could not read virtual MIDI endpoint unique ID.")
		}
		
		return uniqueID
		
	}
	
}

extension MIDIIO.Manager {
	
	public enum ManagedType: CaseIterable, Hashable {
		case inputConnection
		case outputConnection
		case thru
		case input
		case output
	}
	
	public enum TagSelection: Hashable {
		case all
		case withTag(String)
	}
	
	// individual methods
	
	/// Remove a managed MIDI endpoint or connection.
	public func remove(_ type: ManagedType,
					   _ tagSelection: TagSelection) {
		
		switch type {
		case .inputConnection:
			switch tagSelection {
			case .all:
				managedInputConnections.removeAll()
			case .withTag(let tag):
				managedInputConnections[tag] = nil
			}
			
		case .outputConnection:
			switch tagSelection {
			case .all:
				managedOutputConnections.removeAll()
			case .withTag(let tag):
				managedOutputConnections[tag] = nil
			}
			
		case .thru:
			switch tagSelection {
			case .all:
				managedThruConnections.removeAll()
			case .withTag(let tag):
				managedThruConnections[tag] = nil
			}

		case .input:
			switch tagSelection {
			case .all:
				managedInputs.removeAll()
			case .withTag(let tag):
				managedInputs[tag] = nil
			}
			
		case .output:
			switch tagSelection {
			case .all:
				managedOutputs.removeAll()
			case .withTag(let tag):
				managedOutputs[tag] = nil
			}
				
		}
		
	}
	
	/// Remove all managed MIDI endpoints and connections.
	///
	/// - Persistent thru connections stored in the system are unaffected.
	/// - Notification handler is unaffected.
	public func reset() {
		
		ManagedType.allCases.forEach {
			remove($0, .all)
		}
		
	}
	
}


