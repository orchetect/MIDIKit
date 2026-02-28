//
//  MIDIIOObject Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Properties (Computed)

// NOTE: Inline documentation is already supplied by the MIDIIOObject protocol

extension MIDIIOObject {
    // MARK: Identification
    
    // NOTE: `name` is a cached property and is managed by the object instance.
    // public var name: String
    
    public var model: String {
        get throws { try MIDIKitIO.getModel(of: coreMIDIObjectRef) }
    }
    
    public var manufacturer: String {
        get throws { try MIDIKitIO.getManufacturer(of: coreMIDIObjectRef) }
    }
    
    // NOTE: `uniqueID` is a cached property and is managed by the object instance.
    // public var uniqueID: MIDIIdentifier
    
    public var deviceManufacturerID: Int32 {
        get throws { try MIDIKitIO.getDeviceManufacturerID(of: coreMIDIObjectRef) }
    }
    
    // MARK: Capabilities
    
    public var supportsMMC: Bool {
        get throws { try MIDIKitIO.getSupportsMMC(of: coreMIDIObjectRef) }
    }
    
    public var supportsGeneralMIDI: Bool {
        get throws { try MIDIKitIO.getSupportsGeneralMIDI(of: coreMIDIObjectRef) }
    }
    
    public var supportsShowControl: Bool {
        get throws { try MIDIKitIO.getSupportsShowControl(of: coreMIDIObjectRef) }
    }
    
    // MARK: Configuration
    
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public var nameConfigurationDictionary: NSDictionary {
        get throws { try MIDIKitIO.getNameConfigurationDictionary(of: coreMIDIObjectRef) }
    }
    
    public var maxSysExSpeed: Int32 {
        get throws { try MIDIKitIO.getMaxSysExSpeed(of: coreMIDIObjectRef) }
    }
    
    public var driverDeviceEditorApp: URL {
        get throws { try MIDIKitIO.getDriverDeviceEditorApp(of: coreMIDIObjectRef) }
    }
    
    // MARK: Presentation
    
    #if canImport(SwiftUI)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public var image: Image? {
        get throws {
            #if os(macOS)
            guard let img = try imageAsNSImage else { return nil }
            return Image(nsImage: img)
            #elseif os(iOS)
            guard let img = try imageAsUIImage else { return nil }
            return Image(uiImage: img)
            #else
            nil
            #endif
        }
    }
    #endif
    
    public var imageFileURL: URL {
        get throws { try MIDIKitIO.getImage(of: coreMIDIObjectRef) }
    }
    
    #if canImport(AppKit) && os(macOS)
    public var imageAsNSImage: NSImage? {
        get throws {
            let url = try imageFileURL
            return NSImage(contentsOf: url)
        }
    }
    #endif
    
    #if canImport(UIKit)
    public var imageAsUIImage: UIImage? {
        get throws {
            let url = try imageFileURL
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        }
    }
    #endif
    
    // NOTE: `displayName` is a cached property and is managed by the object instance.
    // public var name: String
    
    // MARK: Audio
    
    public var panDisruptsStereo: Bool {
        get throws { try MIDIKitIO.getPanDisruptsStereo(of: coreMIDIObjectRef) }
    }
    
    // MARK: Protocol
    
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public var protocolID: MIDIProtocolVersion? {
        get throws {
            guard let proto = try MIDIKitIO.getProtocolID(of: coreMIDIObjectRef) else { return nil }
            return .init(proto)
        }
    }
    
    // MARK: Timing
    
    public var transmitsMTC: Bool {
        get throws { try MIDIKitIO.getTransmitsMTC(of: coreMIDIObjectRef) }
    }
    
    public var receivesMTC: Bool {
        get throws { try MIDIKitIO.getReceivesMTC(of: coreMIDIObjectRef) }
    }
    
    public var transmitsClock: Bool {
        get throws { try MIDIKitIO.getTransmitsClock(of: coreMIDIObjectRef) }
    }
    
    public var receivesClock: Bool {
        get throws { try MIDIKitIO.getReceivesClock(of: coreMIDIObjectRef) }
    }
    
    public var advanceScheduleTimeMuSec: String {
        get throws { try MIDIKitIO.getAdvanceScheduleTimeMuSec(of: coreMIDIObjectRef) }
    }
    
    // MARK: Roles
    
    public var isMixer: Bool {
        get throws { try MIDIKitIO.getIsMixer(of: coreMIDIObjectRef) }
    }
    
    public var isSampler: Bool {
        get throws { try MIDIKitIO.getIsSampler(of: coreMIDIObjectRef) }
    }
    
    public var isEffectUnit: Bool {
        get throws { try MIDIKitIO.getIsEffectUnit(of: coreMIDIObjectRef) }
    }
    
    public var isDrumMachine: Bool {
        get throws { try MIDIKitIO.getIsDrumMachine(of: coreMIDIObjectRef) }
    }
    
    // MARK: Status
    
    public var isOffline: Bool {
        get throws { try MIDIKitIO.getIsOffline(of: coreMIDIObjectRef) }
    }
    
    public var isPrivate: Bool {
        get throws { try MIDIKitIO.getIsPrivate(of: coreMIDIObjectRef) }
    }
    
    // MARK: Drivers
    
    public var driverOwner: String {
        get throws { try MIDIKitIO.getDriverOwner(of: coreMIDIObjectRef) }
    }
    
    public var driverVersion: Int32 {
        get throws { try MIDIKitIO.getDriverVersion(of: coreMIDIObjectRef) }
    }
    
    // MARK: Connections
    
    public var canRoute: Bool {
        get throws { try MIDIKitIO.getCanRoute(of: coreMIDIObjectRef) }
    }
    
    public var isBroadcast: Bool {
        get throws { try MIDIKitIO.getIsBroadcast(of: coreMIDIObjectRef) }
    }
    
    public var connectionUniqueID: MIDIIdentifier {
        get throws { try MIDIKitIO.getConnectionUniqueID(of: coreMIDIObjectRef) }
    }
    
    public var isEmbeddedEntity: Bool {
        get throws { try MIDIKitIO.getIsEmbeddedEntity(of: coreMIDIObjectRef) }
    }
    
    public var singleRealtimeEntity: Int32 {
        get throws { try MIDIKitIO.getSingleRealtimeEntity(of: coreMIDIObjectRef) }
    }
    
    // MARK: Channels
    
    public var receiveChannels: Int32 {
        get throws { try MIDIKitIO.getReceiveChannels(of: coreMIDIObjectRef) }
    }
    
    public var transmitChannels: Int32 {
        get throws { try MIDIKitIO.getTransmitChannels(of: coreMIDIObjectRef) }
    }
    
    public var maxReceiveChannels: Int32 {
        get throws { try MIDIKitIO.getMaxReceiveChannels(of: coreMIDIObjectRef) }
    }
    
    public var maxTransmitChannels: Int32 {
        get throws { try MIDIKitIO.getMaxTransmitChannels(of: coreMIDIObjectRef) }
    }
    
    // MARK: Banks
    
    public var receivesBankSelectLSB: Bool {
        get throws { try MIDIKitIO.getReceivesBankSelectLSB(of: coreMIDIObjectRef) }
    }
    
    public var receivesBankSelectMSB: Bool {
        get throws { try MIDIKitIO.getReceivesBankSelectMSB(of: coreMIDIObjectRef) }
    }
    
    public var transmitsBankSelectLSB: Bool {
        get throws { try MIDIKitIO.getTransmitsBankSelectLSB(of: coreMIDIObjectRef) }
    }
    
    public var transmitsBankSelectMSB: Bool {
        get throws { try MIDIKitIO.getTransmitsBankSelectMSB(of: coreMIDIObjectRef) }
    }
    
    // MARK: Notes
    
    public var receivesNotes: Bool {
        get throws { try MIDIKitIO.getReceivesNotes(of: coreMIDIObjectRef) }
    }
    
    public var transmitsNotes: Bool {
        get throws { try MIDIKitIO.getTransmitsNotes(of: coreMIDIObjectRef) }
    }
    
    // MARK: Program Changes
    
    public var receivesProgramChanges: Bool {
        get throws { try MIDIKitIO.getReceivesProgramChanges(of: coreMIDIObjectRef) }
    }
    
    public var transmitsProgramChanges: Bool {
        get throws { try MIDIKitIO.getTransmitsProgramChanges(of: coreMIDIObjectRef) }
    }
}

#endif
