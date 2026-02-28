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
        relevantOnly: Bool = true,
        defaultValue: (_ property: MIDIIOObjectProperty, _ error: MIDIIOError?) -> String? = { _, _ in "-" }
    ) -> [(key: String, value: String)] {
        (
            relevantOnly
                ? objectType.relevantProperties
                : MIDIIOObjectProperty.allCases
        )
        .compactMap {
            let value: String
            do {
                value = try propertyStringValue(for: $0)
            } catch let error as MIDIIOError {
                guard let defValue = defaultValue($0, error) else { return nil }
                value = defValue
            } catch {
                return nil // TODO: factor this out once property getters all have strongly typed `throws(MIDIIOError)` signatures
            }
            return (key: $0.name, value: value)
        }
    }
    
    // inline docs provided by the MIDIIOObject protocol
    public func propertyStringValue(for property: MIDIIOObjectProperty) throws -> String {
        switch property {
        // MARK: Identification
        case .name: // override cache
            return try MIDIKitIO.getName(of: coreMIDIObjectRef)
            
        case .model:
            return try model
            
        case .manufacturer:
            return try manufacturer
            
        case .uniqueID: // override cache
            return "\(try MIDIKitIO.getUniqueID(of: coreMIDIObjectRef))"
            
        case .deviceID:
            return "\(try deviceManufacturerID)"
            
        // MARK: Capabilities
        case .supportsMMC:
            return try supportsMMC ? "Yes" : "No"
            
        case .supportsGeneralMIDI:
            return try supportsGeneralMIDI ? "Yes" : "No"
            
        case .supportsShowControl:
            return try supportsShowControl ? "Yes" : "No"
            
        // MARK: Configuration
        case .nameConfigurationDictionary:
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                return try nameConfigurationDictionary.description
            } else {
                return "OS not supported. Requires macOS 10.15, macCatalyst 13.0, or iOS 13.0."
            }
            
        case .maxSysExSpeed:
            return "\(try maxSysExSpeed)"
            
        case .driverDeviceEditorApp:
            return try driverDeviceEditorApp.absoluteString
            
        // MARK: Presentation
        case .image:
            return try imageFileURL.absoluteString
            
        case .displayName:
            return displayName
            
        // MARK: Audio
        case .panDisruptsStereo:
            return try panDisruptsStereo ? "Yes" : "No"
            
        // MARK: Protocols
        case .protocolID:
            var valueString = "-"
            if #available(macOS 11, iOS 14, macCatalyst 14, *) {
                if let protocolID = try protocolID {
                    valueString = "\(protocolID)"
                }
            } else {
                valueString = "OS not supported. Requires macOS 11.0, macCatalyst 14.0, or iOS 14.0."
            }
            
            return valueString
            
        // MARK: Timing
        case .transmitsMTC:
            return try transmitsMTC ? "Yes" : "No"
            
        case .receivesMTC:
            return try receivesMTC ? "Yes" : "No"
            
        case .transmitsClock:
            return try transmitsClock ? "Yes" : "No"
            
        case .receivesClock:
            return try receivesClock ? "Yes" : "No"
            
        case .advanceScheduleTimeMuSec:
            return try advanceScheduleTimeMuSec
            
        // MARK: Roles
        case .isMixer:
            return try isMixer ? "Yes" : "No"
            
        case .isSampler:
            return try isSampler ? "Yes" : "No"
            
        case .isEffectUnit:
            return try isEffectUnit ? "Yes" : "No"
            
        case .isDrumMachine:
            return try isDrumMachine ? "Yes" : "No"
            
        // MARK: Status
        case .isOffline:
            return try isOffline ? "Yes" : "No"
            
        case .isPrivate:
            return try isPrivate ? "Yes" : "No"
            
        // MARK: Drivers
        case .driverOwner:
            return try driverOwner
            
        case .driverVersion:
            return "\(try driverVersion)"
            
        // MARK: Connections
        case .canRoute:
            return try canRoute ? "Yes" : "No"
            
        case .isBroadcast:
            return try isBroadcast ? "Yes" : "No"
            
        case .connectionUniqueID:
            return "\(try connectionUniqueID)"
            
        case .isEmbeddedEntity:
            return try isEmbeddedEntity ? "Yes" : "No"
            
        case .singleRealtimeEntity:
            return "\(try singleRealtimeEntity)"
            
        // MARK: Channels
        case .receiveChannels:
            return try receiveChannels.binaryString(padTo: 8)
            
        case .transmitChannels:
            return try transmitChannels.binaryString(padTo: 8)
            
        case .maxReceiveChannels:
            return "\(try maxReceiveChannels)"
            
        case .maxTransmitChannels:
            return "\(try maxTransmitChannels)"
            
        // MARK: Banks
        case .receivesBankSelectLSB:
            return try receivesBankSelectLSB ? "Yes" : "No"
            
        case .receivesBankSelectMSB:
            return try receivesBankSelectMSB ? "Yes" : "No"
            
        case .transmitsBankSelectLSB:
            return try transmitsBankSelectLSB ? "Yes" : "No"
            
        case .transmitsBankSelectMSB:
            return try transmitsBankSelectMSB ? "Yes" : "No"
            
        // MARK: Notes
        case .receivesNotes:
            return try receivesNotes ? "Yes" : "No"
            
        case .transmitsNotes:
            return try transmitsNotes ? "Yes" : "No"
            
        // MARK: Program Changes
        case .receivesProgramChanges:
            return try receivesProgramChanges ? "Yes" : "No"
            
        case .transmitsProgramChanges:
            return try transmitsProgramChanges ? "Yes" : "No"
        }
    }
}

#endif
