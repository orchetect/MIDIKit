//
//  Core MIDI Ref Types.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

/// MIDIKit analogue for Core MIDI's `MIDIUniqueID`.
public typealias MIDIIdentifier = Int32
    
/// MIDIKit analogue for Core MIDI's `MIDIObjectRef`.
public typealias CoreMIDIObjectRef = UInt32
    
/// MIDIKit analogue for Core MIDI's `MIDIClientRef`.
public typealias CoreMIDIClientRef = CoreMIDIObjectRef
    
/// MIDIKit analogue for Core MIDI's `MIDIDeviceRef`.
public typealias CoreMIDIDeviceRef = CoreMIDIObjectRef
    
/// MIDIKit analogue for Core MIDI's `MIDIEntityRef`.
public typealias CoreMIDIEntityRef = CoreMIDIObjectRef
    
/// MIDIKit analogue for Core MIDI's `MIDIPortRef`.
public typealias CoreMIDIPortRef = CoreMIDIObjectRef
    
/// MIDIKit analogue for Core MIDI's `MIDIEndpointRef`.
public typealias CoreMIDIEndpointRef = CoreMIDIObjectRef
    
/// MIDIKit analogue for Core MIDI's `MIDIThruConnectionRef`.
public typealias CoreMIDIThruConnectionRef = CoreMIDIObjectRef

/// MIDIKit analogue for Core MIDI's `MIDITimeStamp`.
public typealias CoreMIDITimeStamp = UInt64

/// MIDIKit analogue for Core MIDI's `OSStatus`.
public typealias CoreMIDIOSStatus = Int32
