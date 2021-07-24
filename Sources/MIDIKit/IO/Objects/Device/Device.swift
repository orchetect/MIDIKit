//
//  Device.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

// MARK: - Device

extension MIDI.IO {
    
    /// A MIDI device, wrapping `MIDIDeviceRef`.
    ///
    /// Although this is a value-type struct, do not store or cache it as it will not remain updated.
    ///
    /// Instead, read `Device` arrays and individual `Device` properties from `MIDI.IO.Manager.devices` ad-hoc when they are needed.
    public struct Device: Object {
        
        public static let objectType: MIDI.IO.ObjectType = .device
        
        // MARK: CoreMIDI ref
        
        public let ref: MIDIDeviceRef
        
        // MARK: Identifiable
        
        public var id = UUID()
        
        // MARK: Init
        
        internal init(_ ref: MIDIDeviceRef) {
            
            assert(ref != MIDIDeviceRef())
            
            self.ref = ref
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
            
            self.name = (try? MIDI.IO.getName(of: ref)) ?? ""
            self.uniqueID = MIDI.IO.getUniqueID(of: ref)
            
        }
        
    }
}

extension MIDI.IO.Device {
    
    /// List of entities within the device.
    public var entities: [MIDI.IO.Entity] {
        
        MIDI.IO.getSystemEntities(for: ref)
        
    }
    
}

extension MIDI.IO.Device {
    
    /// Returns `true` if the object exists in the system by querying CoreMIDI.
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
