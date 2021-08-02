//
//  MIDIIOObjectProtocol Properties Dictionary.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDIIOObjectProtocol {
    
    /// Get all properties as a key/value pair array, formatted as human-readable strings.
    /// Useful for displaying in a user interface or outputting to console for debugging.
    public func getPropertiesAsStrings(onlyIncludeRelevant: Bool = true) -> [(key: String, value: String)] {
        
        (
            onlyIncludeRelevant
                ? Self.objectType.relevantProperties
                : MIDI.IO.kMIDIProperty.allCases
        )
        .map {
            getPropertyKeyValuePairAsStrings(of: $0)
        }
        
    }
    
}

extension MIDIIOObjectProtocol {
    
    /// Returns a human-readable key and value pair for the property.
    internal func getPropertyKeyValuePairAsStrings(
        of property: MIDI.IO.kMIDIProperty
    ) -> (key: String, value: String) {
        
        switch property {
        
        // MARK: Identification
        case .name:
            return (key: "Name",
                    value: getName ?? "-")
            
        case .model:
            return (key: "Model",
                    value: getModel ?? "-")
            
        case .manufacturer:
            return (key: "Manufacturer",
                    value: getManufacturer ?? "-")
            
        case .uniqueID:
            return (key: "Unique ID",
                    value: "\(getUniqueID)")
            
        case .deviceID:
            return (key: "Device ID",
                    value: "\(getDeviceManufacturerID)")
            
            
        // MARK: Capabilities
        case .supportsMMC:
            return (key: "Supports MMC",
                    value: getSupportsMMC ? "Yes" : "No")
            
        case .supportsGeneralMIDI:
            return (key: "Supports General MIDI",
                    value: getSupportsGeneralMIDI ? "Yes" : "No")
            
        case .supportsShowControl:
            return (key: "Supports Show Control",
                    value: getSupportsShowControl ? "Yes" : "No")
            
            
        // MARK: Configuration
        case .nameConfigurationDictionary:
            var valueString = "-"
            if #available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *) {
                valueString = getNameConfigurationDictionary?.description ?? "-"
            } else {
                valueString = "OS not supported. Requires macOS 10.15, macCatalyst 13.0, or iOS 13.0."
            }
            return (key: "Name Configuration Dictionary",
                    value: valueString)
            
        case .maxSysExSpeed:
            return (key: "Max SysEx Speed",
                    value: "\(getMaxSysExSpeed)")
            
        case .driverDeviceEditorApp:
            return (key: "Driver Device Editor App",
                    value: getDriverDeviceEditorApp?.absoluteString ?? "-")
            
            
        // MARK: Presentation
        case .propertyImage:
            return (key: "Property Image",
                    value: getImageFileURL?.absoluteString ?? "-")
            
        case .displayName:
            return (key: "Display Name",
                    value: getDisplayName ?? "-")
            
            
        // MARK: Audio
        case .panDisruptsStereo:
            return (key: "Pan Disrupts Stereo",
                    value: getPanDisruptsStereo ? "Yes" : "No")
            
            
        // MARK: Protocols
        case .protocolID:
            var valueString = "-"
            if #available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *) {
                if let unwrappedProtocolID = getProtocolID?.rawValue {
                    valueString = "\(unwrappedProtocolID)"
                }
            } else {
                valueString = "OS not supported. Requires macOS 11.0, macCatalyst 14.0, or iOS 14.0."
            }
            
            return (key: "Protocol ID",
                    value: valueString)
            
            
        // MARK: Timing
        case .transmitsMTC:
            return (key: "Transmits MTC",
                    value: getTransmitsMTC ? "Yes" : "No")
            
        case .receivesMTC:
            return (key: "Receives MTC",
                    value: getReceivesMTC ? "Yes" : "No")
            
        case .transmitsClock:
            return (key: "Transmits Clock",
                    value: getTransmitsClock ? "Yes" : "No")
            
        case .receivesClock:
            return (key: "Receives Clock",
                    value: getReceivesClock ? "Yes" : "No")
            
        case .advanceScheduleTimeMuSec:
            return (key: "Advance Schedule Time (μs)",
                    value: getAdvanceScheduleTimeMuSec ?? "-")
            
            
        // MARK: Roles
        case .isMixer:
            return (key: "Is Mixer",
                    value: getIsMixer ? "Yes" : "No")
            
        case .isSampler:
            return (key: "Is Sampler",
                    value: getIsSampler ? "Yes" : "No")
            
        case .isEffectUnit:
            return (key: "Is Effect Unit",
                    value: getIsEffectUnit ? "Yes" : "No")
            
        case .isDrumMachine:
            return (key: "Is Drum Machine",
                    value: getIsDrumMachine ? "Yes" : "No")
            
            
        // MARK: Status
        case .isOffline:
            return (key: "Is Offline",
                    value: getIsOffline ? "Yes" : "No")
            
        case .isPrivate:
            return (key: "Is Private",
                    value: getIsPrivate ? "Yes" : "No")
            
            
        // MARK: Drivers
        case .driverOwner:
            return (key: "Driver Owner",
                    value: getDriverOwner ?? "-")
            
        case .driverVersion:
            return (key: "Driver Version",
                    value: "\(getDriverVersion)")
            
            
        // MARK: Connections
        case .canRoute:
            return (key: "Can Route",
                    value: getCanRoute ? "Yes" : "No")
            
        case .isBroadcast:
            return (key: "Is Broadcast",
                    value: getIsBroadcast ? "Yes" : "No")
            
        case .connectionUniqueID:
            return (key: "Connection Unique ID",
                    value: "\(getConnectionUniqueID)")
            
        case .isEmbeddedEntity:
            return (key: "Is Embedded Entity",
                    value: getIsEmbeddedEntity ? "Yes" : "No")
            
        case .singleRealtimeEntity:
            return (key: "Single Realtime Entity",
                    value: "\(getSingleRealtimeEntity)")
            
            
        // MARK: Channels
        case .receiveChannels:
            let valueString = getReceiveChannels.binary
                .stringValue(padToEvery: 8, splitEvery: 8, prefix: true)
            
            return (key: "Receive Channels",
                    value: "\(valueString)")
            
        case .transmitChannels:
            let valueString = getTransmitChannels.binary
                .stringValue(padToEvery: 8, splitEvery: 8, prefix: true)
            
            return (key: "Transmit Channels",
                    value: "\(valueString)")
            
        case .maxReceiveChannels:
            return (key: "Max Receive Channels",
                    value: "\(getMaxReceiveChannels)")
            
        case .maxTransmitChannels:
            return (key: "Max Transmit Channels",
                    value: "\(getMaxTransmitChannels)")
            
            
        // MARK: Banks
        case .receivesBankSelectLSB:
            return (key: "Receives Bank Select LSB",
                    value: getReceivesBankSelectLSB ? "Yes" : "No")
            
        case .receivesBankSelectMSB:
            return (key: "Receives Bank Select MSB",
                    value: getReceivesBankSelectMSB ? "Yes" : "No")
            
        case .transmitsBankSelectLSB:
            return (key: "Transmits Bank Select LSB",
                    value: getTransmitsBankSelectLSB ? "Yes" : "No")
            
        case .transmitsBankSelectMSB:
            return (key: "Transmits Bank Select MSB",
                    value: getTransmitsBankSelectMSB ? "Yes" : "No")
            
            
        // MARK: Notes
        case .receivesNotes:
            return (key: "Receives Notes",
                    value: getReceivesNotes ? "Yes" : "No")
            
        case .transmitsNotes:
            return (key: "Transmits Notes",
                    value: getTransmitsNotes ? "Yes" : "No")
            
            
        // MARK: Program Changes
        case .receivesProgramChanges:
            return (key: "Receives Program Changes",
                    value: getReceivesProgramChanges ? "Yes" : "No")
            
        case .transmitsProgramChanges:
            return (key: "Transmits Program Changes",
                    value: getTransmitsProgramChanges ? "Yes" : "No")
            
            
        }
        
    }
    
}

