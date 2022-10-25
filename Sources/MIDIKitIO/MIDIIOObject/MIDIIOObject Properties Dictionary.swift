//
//  MIDIIOObject Properties Dictionary.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

extension MIDIIOObject {
    /// Get all properties as a key/value pair array, formatted as human-readable strings.
    /// Useful for displaying in a user interface or outputting to console for debugging.
    public func propertiesAsStrings(
        onlyIncludeRelevant: Bool = true
    ) -> [(key: String, value: String)] {
        (
            onlyIncludeRelevant
                ? objectType.relevantProperties
                : AnyMIDIIOObject.Property.allCases
        )
        .map {
            getPropertyKeyValuePairAsStrings(of: $0)
        }
    }
    
    /// Returns a human-readable key and value pair for the property.
    internal func getPropertyKeyValuePairAsStrings(
        of property: AnyMIDIIOObject.Property
    ) -> (key: String, value: String) {
        switch property {
        // MARK: Identification
        case .name: // override cache
            return (
                key: "Name",
                value: (try? MIDIKitIO.getName(of: coreMIDIObjectRef)) ?? "-"
            )
    
        case .model:
            return (
                key: "Model",
                value: model ?? "-"
            )
    
        case .manufacturer:
            return (
                key: "Manufacturer",
                value: manufacturer ?? "-"
            )
    
        case .uniqueID: // override cache
            return (
                key: "Unique ID",
                value: "\(MIDIKitIO.getUniqueID(of: coreMIDIObjectRef))"
            )
    
        case .deviceID:
            return (
                key: "Device ID",
                value: "\(deviceManufacturerID))"
            )
    
        // MARK: Capabilities
        case .supportsMMC:
            return (
                key: "Supports MMC",
                value: supportsMMC ? "Yes" : "No"
            )
    
        case .supportsGeneralMIDI:
            return (
                key: "Supports General MIDI",
                value: supportsGeneralMIDI ? "Yes" : "No"
            )
    
        case .supportsShowControl:
            return (
                key: "Supports Show Control",
                value: supportsShowControl ? "Yes" : "No"
            )
    
        // MARK: Configuration
        case .nameConfigurationDictionary:
            var valueString = "-"
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                valueString = nameConfigurationDictionary?.description ?? "-"
            } else {
                valueString =
                    "OS not supported. Requires macOS 10.15, macCatalyst 13.0, or iOS 13.0."
            }
            return (
                key: "Name Configuration Dictionary",
                value: valueString
            )
    
        case .maxSysExSpeed:
            return (
                key: "Max SysEx Speed",
                value: "\(maxSysExSpeed)"
            )
    
        case .driverDeviceEditorApp:
            return (
                key: "Driver Device Editor App",
                value: driverDeviceEditorApp?.absoluteString ?? "-"
            )
    
        // MARK: Presentation
        case .image:
            return (
                key: "Image (File URL)",
                value: imageFileURL?.absoluteString ?? "-"
            )
    
        case .displayName:
            return (
                key: "Display Name",
                value: displayName ?? "-"
            )
    
        // MARK: Audio
        case .panDisruptsStereo:
            return (
                key: "Pan Disrupts Stereo",
                value: panDisruptsStereo ? "Yes" : "No"
            )
    
        // MARK: Protocols
        case .protocolID:
            var valueString = "-"
            if #available(macOS 11, iOS 14, macCatalyst 14, *) {
                if let unwrappedProtocolID = protocolID {
                    valueString = "\(unwrappedProtocolID)"
                }
            } else {
                valueString =
                    "OS not supported. Requires macOS 11.0, macCatalyst 14.0, or iOS 14.0."
            }
    
            return (
                key: "Protocol ID",
                value: valueString
            )
    
        // MARK: Timing
        case .transmitsMTC:
            return (
                key: "Transmits MTC",
                value: transmitsMTC ? "Yes" : "No"
            )
    
        case .receivesMTC:
            return (
                key: "Receives MTC",
                value: receivesMTC ? "Yes" : "No"
            )
    
        case .transmitsClock:
            return (
                key: "Transmits Clock",
                value: transmitsClock ? "Yes" : "No"
            )
    
        case .receivesClock:
            return (
                key: "Receives Clock",
                value: receivesClock ? "Yes" : "No"
            )
    
        case .advanceScheduleTimeMuSec:
            return (
                key: "Advance Schedule Time (μs)",
                value: advanceScheduleTimeMuSec ?? "-"
            )
    
        // MARK: Roles
        case .isMixer:
            return (
                key: "Is Mixer",
                value: isMixer ? "Yes" : "No"
            )
    
        case .isSampler:
            return (
                key: "Is Sampler",
                value: isSampler ? "Yes" : "No"
            )
    
        case .isEffectUnit:
            return (
                key: "Is Effect Unit",
                value: isEffectUnit ? "Yes" : "No"
            )
    
        case .isDrumMachine:
            return (
                key: "Is Drum Machine",
                value: isDrumMachine ? "Yes" : "No"
            )
    
        // MARK: Status
        case .isOffline:
            return (
                key: "Is Offline",
                value: isOffline ? "Yes" : "No"
            )
    
        case .isPrivate:
            return (
                key: "Is Private",
                value: isPrivate ? "Yes" : "No"
            )
    
        // MARK: Drivers
        case .driverOwner:
            return (
                key: "Driver Owner",
                value: driverOwner ?? "-"
            )
    
        case .driverVersion:
            return (
                key: "Driver Version",
                value: "\(driverVersion)"
            )
    
        // MARK: Connections
        case .canRoute:
            return (
                key: "Can Route",
                value: canRoute ? "Yes" : "No"
            )
    
        case .isBroadcast:
            return (
                key: "Is Broadcast",
                value: isBroadcast ? "Yes" : "No"
            )
    
        case .connectionUniqueID:
            return (
                key: "Connection Unique ID",
                value: "\(connectionUniqueID)"
            )
    
        case .isEmbeddedEntity:
            return (
                key: "Is Embedded Entity",
                value: isEmbeddedEntity ? "Yes" : "No"
            )
    
        case .singleRealtimeEntity:
            return (
                key: "Single Realtime Entity",
                value: "\(singleRealtimeEntity)"
            )
    
        // MARK: Channels
        case .receiveChannels:
            let valueString = receiveChannels.binaryString(padTo: 8)
    
            return (
                key: "Receive Channels",
                value: "\(valueString)"
            )
    
        case .transmitChannels:
            let valueString = transmitChannels.binaryString(padTo: 8)
    
            return (
                key: "Transmit Channels",
                value: "\(valueString)"
            )
    
        case .maxReceiveChannels:
            return (
                key: "Max Receive Channels",
                value: "\(maxReceiveChannels)"
            )
    
        case .maxTransmitChannels:
            return (
                key: "Max Transmit Channels",
                value: "\(maxTransmitChannels)"
            )
    
        // MARK: Banks
        case .receivesBankSelectLSB:
            return (
                key: "Receives Bank Select LSB",
                value: receivesBankSelectLSB ? "Yes" : "No"
            )
    
        case .receivesBankSelectMSB:
            return (
                key: "Receives Bank Select MSB",
                value: receivesBankSelectMSB ? "Yes" : "No"
            )
    
        case .transmitsBankSelectLSB:
            return (
                key: "Transmits Bank Select LSB",
                value: transmitsBankSelectLSB ? "Yes" : "No"
            )
    
        case .transmitsBankSelectMSB:
            return (
                key: "Transmits Bank Select MSB",
                value: transmitsBankSelectMSB ? "Yes" : "No"
            )
    
        // MARK: Notes
        case .receivesNotes:
            return (
                key: "Receives Notes",
                value: receivesNotes ? "Yes" : "No"
            )
    
        case .transmitsNotes:
            return (
                key: "Transmits Notes",
                value: transmitsNotes ? "Yes" : "No"
            )
    
        // MARK: Program Changes
        case .receivesProgramChanges:
            return (
                key: "Receives Program Changes",
                value: receivesProgramChanges ? "Yes" : "No"
            )
    
        case .transmitsProgramChanges:
            return (
                key: "Transmits Program Changes",
                value: transmitsProgramChanges ? "Yes" : "No"
            )
        }
    }
}

#endif
