//
//  CoreMIDI Properties Set.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-28.
//

import CoreMIDI

extension MIDIIO {
	
	/// Set a string value for a `MIDIObjectRef` property key.
	///
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty*` property constant
	/// - parameter ref: `MIDIObjectRef`
	/// - parameter string: New string value
	/// - throws: `MIDIIO.MIDIError`
	internal static func setString(forProperty: CFString,
								   of ref: MIDIObjectRef,
								   to string: String) throws {
		
		try MIDIObjectSetStringProperty(
			ref,
			forProperty,
			string as CFString
		)
		.throwIfOSStatusErr()
		
	}
	
	/// Set an integer value for a `MIDIObjectRef` property key.
	///
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty*` property constant
	/// - parameter ref: `MIDIObjectRef`
	/// - parameter integer: New integer value
	/// - throws: `MIDIIO.MIDIError`
	internal static func setInteger(forProperty: CFString,
									of ref: MIDIObjectRef,
									to integer: Int32) throws {
		
		try MIDIObjectSetIntegerProperty(
			ref,
			forProperty,
			integer
		)
		.throwIfOSStatusErr()
		
	}
	
	/// Set a data value for a `MIDIObjectRef` property key.
	///
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty*` property constant
	/// - parameter ref: `MIDIObjectRef`
	/// - parameter data: New data value
	/// - throws: `MIDIIO.MIDIError`
	internal static func setData(forProperty: CFString,
								 of ref: MIDIObjectRef,
								 to data: CFData) throws {
		
		try MIDIObjectSetDataProperty(
			ref,
			forProperty,
			data
		)
		.throwIfOSStatusErr()
		
	}
	
	/// Set a dictionary value for a `MIDIObjectRef` property key.
	///
	/// - parameter forProperty: a `CoreMIDI.kMIDIProperty*` property constant
	/// - parameter ref: `MIDIObjectRef`
	/// - parameter dictionary: New dictionary value
	/// - throws: `MIDIIO.MIDIError`
	internal static func setDictionary(forProperty: CFString,
									   of ref: MIDIObjectRef,
									   to dictionary: CFDictionary) throws {
		
		try MIDIObjectSetDictionaryProperty(
			ref,
			forProperty,
			dictionary
		)
		.throwIfOSStatusErr()
		
	}
	
}

// MARK: - Property Setters

extension MIDIIO {
	
	// MARK: Identification
	
	/// Set user-visible endpoint name.
	/// (`kMIDIPropertyName`)
	///
	/// Devices, entities, and endpoints may all have names. The standard way to display an endpoint’s name is to ask it for its name and display it only if unique. If not, prepend the device name.
	///
	/// A studio setup editor may allow the user to set the names of both driver-owned and external devices.
	///
	/// - throws: `MIDIIO.MIDIError`
	internal static func setName(of ref: MIDIObjectRef,
								 to newValue: String) throws {
		
		try setString(forProperty: kMIDIPropertyName,
					  of: ref, to: newValue)
		
	}
	
	/// Set model name.
	/// (`kMIDIPropertyModel`)
	///
	/// Use this property in the following scenarios:
	/// - MIDI drivers should set this property on their devices.
	/// - Studio setup editors may allow the user to set this property on external devices.
	/// - Creators of virtual endpoints may set this property on their endpoints.
	///
	/// - throws: `MIDIIO.MIDIError`
	internal static func setModel(of ref: MIDIObjectRef,
								  to newValue: String) throws {
		
		try setString(forProperty: kMIDIPropertyModel,
					  of: ref, to: newValue)
		
	}
	
	/// Set manufacturer name.
	/// (`kMIDIPropertyManufacturer`)
	///
	/// Use this property in the following cases:
	/// - MIDI drivers set this property on their devices.
	/// - Studio setup editors may allow the user to set this property on external devices.
	/// - Creators of virtual endpoints may set this property on their endpoints.
	///
	/// - throws: `MIDIIO.MIDIError`
	internal static func setManufacturer(of ref: MIDIObjectRef,
										 to newValue: String) throws {
		
		try setString(forProperty: kMIDIPropertyManufacturer,
					  of: ref, to: newValue)
		
	}
	
	/// Set unique ID.
	/// (`kMIDIPropertyUniqueID`)
	///
	/// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
	internal static func setUniqueID(of ref: MIDIObjectRef,
									 to newValue: MIDIIO.ObjectRef.UniqueID) throws {
		
		try setInteger(forProperty: kMIDIPropertyUniqueID,
					   of: ref, to: newValue)
		
	}
	
}
