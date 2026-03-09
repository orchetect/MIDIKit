//
//  MIDIIOObjectProperty Property.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

// MARK: - Property

/// MIDI object property keys, analogous to Core MIDI property keys.
public enum MIDIIOObjectProperty {
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

extension MIDIIOObjectProperty: Equatable { }

extension MIDIIOObjectProperty: Hashable { }

extension MIDIIOObjectProperty: CaseIterable { }

extension MIDIIOObjectProperty: Sendable { }

// MARK: - Name

extension MIDIIOObjectProperty {
    /// Returns the human-readable name of the property, suitable for display in UI or debugging.
    public var name: String {
        switch self {
        // MARK: Identification
        case .name:
            "Name"
            
        case .model:
            "Model"
            
        case .manufacturer:
            "Manufacturer"
            
        case .uniqueID:
            "Unique ID"
            
        case .deviceID:
            "Device ID"
            
        // MARK: Capabilities
        case .supportsMMC:
            "Supports MMC"
            
        case .supportsGeneralMIDI:
            "Supports General MIDI"
            
        case .supportsShowControl:
            "Supports Show Control"
            
        // MARK: Configuration
        case .nameConfigurationDictionary:
            "Name Configuration Dictionary"
            
        case .maxSysExSpeed:
            "Max SysEx Speed"
            
        case .driverDeviceEditorApp:
            "Driver Device Editor App"
            
        // MARK: Presentation
        case .image:
            "Image (File URL)"
            
        case .displayName:
            "Display Name"
            
        // MARK: Audio
        case .panDisruptsStereo:
            "Pan Disrupts Stereo"
            
        // MARK: Protocols
        case .protocolID:
            "Protocol ID"
            
        // MARK: Timing
        case .transmitsMTC:
            "Transmits MTC"
            
        case .receivesMTC:
            "Receives MTC"
            
        case .transmitsClock:
            "Transmits Clock"
            
        case .receivesClock:
            "Receives Clock"
            
        case .advanceScheduleTimeMuSec:
            "Advance Schedule Time (μs)"
            
        // MARK: Roles
        case .isMixer:
            "Is Mixer"
            
        case .isSampler:
            "Is Sampler"
            
        case .isEffectUnit:
            "Is Effect Unit"
            
        case .isDrumMachine:
            "Is Drum Machine"
            
        // MARK: Status
        case .isOffline:
            "Is Offline"
            
        case .isPrivate:
            "Is Private"
            
        // MARK: Drivers
        case .driverOwner:
            "Driver Owner"
            
        case .driverVersion:
            "Driver Version"
            
        // MARK: Connections
        case .canRoute:
            "Can Route"
            
        case .isBroadcast:
            "Is Broadcast"
            
        case .connectionUniqueID:
            "Connection Unique ID"
            
        case .isEmbeddedEntity:
            "Is Embedded Entity"
            
        case .singleRealtimeEntity:
            "Single Realtime Entity"
            
        // MARK: Channels
        case .receiveChannels:
            "Receive Channels"
            
        case .transmitChannels:
            "Transmit Channels"
            
        case .maxReceiveChannels:
            "Max Receive Channels"
            
        case .maxTransmitChannels:
            "Max Transmit Channels"
            
        // MARK: Banks
        case .receivesBankSelectLSB:
            "Receives Bank Select LSB"
            
        case .receivesBankSelectMSB:
            "Receives Bank Select MSB"
            
        case .transmitsBankSelectLSB:
            "Transmits Bank Select LSB"
            
        case .transmitsBankSelectMSB:
            "Transmits Bank Select MSB"
            
        // MARK: Notes
        case .receivesNotes:
            "Receives Notes"
            
        case .transmitsNotes:
            "Transmits Notes"
            
        // MARK: Program Changes
        case .receivesProgramChanges:
            "Receives Program Changes"
            
        case .transmitsProgramChanges:
            "Transmits Program Changes"
        }
    }
}

// MARK: - Property Keys

extension MIDIIOObjectProperty {
    /// Returns the Core MIDI `CFString` property name constant.
    public var coreMIDICFString: CFString {
        switch self {
        // MARK: Identification
        case .name: kMIDIPropertyName
        case .model: kMIDIPropertyModel
        case .manufacturer: kMIDIPropertyManufacturer
        case .uniqueID: kMIDIPropertyUniqueID
        case .deviceID: kMIDIPropertyDeviceID
        // MARK: Capabilities
        case .supportsMMC: kMIDIPropertySupportsMMC
        case .supportsGeneralMIDI: kMIDIPropertySupportsGeneralMIDI
        case .supportsShowControl: kMIDIPropertySupportsShowControl
        // MARK: Configuration
        case .nameConfigurationDictionary:
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                kMIDIPropertyNameConfigurationDictionary
            } else {
                "" as CFString
            }
        case .maxSysExSpeed: kMIDIPropertyMaxSysExSpeed
        case .driverDeviceEditorApp: kMIDIPropertyDriverDeviceEditorApp
        // MARK: Presentation
        case .image: kMIDIPropertyImage
        case .displayName: kMIDIPropertyDisplayName
        // MARK: Audio
        case .panDisruptsStereo: kMIDIPropertyPanDisruptsStereo
        // MARK: Protocols
        case .protocolID:
            if #available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *) {
                kMIDIPropertyProtocolID
            } else {
                "" as CFString
            }
        // MARK: Timing
        case .transmitsMTC: kMIDIPropertyTransmitsMTC
        case .receivesMTC: kMIDIPropertyReceivesMTC
        case .transmitsClock: kMIDIPropertyTransmitsClock
        case .receivesClock: kMIDIPropertyReceivesClock
        case .advanceScheduleTimeMuSec: kMIDIPropertyAdvanceScheduleTimeMuSec
        // MARK: Roles
        case .isMixer: kMIDIPropertyIsMixer
        case .isSampler: kMIDIPropertyIsSampler
        case .isEffectUnit: kMIDIPropertyIsEffectUnit
        case .isDrumMachine: kMIDIPropertyIsDrumMachine
        // MARK: Status
        case .isOffline: kMIDIPropertyOffline
        case .isPrivate: kMIDIPropertyPrivate
        // MARK: Drivers
        case .driverOwner: kMIDIPropertyDriverOwner
        case .driverVersion: kMIDIPropertyDriverVersion
        // MARK: Connections
        case .canRoute: kMIDIPropertyCanRoute
        case .isBroadcast: kMIDIPropertyIsBroadcast
        case .connectionUniqueID: kMIDIPropertyConnectionUniqueID
        case .isEmbeddedEntity: kMIDIPropertyIsEmbeddedEntity
        case .singleRealtimeEntity: kMIDIPropertySingleRealtimeEntity
        // MARK: Channels
        case .receiveChannels: kMIDIPropertyReceiveChannels
        case .transmitChannels: kMIDIPropertyTransmitChannels
        case .maxReceiveChannels: kMIDIPropertyMaxReceiveChannels
        case .maxTransmitChannels: kMIDIPropertyMaxTransmitChannels
        // MARK: Banks
        case .receivesBankSelectLSB: kMIDIPropertyReceivesBankSelectLSB
        case .receivesBankSelectMSB: kMIDIPropertyReceivesBankSelectMSB
        case .transmitsBankSelectLSB: kMIDIPropertyTransmitsBankSelectLSB
        case .transmitsBankSelectMSB: kMIDIPropertyTransmitsBankSelectMSB
        // MARK: Notes
        case .receivesNotes: kMIDIPropertyReceivesNotes
        case .transmitsNotes: kMIDIPropertyTransmitsNotes
        // MARK: Program Changes
        case .receivesProgramChanges: kMIDIPropertyReceivesProgramChanges
        case .transmitsProgramChanges: kMIDIPropertyTransmitsProgramChanges
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

extension MIDIIOObjectProperty {
    /// Internal: returns relevant `MIDIIOObjectType` object types associated with the property.
    var relevantObjects: Set<MIDIIOObjectType> {
        switch self {
        // MARK: Identification
        case .name: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .model: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .manufacturer: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .uniqueID: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .deviceID: [.device, .entity]
        // MARK: Capabilities
        case .supportsMMC: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .supportsGeneralMIDI: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .supportsShowControl: [.device, .entity, .inputEndpoint, .outputEndpoint]
        // MARK: Configuration
        case .nameConfigurationDictionary: [.device]
        case .maxSysExSpeed: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .driverDeviceEditorApp: [.device]
        // MARK: Presentation
        case .image: [.device]
        case .displayName: [.inputEndpoint, .outputEndpoint]
        // MARK: Audio
        case .panDisruptsStereo: [.device, .entity]
        // MARK: Protocols
        case .protocolID: [.inputEndpoint, .outputEndpoint]
        // MARK: Timing
        case .transmitsMTC: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .receivesMTC: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .transmitsClock: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .receivesClock: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .advanceScheduleTimeMuSec: [
                .device,
                .entity
            ] // + .inputEndpoint, .outputEndpoint?
        // MARK: Roles
        case .isMixer: [.device, .entity]
        case .isSampler: [.device, .entity]
        case .isEffectUnit: [.device, .entity]
        case .isDrumMachine: [.device, .entity]
        // MARK: Status
        case .isOffline: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .isPrivate: [.inputEndpoint, .outputEndpoint]
        // MARK: Drivers
        case .driverOwner: [.device, .entity, .inputEndpoint, .outputEndpoint]
        case .driverVersion: [.device, .entity, .inputEndpoint, .outputEndpoint]
        // MARK: Connections
        case .canRoute: [.device, .entity]
        case .isBroadcast: [.inputEndpoint, .outputEndpoint]
        case .connectionUniqueID: [.inputEndpoint, .outputEndpoint] // ?
        case .isEmbeddedEntity: [.entity, .inputEndpoint, .outputEndpoint]
        case .singleRealtimeEntity: [.device, .inputEndpoint, .outputEndpoint] // ?
        // MARK: Channels
        case .receiveChannels: [.device, .entity, .inputEndpoint, .outputEndpoint] // ?
        case .transmitChannels: [.device, .entity, .inputEndpoint, .outputEndpoint] // ?
        case .maxReceiveChannels: [.device]
        case .maxTransmitChannels: [.device]
        // MARK: Banks
        case .receivesBankSelectLSB: [.device, .entity]
        case .receivesBankSelectMSB: [.device, .entity]
        case .transmitsBankSelectLSB: [.device, .entity]
        case .transmitsBankSelectMSB: [.device, .entity]
        // MARK: Notes
        case .receivesNotes: [.device, .entity]
        case .transmitsNotes: [.device, .entity]
        // MARK: Program Changes
        case .receivesProgramChanges: [.device, .entity]
        case .transmitsProgramChanges: [.device, .entity]
        }
    }
}

#endif
