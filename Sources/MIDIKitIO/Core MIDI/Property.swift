//
//  Property.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

// MARK: - Property

extension AnyMIDIIOObject {
    /// MIDI object property keys, analogous to Core MIDI property keys.
    public enum Property: CaseIterable, Hashable {
        // MARK: Identification
        case name
        case model
        case manufacturer
        case uniqueID
        case deviceID
    
        // MARK: Capabilities
        case supportsMMC
        case supportsGeneralMIDI
        case supportsShowControl
    
        // MARK: Configuration
        case nameConfigurationDictionary
        case maxSysExSpeed
        case driverDeviceEditorApp
    
        // MARK: Presentation
        case image
        case displayName
    
        // MARK: Audio
        case panDisruptsStereo
    
        // MARK: Protocols
        case protocolID
    
        // MARK: Timing
        case transmitsMTC
        case receivesMTC
        case transmitsClock
        case receivesClock
        case advanceScheduleTimeMuSec
    
        // MARK: Roles
        case isMixer
        case isSampler
        case isEffectUnit
        case isDrumMachine
    
        // MARK: Status
        case isOffline
        case isPrivate
    
        // MARK: Drivers
        case driverOwner
        case driverVersion
    
        // MARK: Connections
        case canRoute
        case isBroadcast
        case connectionUniqueID
        case isEmbeddedEntity
        case singleRealtimeEntity
    
        // MARK: Channels
        case receiveChannels
        case transmitChannels
        case maxReceiveChannels
        case maxTransmitChannels
    
        // MARK: Banks
        case receivesBankSelectLSB
        case receivesBankSelectMSB
        case transmitsBankSelectLSB
        case transmitsBankSelectMSB
    
        // MARK: Notes
        case receivesNotes
        case transmitsNotes
    
        // MARK: Program Changes
        case receivesProgramChanges
        case transmitsProgramChanges
    }
}

// MARK: - Property Keys

extension AnyMIDIIOObject.Property {
    /// Returns the Core MIDI `CFString` property name constant.
    public var coreMIDICFString: CFString {
        switch self {
        // MARK: Identification
        case .name: return kMIDIPropertyName
        case .model: return kMIDIPropertyModel
        case .manufacturer: return kMIDIPropertyManufacturer
        case .uniqueID: return kMIDIPropertyUniqueID
        case .deviceID: return kMIDIPropertyDeviceID
    
        // MARK: Capabilities
        case .supportsMMC: return kMIDIPropertySupportsMMC
        case .supportsGeneralMIDI: return kMIDIPropertySupportsGeneralMIDI
        case .supportsShowControl: return kMIDIPropertySupportsShowControl
    
        // MARK: Configuration
        case .nameConfigurationDictionary:
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                return kMIDIPropertyNameConfigurationDictionary
            } else {
                return "" as CFString
            }
    
        case .maxSysExSpeed: return kMIDIPropertyMaxSysExSpeed
        case .driverDeviceEditorApp: return kMIDIPropertyDriverDeviceEditorApp
    
        // MARK: Presentation
        case .image: return kMIDIPropertyImage
        case .displayName: return kMIDIPropertyDisplayName
    
        // MARK: Audio
        case .panDisruptsStereo: return kMIDIPropertyPanDisruptsStereo
    
        // MARK: Protocols
        case .protocolID:
            if #available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *) {
                return kMIDIPropertyProtocolID
            } else {
                return "" as CFString
            }
    
        // MARK: Timing
        case .transmitsMTC: return kMIDIPropertyTransmitsMTC
        case .receivesMTC: return kMIDIPropertyReceivesMTC
        case .transmitsClock: return kMIDIPropertyTransmitsClock
        case .receivesClock: return kMIDIPropertyReceivesClock
        case .advanceScheduleTimeMuSec: return kMIDIPropertyAdvanceScheduleTimeMuSec
    
        // MARK: Roles
        case .isMixer: return kMIDIPropertyIsMixer
        case .isSampler: return kMIDIPropertyIsSampler
        case .isEffectUnit: return kMIDIPropertyIsEffectUnit
        case .isDrumMachine: return kMIDIPropertyIsDrumMachine
    
        // MARK: Status
        case .isOffline: return kMIDIPropertyOffline
        case .isPrivate: return kMIDIPropertyPrivate
    
        // MARK: Drivers
        case .driverOwner: return kMIDIPropertyDriverOwner
        case .driverVersion: return kMIDIPropertyDriverVersion
    
        // MARK: Connections
        case .canRoute: return kMIDIPropertyCanRoute
        case .isBroadcast: return kMIDIPropertyIsBroadcast
        case .connectionUniqueID: return kMIDIPropertyConnectionUniqueID
        case .isEmbeddedEntity: return kMIDIPropertyIsEmbeddedEntity
        case .singleRealtimeEntity: return kMIDIPropertySingleRealtimeEntity
    
        // MARK: Channels
        case .receiveChannels: return kMIDIPropertyReceiveChannels
        case .transmitChannels: return kMIDIPropertyTransmitChannels
        case .maxReceiveChannels: return kMIDIPropertyMaxReceiveChannels
        case .maxTransmitChannels: return kMIDIPropertyMaxTransmitChannels
    
        // MARK: Banks
        case .receivesBankSelectLSB: return  kMIDIPropertyReceivesBankSelectLSB
        case .receivesBankSelectMSB: return  kMIDIPropertyReceivesBankSelectMSB
        case .transmitsBankSelectLSB: return kMIDIPropertyTransmitsBankSelectLSB
        case .transmitsBankSelectMSB: return kMIDIPropertyTransmitsBankSelectMSB
    
        // MARK: Notes
        case .receivesNotes: return kMIDIPropertyReceivesNotes
        case .transmitsNotes: return kMIDIPropertyTransmitsNotes
    
        // MARK: Program Changes
        case .receivesProgramChanges: return kMIDIPropertyReceivesProgramChanges
        case .transmitsProgramChanges: return kMIDIPropertyTransmitsProgramChanges
        }
    }
    
    /// Returns the Core MIDI `CFString` property name constant.
    public init?(_ coreMIDICFString: CFString) {
        if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *),
           coreMIDICFString == kMIDIPropertyNameConfigurationDictionary
        {
            self = .nameConfigurationDictionary
            return
        }
    
        if #available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *),
           coreMIDICFString == kMIDIPropertyProtocolID
        {
            self = .protocolID
            return
        }
    
        switch coreMIDICFString {
        // MARK: Identification
        case kMIDIPropertyName: self = .name
        case kMIDIPropertyModel: self = .model
        case kMIDIPropertyManufacturer: self = .manufacturer
        case kMIDIPropertyUniqueID: self = .uniqueID
        case kMIDIPropertyDeviceID: self = .deviceID
    
        // MARK: Capabilities
        case kMIDIPropertySupportsMMC: self = .supportsMMC
        case kMIDIPropertySupportsGeneralMIDI: self = .supportsGeneralMIDI
        case kMIDIPropertySupportsShowControl: self = .supportsShowControl
    
        // MARK: Configuration
        // case kMIDIPropertyNameConfigurationDictionary: self = .nameConfigurationDictionary
        //   --> has OS requirements, handled separately
        case kMIDIPropertyMaxSysExSpeed: self = .maxSysExSpeed
        case kMIDIPropertyDriverDeviceEditorApp: self = .driverDeviceEditorApp
    
        // MARK: Presentation
        case kMIDIPropertyImage: self = .image
        case kMIDIPropertyDisplayName: self = .displayName
    
        // MARK: Audio
        case kMIDIPropertyPanDisruptsStereo: self = .panDisruptsStereo
    
        // MARK: Protocols
        // case kMIDIPropertyProtocolID: self = .protocolID
        //    --> has OS requirements, handled separately
    
        // MARK: Timing
        case kMIDIPropertyTransmitsMTC: self = .transmitsMTC
        case kMIDIPropertyReceivesMTC: self = .receivesMTC
        case kMIDIPropertyTransmitsClock: self = .transmitsClock
        case kMIDIPropertyReceivesClock: self = .receivesClock
        case kMIDIPropertyAdvanceScheduleTimeMuSec: self = .advanceScheduleTimeMuSec
    
        // MARK: Roles
        case kMIDIPropertyIsMixer: self = .isMixer
        case kMIDIPropertyIsSampler: self = .isSampler
        case kMIDIPropertyIsEffectUnit: self = .isEffectUnit
        case kMIDIPropertyIsDrumMachine: self = .isDrumMachine
    
        // MARK: Status
        case kMIDIPropertyOffline: self = .isOffline
        case kMIDIPropertyPrivate: self = .isPrivate
    
        // MARK: Drivers
        case kMIDIPropertyDriverOwner: self = .driverOwner
        case kMIDIPropertyDriverVersion: self = .driverVersion
    
        // MARK: Connections
        case kMIDIPropertyCanRoute: self = .canRoute
        case kMIDIPropertyIsBroadcast: self = .isBroadcast
        case kMIDIPropertyConnectionUniqueID: self = .connectionUniqueID
        case kMIDIPropertyIsEmbeddedEntity: self = .isEmbeddedEntity
        case kMIDIPropertySingleRealtimeEntity: self = .singleRealtimeEntity
    
        // MARK: Channels
        case kMIDIPropertyReceiveChannels: self = .receiveChannels
        case kMIDIPropertyTransmitChannels: self = .transmitChannels
        case kMIDIPropertyMaxReceiveChannels: self = .maxReceiveChannels
        case kMIDIPropertyMaxTransmitChannels: self = .maxTransmitChannels
    
        // MARK: Banks
        case kMIDIPropertyReceivesBankSelectLSB: self = .receivesBankSelectLSB
        case kMIDIPropertyReceivesBankSelectMSB: self = .receivesBankSelectMSB
        case kMIDIPropertyTransmitsBankSelectLSB: self = .transmitsBankSelectLSB
        case kMIDIPropertyTransmitsBankSelectMSB: self = .transmitsBankSelectMSB
    
        // MARK: Notes
        case kMIDIPropertyReceivesNotes: self = .receivesNotes
        case kMIDIPropertyTransmitsNotes: self = .transmitsNotes
    
        // MARK: Program Changes
        case kMIDIPropertyReceivesProgramChanges: self = .receivesProgramChanges
        case kMIDIPropertyTransmitsProgramChanges: self = .transmitsProgramChanges
    
        default:
            return nil
        }
    }
}

// MARK: - Relevant Objects

extension AnyMIDIIOObject.Property {
    /// Internal: returns relevant `MIDIIOObjectType` object types associated with the property.
    internal var relevantObjects: Set<MIDIIOObjectType> {
        switch self {
        // MARK: Identification
        case .name: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .model: return [.device, .inputEndpoint, .outputEndpoint]
        case .manufacturer: return [.device, .inputEndpoint, .outputEndpoint]
        case .uniqueID: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .deviceID: return [.device, .entity]
    
        // MARK: Capabilities
        case .supportsMMC: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .supportsGeneralMIDI: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .supportsShowControl: return [.device, .entity, .inputEndpoint, .outputEndpoint]
    
        // MARK: Configuration
        case .nameConfigurationDictionary: return [.device]
        case .maxSysExSpeed: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .driverDeviceEditorApp: return [.device]
    
        // MARK: Presentation
        case .image: return [.device]
        case .displayName: return [.inputEndpoint, .outputEndpoint]
    
        // MARK: Audio
        case .panDisruptsStereo: return [.device, .entity]
    
        // MARK: Protocols
        case .protocolID: return [.inputEndpoint, .outputEndpoint]
    
        // MARK: Timing
        case .transmitsMTC: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .receivesMTC: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .transmitsClock: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .receivesClock: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .advanceScheduleTimeMuSec: return [
                .device,
                .entity
            ] // + .inputEndpoint, .outputEndpoint?
    
        // MARK: Roles
        case .isMixer: return [.device, .entity]
        case .isSampler: return [.device, .entity]
        case .isEffectUnit: return [.device, .entity]
        case .isDrumMachine: return [.device, .entity]
    
        // MARK: Status
        case .isOffline: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .isPrivate: return [.inputEndpoint, .outputEndpoint]
    
        // MARK: Drivers
        case .driverOwner: return [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .driverVersion: return [.device, .entity, .inputEndpoint, .outputEndpoint]
    
        // MARK: Connections
        case .canRoute: return [.device, .entity]
        case .isBroadcast: return [.inputEndpoint, .outputEndpoint]
        case .connectionUniqueID: return [.inputEndpoint, .outputEndpoint] // ?
        case .isEmbeddedEntity: return [.entity, .inputEndpoint, .outputEndpoint]
        case .singleRealtimeEntity: return [.device, .inputEndpoint, .outputEndpoint] // ?
    
        // MARK: Channels
        case .receiveChannels: return [.device, .entity, .inputEndpoint, .outputEndpoint] // ?
        case .transmitChannels: return [.device, .entity, .inputEndpoint, .outputEndpoint] // ?
        case .maxReceiveChannels: return [.device]
        case .maxTransmitChannels: return [.device]
    
        // MARK: Banks
        case .receivesBankSelectLSB: return [.device, .entity]
        case .receivesBankSelectMSB: return [.device, .entity]
        case .transmitsBankSelectLSB: return [.device, .entity]
        case .transmitsBankSelectMSB: return [.device, .entity]
    
        // MARK: Notes
        case .receivesNotes: return [.device, .entity]
        case .transmitsNotes: return [.device, .entity]
    
        // MARK: Program Changes
        case .receivesProgramChanges: return [.device, .entity]
        case .transmitsProgramChanges: return [.device, .entity]
        }
    }
}

extension MIDIIOObjectType {
    /// Internal: returns relevant `MIDIIOObject.Property`s associated with the object type.
    internal var relevantProperties: [AnyMIDIIOObject.Property] {
        AnyMIDIIOObject.Property.allCases.filter {
            $0.relevantObjects.contains(self)
        }
    }
}

#endif
