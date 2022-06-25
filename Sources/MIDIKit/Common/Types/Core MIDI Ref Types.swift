//
//  Core MIDI Ref Types.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.IO {
    
    /// MIDIKit analogue for Core MIDI's `MIDIUniqueID`.
    public typealias UniqueID = Int32
    
    /// MIDIKit analogue for Core MIDI's `MIDIObjectRef`.
    public typealias ObjectRef = UInt32
    
    /// MIDIKit analogue for Core MIDI's `MIDIClientRef`.
    public typealias ClientRef = ObjectRef
    
    /// MIDIKit analogue for Core MIDI's `MIDIDeviceRef`.
    public typealias DeviceRef = ObjectRef
    
    /// MIDIKit analogue for Core MIDI's `MIDIEntityRef`.
    public typealias EntityRef = ObjectRef
    
    /// MIDIKit analogue for Core MIDI's `MIDIPortRef`.
    public typealias PortRef = ObjectRef
    
    /// MIDIKit analogue for Core MIDI's `MIDIEndpointRef`.
    public typealias EndpointRef = ObjectRef
    
    /// MIDIKit analogue for Core MIDI's `MIDIThruConnectionRef`.
    public typealias ThruConnectionRef = ObjectRef
    
}

extension MIDI.IO {
    
    /// MIDIKit analogue for Core MIDI's `MIDITimeStamp`.
    public typealias TimeStamp = UInt64
    
}

extension MIDI.IO {
    
    /// MIDIKit analogue for Core MIDI's `OSStatus`.
    public typealias CoreMIDIOSStatus = Int32
    
}
