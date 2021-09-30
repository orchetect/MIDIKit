//
//  Device.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Device

extension MIDI.IO {
    
    /// A MIDI device, wrapping a Core MIDI `MIDIDeviceRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read `Device` arrays and individual `Device` properties from `MIDI.IO.Manager.devices` ad-hoc when they are needed.
    public struct Device: _MIDIIOObjectProtocol {
        
        public let objectType: MIDI.IO.ObjectType = .device
        
        // MARK: CoreMIDI ref
        
        internal let coreMIDIObjectRef: MIDI.IO.CoreMIDIDeviceRef
        
        // MARK: Init
        
        internal init(_ ref: MIDI.IO.CoreMIDIDeviceRef) {
            
            assert(ref != MIDI.IO.CoreMIDIDeviceRef())
            
            self.coreMIDIObjectRef = ref
            update()
            
        }
        
        // MARK: - Properties (Cached)
        
        /// User-visible endpoint name.
        /// (`kMIDIPropertyName`)
        public internal(set) var name: String = ""
        
        /// System-global Unique ID.
        /// (`kMIDIPropertyUniqueID`)
        public internal(set) var uniqueID: UniqueID = 0
        
        /// Update the cached properties
        internal mutating func update() {
            
            self.name = (try? MIDI.IO.getName(of: coreMIDIObjectRef)) ?? ""
            self.uniqueID = .init(MIDI.IO.getUniqueID(of: coreMIDIObjectRef))
            
        }
        
    }
}

extension MIDI.IO.Device: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.Device: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension MIDI.IO.Device: Identifiable {
    // default implementation provided by MIDIIOObjectProtocol
}

extension MIDI.IO.Device {
    
    /// List of entities within the device.
    public var entities: [MIDI.IO.Entity] {
        
        MIDI.IO.getSystemEntities(for: coreMIDIObjectRef)
        
    }
    
}

extension MIDI.IO.Device {
    
    /// Returns `true` if the object exists in the system by querying Core MIDI.
    public var exists: Bool {
        
        MIDI.IO.getSystemDevices
            .contains(where: { $0.uniqueID == self.uniqueID })
        
    }
    
}

extension MIDI.IO.Device: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        "Device(name: \(name.quoted), uniqueID: \(uniqueID), exists: \(exists)"
    }
    
}

