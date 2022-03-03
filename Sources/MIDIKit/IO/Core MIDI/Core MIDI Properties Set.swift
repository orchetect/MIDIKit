//
//  Core MIDI Properties Set.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import CoreMIDI

extension MIDI.IO {
    
    /// Internal:
    /// Set a string value for a `MIDIObjectRef` property key.
    ///
    /// - Parameters:
    ///   - forProperty: A `CoreMIDI.Property*` property constant
    ///   - ref: `MIDIObjectRef`
    ///   - string: New string value
    ///
    /// - Throws: `MIDI.IO.MIDIError`
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
    
    /// Internal:
    /// Set an integer value for a `MIDIObjectRef` property key.
    ///
    /// - Parameters:
    ///   - forProperty: A `CoreMIDI.Property*` property constant
    ///   - ref: `MIDIObjectRef`
    ///   - integer: New integer value
    ///
    /// - Throws: `MIDI.IO.MIDIError`
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
    
    /// Internal:
    /// Set a data value for a `MIDIObjectRef` property key.
    ///
    /// - Parameters:
    ///   - forProperty: A `CoreMIDI.Property*` property constant
    ///   - ref: `MIDIObjectRef`
    ///   - data: New data value
    ///
    /// - Throws: `MIDI.IO.MIDIError`
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
    
    /// Internal:
    /// Set a dictionary value for a `MIDIObjectRef` property key.
    ///
    /// - Parameters:
    ///   - forProperty: A `CoreMIDI.Property*` property constant
    ///   - ref: `MIDIObjectRef`
    ///   - dictionary: New dictionary value
    ///
    /// - Throws: `MIDI.IO.MIDIError`
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

extension MIDI.IO {
    
    // MARK: Identification
    
    /// Internal:
    /// Set user-visible endpoint name.
    /// (`kMIDIPropertyName`)
    ///
    /// Devices, entities, and endpoints may all have names. The standard way to display an endpoint’s name is to ask it for its name and display it only if unique. If not, prepend the device name.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and external devices.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal static func setName(of ref: MIDIObjectRef,
                                 to newValue: String) throws {
        
        try setString(forProperty: kMIDIPropertyName,
                      of: ref, to: newValue)
        
    }
    
    /// Internal:
    /// Set model name.
    /// (`kMIDIPropertyModel`)
    ///
    /// Use this property in the following scenarios:
    /// - MIDI drivers should set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal static func setModel(of ref: MIDIObjectRef,
                                  to newValue: String) throws {
        
        try setString(forProperty: kMIDIPropertyModel,
                      of: ref, to: newValue)
        
    }
    
    /// Internal:
    /// Set manufacturer name.
    /// (`kMIDIPropertyManufacturer`)
    ///
    /// Use this property in the following cases:
    /// - MIDI drivers set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal static func setManufacturer(of ref: MIDIObjectRef,
                                         to newValue: String) throws {
        
        try setString(forProperty: kMIDIPropertyManufacturer,
                      of: ref, to: newValue)
        
    }
    
    /// Internal:
    /// Set unique ID.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects. Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    internal static func setUniqueID(of ref: MIDIObjectRef,
                                     to newValue: MIDIUniqueID) throws {
        
        try setInteger(forProperty: kMIDIPropertyUniqueID,
                       of: ref, to: newValue)
        
    }
    
}
