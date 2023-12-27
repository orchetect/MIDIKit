//
//  MIDIKit-0.7.1.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI
import Foundation
import MIDIKitCore

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// Symbols that were renamed or removed.

// MARK: - Properties (Computed)

extension MIDIIOObject {
    // MARK: Identification
    
    @available(*, deprecated, renamed: "name")
    public func getName() -> String? {
        name
    }
    
    @available(*, deprecated, renamed: "model")
    public func getModel() -> String? {
        model
    }
    
    @available(*, deprecated, renamed: "manufacturer")
    public func getManufacturer() -> String? {
        manufacturer
    }
    
    @available(*, deprecated, renamed: "uniqueID")
    public func getUniqueID() -> MIDIIdentifier {
        uniqueID
    }
    
    @available(*, deprecated, renamed: "deviceManufacturerID")
    public func getDeviceManufacturerID() -> Int32 {
        deviceManufacturerID
    }
    
    @available(*, deprecated, renamed: "supportsMMC")
    public func getSupportsMMC() -> Bool {
        supportsMMC
    }
    
    @available(*, deprecated, renamed: "supportsGeneralMIDI")
    public func getSupportsGeneralMIDI() -> Bool {
        supportsGeneralMIDI
    }
    
    @available(*, deprecated, renamed: "supportsShowControl")
    public func getSupportsShowControl() -> Bool {
        supportsShowControl
    }
    
    // MARK: Configuration
    
    @available(*, deprecated, renamed: "nameConfigurationDictionary")
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public func getNameConfigurationDictionary() -> NSDictionary? {
        nameConfigurationDictionary
    }
    
    @available(*, deprecated, renamed: "maxSysExSpeed")
    public func getMaxSysExSpeed() -> Int32 {
        maxSysExSpeed
    }
    
    @available(*, deprecated, renamed: "driverDeviceEditorApp")
    public func getDriverDeviceEditorApp() -> URL? {
        driverDeviceEditorApp
    }
    
    // MARK: Presentation
    
    @available(*, deprecated, renamed: "imageFileURL")
    public func getImageFileURL() -> URL? {
        imageFileURL
    }
    
    #if canImport(AppKit) && os(macOS)
    @available(*, deprecated, renamed: "imageAsNSImage")
    public func getImageAsNSImage() -> NSImage? {
        imageAsNSImage
    }
    #endif
    
    #if canImport(UIKit)
    @available(*, deprecated, renamed: "imageAsUIImage")
    public func getImageAsUIImage() -> UIImage? {
        imageAsUIImage
    }
    #endif
    
    @available(*, deprecated, renamed: "displayName")
    public func getDisplayName() -> String? {
        displayName
    }
    
    // MARK: Audio
    
    @available(*, deprecated, renamed: "panDisruptsStereo")
    public func getPanDisruptsStereo() -> Bool {
        panDisruptsStereo
    }
    
    // MARK: Protocols
    
    @available(*, deprecated, renamed: "protocolID")
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public func getProtocolID() -> MIDIProtocolVersion? {
        protocolID
    }
    
    // MARK: Timing
    
    @available(*, deprecated, renamed: "transmitsMTC")
    public func getTransmitsMTC() -> Bool {
        transmitsMTC
    }
    
    @available(*, deprecated, renamed: "receivesMTC")
    public func getReceivesMTC() -> Bool {
        receivesMTC
    }
    
    @available(*, deprecated, renamed: "transmitsClock")
    public func getTransmitsClock() -> Bool {
        transmitsClock
    }
    
    @available(*, deprecated, renamed: "receivesClock")
    public func getReceivesClock() -> Bool {
        receivesClock
    }
    
    @available(*, deprecated, renamed: "advanceScheduleTimeMuSec")
    public func getAdvanceScheduleTimeMuSec() -> String? {
        advanceScheduleTimeMuSec
    }
    
    // MARK: Roles
    
    @available(*, deprecated, renamed: "isMixer")
    public func getIsMixer() -> Bool {
        isMixer
    }
    
    @available(*, deprecated, renamed: "isSampler")
    public func getIsSampler() -> Bool {
        isSampler
    }
    
    @available(*, deprecated, renamed: "isEffectUnit")
    public func getIsEffectUnit() -> Bool {
        isEffectUnit
    }
    
    @available(*, deprecated, renamed: "isDrumMachine")
    public func getIsDrumMachine() -> Bool {
        isDrumMachine
    }
    
    // MARK: Status
    
    @available(*, deprecated, renamed: "isOffline")
    public func getIsOffline() -> Bool {
        isOffline
    }
    
    @available(*, deprecated, renamed: "isPrivate")
    public func getIsPrivate() -> Bool {
        isPrivate
    }
    
    // MARK: Drivers
    
    @available(*, deprecated, renamed: "driverOwner")
    public func getDriverOwner() -> String? {
        driverOwner
    }
    
    @available(*, deprecated, renamed: "driverVersion")
    public func getDriverVersion() -> Int32 {
        driverVersion
    }
    
    // MARK: Connections
    
    @available(*, deprecated, renamed: "canRoute")
    public func getCanRoute() -> Bool {
        canRoute
    }
    
    @available(*, deprecated, renamed: "isBroadcast")
    public func getIsBroadcast() -> Bool {
        isBroadcast
    }
    
    @available(*, deprecated, renamed: "connectionUniqueID")
    public func getConnectionUniqueID() -> MIDIIdentifier {
        connectionUniqueID
    }
    
    @available(*, deprecated, renamed: "isEmbeddedEntity")
    public func getIsEmbeddedEntity() -> Bool {
        isEmbeddedEntity
    }
    
    @available(*, deprecated, renamed: "singleRealtimeEntity")
    public func getSingleRealtimeEntity() -> Int32 {
        singleRealtimeEntity
    }
    
    // MARK: Channels
    
    @available(*, deprecated, renamed: "receiveChannels")
    public func getReceiveChannels() -> Int32 {
        receiveChannels
    }
    
    @available(*, deprecated, renamed: "transmitChannels")
    public func getTransmitChannels() -> Int32 {
        transmitChannels
    }
    
    @available(*, deprecated, renamed: "maxReceiveChannels")
    public func getMaxReceiveChannels() -> Int32 {
        maxReceiveChannels
    }
    
    @available(*, deprecated, renamed: "maxTransmitChannels")
    public func getMaxTransmitChannels() -> Int32 {
        maxTransmitChannels
    }
    
    // MARK: Banks
    
    @available(*, deprecated, renamed: "receivesBankSelectLSB")
    public func getReceivesBankSelectLSB() -> Bool {
        receivesBankSelectLSB
    }
    
    @available(*, deprecated, renamed: "receivesBankSelectMSB")
    public func getReceivesBankSelectMSB() -> Bool {
        receivesBankSelectMSB
    }
    
    @available(*, deprecated, renamed: "transmitsBankSelectLSB")
    public func getTransmitsBankSelectLSB() -> Bool {
        transmitsBankSelectLSB
    }
    
    @available(*, deprecated, renamed: "transmitsBankSelectMSB")
    public func getTransmitsBankSelectMSB() -> Bool {
        transmitsBankSelectMSB
    }
    
    // MARK: Notes
    
    @available(*, deprecated, renamed: "receivesNotes")
    public func getReceivesNotes() -> Bool {
        receivesNotes
    }
    
    @available(*, deprecated, renamed: "transmitsNotes")
    public func getTransmitsNotes() -> Bool {
        transmitsNotes
    }
    
    // MARK: Program Changes
    
    @available(*, deprecated, renamed: "receivesProgramChanges")
    public func getReceivesProgramChanges() -> Bool {
        receivesProgramChanges
    }
    
    @available(*, deprecated, renamed: "transmitsProgramChanges")
    public func getTransmitsProgramChanges() -> Bool {
        transmitsProgramChanges
    }
}

extension _MIDIEndpoint {
    @available(*, deprecated, renamed: "entity")
    public func getEntity() -> MIDIEntity? {
        entity
    }
    
    @available(*, deprecated, renamed: "device")
    public func getDevice() -> MIDIDevice? {
        device
    }
}

// Protocols

@available(*, unavailable, renamed: "MIDIDevicesProtocol")
public protocol MIDIIODevicesProtocol { }

@available(*, unavailable, renamed: "MIDIEndpointsProtocol")
public protocol MIDIIOEndpointsProtocol { }

@available(*, unavailable, renamed: "MIDIEndpoint")
public protocol MIDIIOEndpointProtocol { }

@available(*, unavailable, renamed: "MIDIReceiverProtocol")
public protocol MIDIIOReceiveHandlerProtocol { }

#endif
