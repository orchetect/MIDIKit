//
//  MIDIIOManager.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI
@_implementationOnly import OTCore

/// CoreMIDI abstraction library MIDI client and ports manager.
///
/// One `MIDIIOManager` instance stored in a global lifecycle context can manage multiple MIDI ports and connections, and is usually sufficient for all of an application's MIDI needs.
public class MIDIIOManager {
	
	// MARK: - Properties
	
	/// MIDI Client Name
	public internal(set) var clientName: String
	
	/// MIDI Client Reference
	public internal(set) var clientRef = MIDIClientRef()
	
	/// Dictionary of Virtual MIDI sources
	public internal(set) var virtualSources: [String : VirtualSource] = [:]
	
	/// Dictionary of Virtual MIDI destinations
	public internal(set) var virtualDestinations: [String : VirtualDestination] = [:]
	
	/// Dictionary of MIDI source connections
	public internal(set) var connectedSources: [String : ConnectedSource] = [:]
	
	/// Dictionary of MIDI destination connections
	public internal(set) var connectedDestinations: [String : ConnectedDestination] = [:]
	
	/// Dictionary of non-persistent MIDI thru connections
	/// (which expire when the app quits)
	public internal(set) var connectedThrusNonPersistent: [String : ConnectedThru] = [:]
	
	/// Array of persistent MIDI thru connections
	/// (which survive forever, even after system reboots (?)).
	/// For every persistent thru connection your app creates,
	/// they should be assigned the same persistent ID (domain).
	public var connectedThrusPersistent: [MIDIThruConnectionRef] {
		
		(try?
			CoreMIDIHelpers
			.connectedThrusPersistentEntries(
				byPersistentOwnerID: persistentDomain
			)
		)
		?? []
		
	}
	
	/// Persistent ID for MIDI thru connections
	public var persistentDomain: String
	
	
	// MARK: - Init
	
	/// Initialize the MIDI client
	/// - Parameters:
	///   - name: Name identifying this instance, used as CoreMIDI client ID
	///   - domain: A reverse-DNS domain ID (com.yourcompany.yourapp) used for persistent thru connections. If `nil`, the application's bundle ID will be used.
	public init(name: String, domain: String? = nil) {
		
		self.clientName = name
		self.persistentDomain = domain ?? Globals.bundle.bundleID
		
	}
	
	deinit {
		
		let status = MIDIClientDispose(clientRef)
		
		if status != noErr {
			let osStatusMessage = OSStatusResult(rawValue: status).description
			
			Log.debug("Error disposing of MIDI client: \(osStatusMessage)")
		}
		
	}
	
}
