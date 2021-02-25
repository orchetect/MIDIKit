//
//  Manager.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIIO {
	
	/// Connection Manager for CoreMIDI.
	///
	/// One `Manager` instance stored in a global lifecycle context can manage multiple MIDI ports and connections, and is usually sufficient for all of an application's MIDI needs.
	public class Manager: NSObject {
		
		// MARK: - Properties
		
		/// MIDI Client Name.
		public internal(set) var clientName: String
		
		/// MIDI Client Reference.
		public internal(set) var clientRef = MIDIClientRef()
		
		/// Dictionary of MIDI destination connections managed by this instance.
		public internal(set) var managedInputConnections: [String : InputConnection] = [:]
		
		/// Dictionary of MIDI source connections managed by this instance.
		public internal(set) var managedOutputConnections: [String : OutputConnection] = [:]
		
		/// Dictionary of Virtual MIDI destinations managed by this instance.
		public internal(set) var managedInputs: [String : Input] = [:]
		
		/// Dictionary of Virtual MIDI sources managed by this instance.
		public internal(set) var managedOutputs: [String : Output] = [:]
		
		/// Dictionary of non-persistent MIDI thru connections managed by this instance.
		public internal(set) var managedThruConnections: [String : ThruConnection] = [:]
		
		/// Array of persistent MIDI thru connections
		/// (which survive forever, even after system reboots (?)).
		///
		/// For every persistent thru connection your app creates,
		/// they should be assigned the same persistent ID (domain).
		///
		/// - Parameter ownerID: reverse-DNS domain that was used when the connection was first made
		/// - Throws: MIDIIO.OSStatusResult
		public func unmanagedPersistentThrus(ownerID: String) throws -> [MIDIThruConnectionRef] {
			
			try MIDIIO.systemThruConnectionsPersistentEntries(matching: ownerID)
			
		}
		
		/// Source and destination endpoints in the system.
		public internal(set) var endpoints: MIDIIOEndpointsProtocol = Endpoints()
		
		/// Handler that is called when state has changed in the manager.
		public var notificationHandler: ((_ notification: Notification,
										  _ context: Manager) -> Void)? = nil
		
		
		// MARK: - Init
		
		/// Initialize the MIDI manager (and CoreMIDI client).
		/// - Parameters:
		///   - name: Name identifying this instance, used as CoreMIDI client ID
		///   - domain: A reverse-DNS domain ID (com.yourcompany.yourapp) used for persistent thru connections. If `nil`, the application's bundle ID will be used.
		public init(
			name: String,
			domain: String? = nil,
			notificationHandler: ((_ notification: Notification,
								   _ context: Manager) -> Void)? = nil
		) {
			
			self.clientName = name
			self.notificationHandler = notificationHandler
			
		}
		
		deinit {
			
			let status = MIDIClientDispose(clientRef)
			
			if status != noErr {
				let osStatusMessage = OSStatusResult(rawValue: status).description
				
				Log.debug("Error disposing of MIDI client: \(osStatusMessage)")
			}
			
		}
		
	}
	
}
