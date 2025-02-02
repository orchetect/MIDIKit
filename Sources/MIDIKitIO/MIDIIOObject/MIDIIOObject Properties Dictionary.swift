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
        relevantOnly: Bool = true
    ) -> [(key: String, value: String)] {
        (
            relevantOnly
                ? objectType.relevantProperties
                : AnyMIDIIOObject.Property.allCases
        )
        .map {
            (key: $0.name, value: propertyStringValue(for: $0))
        }
    }
    
    // inline docs provided by the MIDIIOObject protocol
    public func propertyStringValue(for property: AnyMIDIIOObject.Property) -> String {
        switch property {
        // MARK: Identification
        case .name: // override cache
            return (try? MIDIKitIO.getName(of: coreMIDIObjectRef)) ?? "-"
            
        case .model:
            return model ?? "-"
            
        case .manufacturer:
            return manufacturer ?? "-"
            
        case .uniqueID: // override cache
            return "\(MIDIKitIO.getUniqueID(of: coreMIDIObjectRef))"
            
        case .deviceID:
            return "\(deviceManufacturerID)"
            
        // MARK: Capabilities
        case .supportsMMC:
            return supportsMMC ? "Yes" : "No"
            
        case .supportsGeneralMIDI:
            return supportsGeneralMIDI ? "Yes" : "No"
            
        case .supportsShowControl:
            return supportsShowControl ? "Yes" : "No"
            
        // MARK: Configuration
        case .nameConfigurationDictionary:
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                return nameConfigurationDictionary?.description ?? "-"
            } else {
                return "OS not supported. Requires macOS 10.15, macCatalyst 13.0, or iOS 13.0."
            }
            
        case .maxSysExSpeed:
            return "\(maxSysExSpeed)"
            
        case .driverDeviceEditorApp:
            return driverDeviceEditorApp?.absoluteString ?? "-"
            
        // MARK: Presentation
        case .image:
            return imageFileURL?.absoluteString ?? "-"
            
        case .displayName:
            return displayName ?? "-"
            
        // MARK: Audio
        case .panDisruptsStereo:
            return panDisruptsStereo ? "Yes" : "No"
            
        // MARK: Protocols
        case .protocolID:
            var valueString = "-"
            if #available(macOS 11, iOS 14, macCatalyst 14, *) {
                if let protocolID {
                    valueString = "\(protocolID)"
                }
            } else {
                valueString =
                    "OS not supported. Requires macOS 11.0, macCatalyst 14.0, or iOS 14.0."
            }
            
            return valueString
            
        // MARK: Timing
        case .transmitsMTC:
            return transmitsMTC ? "Yes" : "No"
            
        case .receivesMTC:
            return receivesMTC ? "Yes" : "No"
            
        case .transmitsClock:
            return transmitsClock ? "Yes" : "No"
            
        case .receivesClock:
            return receivesClock ? "Yes" : "No"
            
        case .advanceScheduleTimeMuSec:
            return advanceScheduleTimeMuSec ?? "-"
            
        // MARK: Roles
        case .isMixer:
            return isMixer ? "Yes" : "No"
            
        case .isSampler:
            return isSampler ? "Yes" : "No"
            
        case .isEffectUnit:
            return isEffectUnit ? "Yes" : "No"
            
        case .isDrumMachine:
            return isDrumMachine ? "Yes" : "No"
            
        // MARK: Status
        case .isOffline:
            return isOffline ? "Yes" : "No"
            
        case .isPrivate:
            return isPrivate ? "Yes" : "No"
            
        // MARK: Drivers
        case .driverOwner:
            return driverOwner ?? "-"
            
        case .driverVersion:
            return "\(driverVersion)"
            
        // MARK: Connections
        case .canRoute:
            return canRoute ? "Yes" : "No"
            
        case .isBroadcast:
            return isBroadcast ? "Yes" : "No"
            
        case .connectionUniqueID:
            return "\(connectionUniqueID)"
            
        case .isEmbeddedEntity:
            return isEmbeddedEntity ? "Yes" : "No"
            
        case .singleRealtimeEntity:
            return "\(singleRealtimeEntity)"
            
        // MARK: Channels
        case .receiveChannels:
            return receiveChannels.binaryString(padTo: 8)
            
        case .transmitChannels:
            return transmitChannels.binaryString(padTo: 8)
            
        case .maxReceiveChannels:
            return "\(maxReceiveChannels)"
            
        case .maxTransmitChannels:
            return "\(maxTransmitChannels)"
            
        // MARK: Banks
        case .receivesBankSelectLSB:
            return receivesBankSelectLSB ? "Yes" : "No"
            
        case .receivesBankSelectMSB:
            return receivesBankSelectMSB ? "Yes" : "No"
            
        case .transmitsBankSelectLSB:
            return transmitsBankSelectLSB ? "Yes" : "No"
            
        case .transmitsBankSelectMSB:
            return transmitsBankSelectMSB ? "Yes" : "No"
            
        // MARK: Notes
        case .receivesNotes:
            return receivesNotes ? "Yes" : "No"
            
        case .transmitsNotes:
            return transmitsNotes ? "Yes" : "No"
            
        // MARK: Program Changes
        case .receivesProgramChanges:
            return receivesProgramChanges ? "Yes" : "No"
            
        case .transmitsProgramChanges:
            return transmitsProgramChanges ? "Yes" : "No"
        }
    }
}

#endif
