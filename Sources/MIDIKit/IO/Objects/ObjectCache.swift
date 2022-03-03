//
//  ObjectCache.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.IO {
    
    /// A temporary storage object for internal MIDI objects.
    internal struct ObjectCache {
        
        var devices: [MIDI.IO.Device]
        var inputEndpoints: [MIDI.IO.InputEndpoint]
        var outputEndpoints: [MIDI.IO.OutputEndpoint]
        
        init(from manager: MIDI.IO.Manager) {
            
            devices = manager.devices.devices
            inputEndpoints = manager.endpoints.inputs
            outputEndpoints = manager.endpoints.outputs
            
        }
        
    }
    
}
