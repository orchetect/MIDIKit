//
//  MIDIEndpointRef.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI
@_implementationOnly import OTCore

extension MIDIEndpointRef {
	
	// MARK: - Property Readers
	
	/// Shortcut to get a string value from a `MIDIEndpointRef` property value
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty...` property constant
	public func getString(forProperty: CFString) throws -> String {
		
		var val: Unmanaged<CFString>?
		let status = MIDIObjectGetStringProperty(self, forProperty, &val)
		
		guard status == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: status)
		}
		
		guard let strongVal = val else {
			throw MIDIIO.GeneralError.readError(
				"Got nil while reading MIDIEndpointRef property value \((forProperty as String).quoted)"
			)
		}
		
		// "takeRetainedValue() is the right choice here because it is the caller's responsibility to release the string. This is different from the usual Core Foundation memory management rules, but documented in the MIDI Services Reference"
		// "I think we should use takeRetainedValue(), because in this case, we have responsibility to release returned CFString. I confirmed it leaks. see: developer.apple.com/library/mac/qa/qa1374/_index.html " -- https://stackoverflow.com/a/27171498/2805570
		let returnString = String(strongVal.takeRetainedValue() as String)
		
		return returnString
		
	}
	
	/// Shortcut to get an integer value from a `MIDIEndpointRef` property value
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty...` property constant
	public func getInteger(forProperty: CFString) -> Int32 {
		
		var val: Int32 = 0
		_ = MIDIObjectGetIntegerProperty(self, forProperty, &val)
		return val
		
	}
	
	// MARK: - Property Getters
	
	/// Convenience: get user-visible endpoint name.
	/// (`kMIDIPropertyName`)
	public func getName() throws -> String {
		try getString(forProperty: kMIDIPropertyName)
	}
	
	/// Convenience: get display name - Apple-recommended user-visible name; combines device & endpoint names.
	/// (`kMIDIPropertyDisplayName`)
	public func getDisplayName() throws -> String {
		try getString(forProperty: kMIDIPropertyDisplayName)
	}
	
	/// Convenience: get manufacturer name.
	/// (`kMIDIPropertyManufacturer`)
	public func getManufacturer() throws -> String {
		try getString(forProperty: kMIDIPropertyManufacturer)
	}
	
	/// Convenience: get model name.
	/// (`kMIDIPropertyModel`)
	public func getModel() throws -> String {
		try getString(forProperty: kMIDIPropertyModel)
	}
	
	/// Convenience: get name of the driver that owns a device. Set by the owning driver, on the device; should not be touched by other clients. Property is inherited from the device by its entities and endpoints.
	/// (`kMIDIPropertyDriverOwner`)
	public func getDriverOwner() throws -> String {
		try getString(forProperty: kMIDIPropertyDriverOwner)
	}
	
	/// Convenience: get unique ID. The system assigns unique ID's to all objects.  Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
	/// (`kMIDIPropertyUniqueID`)
	public func getUniqueID() -> MIDIEndpointUniqueID {
		getInteger(forProperty: kMIDIPropertyUniqueID)
	}
	
	/// Convenience: get device ID. The entity's system-exclusive ID, in user-visible form.
	/// (`kMIDIPropertyDeviceID`)
	public func getDeviceID() -> Int32 {
		getInteger(forProperty: kMIDIPropertyDeviceID)
	}
	
	/// Convenience: True if offline (temporarily absent) or false if present.
	/// (`kMIDIPropertyOffline`)
	public func getIsOffline() -> Bool {
		getInteger(forProperty: kMIDIPropertyOffline) == 1
	}
	
	/// Convenience: False if there are external MIDI connectors, True if not.
	/// (`kMIDIPropertyIsEmbeddedEntity`)
	public func getIsEmbeddedEntity() -> Bool {
		getInteger(forProperty: kMIDIPropertyIsEmbeddedEntity)  == 1
	}
	
	/// Convenience: True if endpoint is private, hidden from other clients.
	/// (`kMIDIPropertyPrivate`)
	public func getIsPrivate() -> Bool {
		getInteger(forProperty: kMIDIPropertyPrivate) == 1
	}
	
	
	// FULL kMIDIProperty... LIST
	// (* = those implemented as methods above)
	
	//   kMIDIPropertyAdvanceScheduleTimeMuSec, int
	//   kMIDIPropertyCanRoute, int 0/1
	//   kMIDIPropertyConnectionUniqueID, int or CFDataRef
	//   kMIDIPropertyDriverDeviceEditorApp, string (path to app that can configure the device)
	//   kMIDIPropertyDriverVersion, int
	//   kMIDIPropertyImage, CFStringRef (POSIX path to icon in any common graphics file format)
	//   kMIDIPropertyIsBroadcast, int 0/1
	//   kMIDIPropertyIsDrumMachine, int 0/1
	//   kMIDIPropertyIsEffectUnit, int 0/1
	//   kMIDIPropertyIsMixer, int 0/1
	//   kMIDIPropertyIsSampler, int 0/1
	//   kMIDIPropertyMaxReceiveChannels, int 0-16
	//   kMIDIPropertyMaxSysExSpeed, int
	//   kMIDIPropertyMaxTransmitChannels, int 0/1
	//   kMIDIPropertyNameConfiguration, CFDictionary
	//   kMIDIPropertyPanDisruptsStereo, int 0/1
	//   kMIDIPropertyProtocolID, ProtocolID (macOS 11.0 only)
	//   kMIDIPropertyReceiveChannels, int (bitmap)
	//   kMIDIPropertyReceivesBankSelectMSB / kMIDIPropertyReceivesBankSelectLSB, int 0/1
	//   kMIDIPropertyReceivesClock, int 0/1
	//   kMIDIPropertyReceivesMTC, int 0/1
	//   kMIDIPropertyReceivesNotes, int 0/1
	//   kMIDIPropertyReceivesProgramChanges, int 0/1
	//   kMIDIPropertySingleRealtimeEntity, int
	//   kMIDIPropertySupportsGeneralMIDI, int 0/1
	//   kMIDIPropertySupportsMMC, int 0/1 (MIDI Machine Control support)
	//   kMIDIPropertySupportsShowControl, int 0/1 (MIDI Show Control support)
	//   kMIDIPropertyTransmitChannels, int (bitmap)
	//   kMIDIPropertyTransmitsBankSelectMSB / kMIDIPropertyTransmitsBankSelectLSB, int 0/1
	//   kMIDIPropertyTransmitsClock, int 0/1
	//   kMIDIPropertyTransmitsMTC, int 0/1
	//   kMIDIPropertyTransmitsNotes, int 0/1
	//   kMIDIPropertyTransmitsProgramChanges, int 0/1
	// * kMIDIPropertyDeviceID, int **
	// * kMIDIPropertyDisplayName, string (Apple-recommended user-visible name; combines device & endpoint names)
	// * kMIDIPropertyDriverOwner, string
	// * kMIDIPropertyIsEmbeddedEntity, int 0/1 **
	// * kMIDIPropertyManufacturer, string **
	// * kMIDIPropertyModel, string **
	// * kMIDIPropertyName, string **
	// * kMIDIPropertyOffline, int 0/1 **
	// * kMIDIPropertyPrivate, int 0/1
	// * kMIDIPropertyUniqueID, int **
	
}
