//
//  MIDIIOObject Properties Dictionary.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import MIDIKitInternals

extension MIDIIOObject {
    // inline docs provided by the MIDIIOObject protocol
    public func propertyStringValues(
        relevantOnly: Bool = false,
        defaultValue: (_ property: MIDIIOObjectProperty, _ error: MIDIIOError?) -> String? = { _, _ in "-" }
    ) -> [(key: String, value: String)] {
        (
            relevantOnly
                ? objectType.relevantProperties
                : MIDIIOObjectProperty.allCases
        )
        .compactMap { property in
            let value: String
            do {
                switch propertyStringValue(for: property) {
                case .notSet:
                    // interpret nil as omission from resulting array, and not "notSet" case
                    guard let newValue = defaultValue(property, nil) else { return nil }
                    value = newValue
                case let .error(error):
                    // interpret nil as omission from resulting array, and not "notSet" case
                    guard let newValue = defaultValue(property, error) else { return nil }
                    value = newValue
                case let .value(v):
                    value = v
                }
            }
            return (key: property.name, value: value)
        }
    }
    
    // inline docs provided by the MIDIIOObject protocol
    public func propertyStringValue(
        for property: MIDIIOObjectProperty
    ) -> MIDIIOObjectProperty.Value<String> {
        switch property {
        // MARK: Identification
        case .name: // override cache
            return wrapValue(try MIDIKitIO.getName(of: coreMIDIObjectRef))
            
        case .model:
            return model
            
        case .manufacturer:
            return manufacturer
            
        case .uniqueID: // override cache
            return wrapValue(try MIDIKitIO.getUniqueID(of: coreMIDIObjectRef))
                .convertValue { "\($0)" }
            
        case .deviceID:
            return deviceManufacturerID
                .convertValue { "\($0)" }
            
        // MARK: Capabilities
        case .supportsMMC:
            return supportsMMC
                .convertValue { $0 ? "Yes" : "No" }
            
        case .supportsGeneralMIDI:
            return supportsGeneralMIDI
                .convertValue { $0 ? "Yes" : "No" }
            
        case .supportsShowControl:
            return supportsShowControl
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Configuration
        case .nameConfigurationDictionary:
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                return nameConfigurationDictionary
                    .convertValue { $0.description }
            } else {
                return .error(.notSupported("OS not supported. Requires macOS 10.15, macCatalyst 13.0, or iOS 13.0."))
            }
            
        case .maxSysExSpeed:
            return maxSysExSpeed
                .convertValue { "\($0)" }
            
        case .driverDeviceEditorApp:
            return driverDeviceEditorApp
                .convertValue { $0.absoluteString }
            
        // MARK: Presentation
        case .image:
            return imageFileURL
                .convertValue { $0.absoluteString }
            
        case .displayName: // override cache
            return wrapValue(try MIDIKitIO.getDisplayName(of: coreMIDIObjectRef))
            
        // MARK: Audio
        case .panDisruptsStereo:
            return panDisruptsStereo
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Protocols
        case .protocolID:
            if #available(macOS 11, iOS 14, macCatalyst 14, *) {
                return protocolID
                    .convertValue { "\($0)" }
            } else {
                return .error(.notSupported("OS not supported. Requires macOS 11.0, macCatalyst 14.0, or iOS 14.0."))
            }
            
        // MARK: Timing
        case .transmitsMTC:
            return transmitsMTC
                .convertValue { $0 ? "Yes" : "No" }
            
        case .receivesMTC:
            return receivesMTC
                .convertValue { $0 ? "Yes" : "No" }
            
        case .transmitsClock:
            return transmitsClock
                .convertValue { $0 ? "Yes" : "No" }
            
        case .receivesClock:
            return receivesClock
                .convertValue { $0 ? "Yes" : "No" }
            
        case .advanceScheduleTimeMuSec:
            return advanceScheduleTimeMuSec
            
        // MARK: Roles
        case .isMixer:
            return isMixer
                .convertValue { $0 ? "Yes" : "No" }
            
        case .isSampler:
            return isSampler
                .convertValue { $0 ? "Yes" : "No" }
            
        case .isEffectUnit:
            return isEffectUnit
                .convertValue { $0 ? "Yes" : "No" }
            
        case .isDrumMachine:
            return isDrumMachine
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Status
        case .isOffline:
            return isOffline
                .convertValue { $0 ? "Yes" : "No" }
            
        case .isPrivate:
            return isPrivate
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Drivers
        case .driverOwner:
            return driverOwner
            
        case .driverVersion:
            return driverVersion
                .convertValue { "\($0)" }
            
        // MARK: Connections
        case .canRoute:
            return canRoute
                .convertValue { $0 ? "Yes" : "No" }
            
        case .isBroadcast:
            return isBroadcast
                .convertValue { $0 ? "Yes" : "No" }
            
        case .connectionUniqueID:
            return connectionUniqueID
                .convertValue { "\($0)" }
            
        case .isEmbeddedEntity:
            return isEmbeddedEntity
                .convertValue { $0 ? "Yes" : "No" }
            
        case .singleRealtimeEntity:
            return singleRealtimeEntity
                .convertValue { "\($0)" }
            
        // MARK: Channels
        case .receiveChannels:
            return receiveChannels
                .convertValue { $0.binaryString(padTo: 8) }
            
        case .transmitChannels:
            return transmitChannels
                .convertValue { $0.binaryString(padTo: 8) }
            
        case .maxReceiveChannels:
            return maxReceiveChannels
                .convertValue { "\($0)" }
            
        case .maxTransmitChannels:
            return maxTransmitChannels
                .convertValue { "\($0)" }
            
        // MARK: Banks
        case .receivesBankSelectLSB:
            return receivesBankSelectLSB
                .convertValue { $0 ? "Yes" : "No" }
            
        case .receivesBankSelectMSB:
            return receivesBankSelectMSB
                .convertValue { $0 ? "Yes" : "No" }
            
        case .transmitsBankSelectLSB:
            return transmitsBankSelectLSB
                .convertValue { $0 ? "Yes" : "No" }
            
        case .transmitsBankSelectMSB:
            return transmitsBankSelectMSB
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Notes
        case .receivesNotes:
            return receivesNotes
                .convertValue { $0 ? "Yes" : "No" }
            
        case .transmitsNotes:
            return transmitsNotes
                .convertValue { $0 ? "Yes" : "No" }
            
        // MARK: Program Changes
        case .receivesProgramChanges:
            return receivesProgramChanges
                .convertValue { $0 ? "Yes" : "No" }
            
        case .transmitsProgramChanges:
            return transmitsProgramChanges
                .convertValue { $0 ? "Yes" : "No" }
        }
    }
}

#endif
