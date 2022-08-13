//
//  MIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI
import SwiftUI

/// Enum containing strongly-typed system MIDI objects.
///
/// Enum allowing switching when object type needs to be erased, such as in `MIDIManager` Core MIDI system-generated notifications.
public enum MIDIIOObject: Equatable, Hashable {
    case device(MIDIDevice)
    case entity(MIDIEntity)
    case inputEndpoint(MIDIInputEndpoint)
    case outputEndpoint(MIDIOutputEndpoint)
}

extension MIDIIOObject {
    /// Returns a MIDIKit object wrapped in a strongly-typed enum case, optionally returning the cached object from the `Manager`.
    internal init?(
        coreMIDIObjectRef: MIDIObjectRef,
        coreMIDIObjectType: MIDIObjectType,
        using cache: MIDIIOObjectCache? = nil
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
                self = .device(MIDIDevice(coreMIDIObjectRef))
            }
            
        case .entity, .externalEntity:
            self = .entity(MIDIEntity(coreMIDIObjectRef))
            
        case .source, .externalSource:
            if let cache = cache,
               let getCachedEndpoint = cache.outputEndpoints
                   .first(where: { $0.coreMIDIObjectRef == coreMIDIObjectRef })
            {
                self = .outputEndpoint(getCachedEndpoint)
            } else {
                self = .outputEndpoint(MIDIOutputEndpoint(coreMIDIObjectRef))
            }
            
        case .destination, .externalDestination:
            if let cache = cache,
               let getCachedEndpoint = cache.inputEndpoints
                   .first(where: { $0.coreMIDIObjectRef == coreMIDIObjectRef })
            {
                self = .inputEndpoint(getCachedEndpoint)
            } else {
                self = .inputEndpoint(MIDIInputEndpoint(coreMIDIObjectRef))
            }
            
        @unknown default:
            return nil
        }
    }
    
    /// Returns the generic object type for the enum case.
    public var objectType: MIDIIOObjectType {
        switch self {
        case .device: return .device
        case .entity: return .entity
        case .inputEndpoint: return .inputEndpoint
        case .outputEndpoint: return .outputEndpoint
        }
    }
}

extension MIDIIOObject: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .device(device):
            return "\(device)"
            
        case let .entity(entity):
            return "\(entity)"
            
        case let .inputEndpoint(endpoint):
            return "\(endpoint)"
            
        case let .outputEndpoint(endpoint):
            return "\(endpoint)"
        }
    }
}

#endif
