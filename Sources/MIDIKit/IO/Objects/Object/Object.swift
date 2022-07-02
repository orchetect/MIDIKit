//
//  Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI
import SwiftUI

extension MIDI.IO {
    
    /// Enum containing strongly-typed system MIDI objects.
    ///
    /// Enum allowing switching when object type needs to be erased, such as in `MIDI.IO.Manager` Core MIDI system-generated notifications.
    public enum Object: Equatable, Hashable {
        
        case device(Device)
        case entity(Entity)
        case inputEndpoint(InputEndpoint)
        case outputEndpoint(OutputEndpoint)
        
    }
    
}

extension MIDI.IO.Object {
    
    /// Returns a MIDIKit object wrapped in a strongly-typed enum case, optionally returning the cached object from the `Manager`.
    internal init?(
        coreMIDIObjectRef: MIDIObjectRef,
        coreMIDIObjectType: MIDIObjectType,
        using cache: MIDI.IO.ObjectCache? = nil
    ) {
        
        guard coreMIDIObjectRef != 0 else { return nil }
        
        switch coreMIDIObjectType {
        case .other:
            return nil
            
        case .device, .externalDevice:
            if let cache = cache,
               let getCachedDevice = cache.devices
                .first(where: { $0.coreMIDIObjectRef == coreMIDIObjectRef })
            {
                self = .device(getCachedDevice)
            } else {
                self = .device(MIDI.IO.Device(coreMIDIObjectRef))
            }
            
        case .entity, .externalEntity:
            self = .entity(MIDI.IO.Entity(coreMIDIObjectRef))
            
        case .source, .externalSource:
            if let cache = cache,
               let getCachedEndpoint = cache.outputEndpoints
                .first(where: { $0.coreMIDIObjectRef == coreMIDIObjectRef })
            {
                self = .outputEndpoint(getCachedEndpoint)
            } else {
                self = .outputEndpoint(MIDI.IO.OutputEndpoint(coreMIDIObjectRef))
            }
            
        case .destination, .externalDestination:
            if let cache = cache,
               let getCachedEndpoint = cache.inputEndpoints
                .first(where: { $0.coreMIDIObjectRef == coreMIDIObjectRef })
            {
                self = .inputEndpoint(getCachedEndpoint)
            } else {
                self = .inputEndpoint(MIDI.IO.InputEndpoint(coreMIDIObjectRef))
            }
            
        @unknown default:
            return nil
        }
        
    }
    
    /// Returns the generic object type for the enum case.
    public var objectType: MIDI.IO.ObjectType {
        
        switch self {
        case .device: return .device
        case .entity: return .entity
        case .inputEndpoint: return .inputEndpoint
        case .outputEndpoint: return .outputEndpoint
        }
        
    }
    
}

extension MIDI.IO.Object: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .device(let device):
            return "\(device)"
            
        case .entity(let entity):
            return "\(entity)"
            
        case .inputEndpoint(let endpoint):
            return "\(endpoint)"
            
        case .outputEndpoint(let endpoint):
            return "\(endpoint)"
        }
        
    }
    
}

#endif
