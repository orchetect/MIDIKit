//
//  MIDIIOObject Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

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
    // public var name: String?
    
    public var model: String? {
        try? MIDIKitIO.getModel(of: coreMIDIObjectRef)
    }
    
    public var manufacturer: String? {
        try? MIDIKitIO.getManufacturer(of: coreMIDIObjectRef)
    }
    
    // NOTE: `uniqueID` is a cached property and is managed by the object instance.
    // public var uniqueID: MIDIIdentifier
    
    public var deviceManufacturerID: Int32 {
        MIDIKitIO.getDeviceManufacturerID(of: coreMIDIObjectRef)
    }
    
    // MARK: Capabilities
    
    public var supportsMMC: Bool {
        MIDIKitIO.getSupportsMMC(of: coreMIDIObjectRef)
    }
    
    public var supportsGeneralMIDI: Bool {
        MIDIKitIO.getSupportsGeneralMIDI(of: coreMIDIObjectRef)
    }
    
    public var supportsShowControl: Bool {
        MIDIKitIO.getSupportsShowControl(of: coreMIDIObjectRef)
    }
    
    // MARK: Configuration
    
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public var nameConfigurationDictionary: NSDictionary? {
        try? MIDIKitIO.getNameConfigurationDictionary(of: coreMIDIObjectRef)
    }
    
    public var maxSysExSpeed: Int32 {
        MIDIKitIO.getMaxSysExSpeed(of: coreMIDIObjectRef)
    }
    
    public var driverDeviceEditorApp: URL? {
        try? MIDIKitIO.getDriverDeviceEditorApp(of: coreMIDIObjectRef)
    }
    
    // MARK: Presentation
    
    #if canImport(SwiftUI)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public var image: Image? {
        #if os(macOS)
        guard let img = imageAsNSImage else { return nil }
        return Image(nsImage: img)
        #elseif os(iOS)
        guard let img = imageAsUIImage else { return nil }
        return Image(uiImage: img)
        #else
        nil
        #endif
    }
    #endif
    
    public var imageFileURL: URL? {
        try? MIDIKitIO.getImage(of: coreMIDIObjectRef)
    }
    
    #if canImport(AppKit) && os(macOS)
    public var imageAsNSImage: NSImage? {
        guard let url = imageFileURL else { return nil }
        return NSImage(contentsOf: url)
    }
    #endif
    
    #if canImport(UIKit)
    public var imageAsUIImage: UIImage? {
        guard let url = imageFileURL,
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    #endif
    
    public var displayName: String? {
        try? MIDIKitIO.getDisplayName(of: coreMIDIObjectRef)
    }
    
    // MARK: Audio
    
    public var panDisruptsStereo: Bool {
        MIDIKitIO.getPanDisruptsStereo(of: coreMIDIObjectRef)
    }
    
    // MARK: Protocol
    
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public var protocolID: MIDIProtocolVersion? {
        guard let proto = MIDIKitIO.getProtocolID(of: coreMIDIObjectRef) else { return nil }
        return .init(proto)
    }
    
    // MARK: Timing
    
    public var transmitsMTC: Bool {
        MIDIKitIO.getTransmitsMTC(of: coreMIDIObjectRef)
    }
    
    public var receivesMTC: Bool {
        MIDIKitIO.getReceivesMTC(of: coreMIDIObjectRef)
    }
    
    public var transmitsClock: Bool {
        MIDIKitIO.getTransmitsClock(of: coreMIDIObjectRef)
    }
    
    public var receivesClock: Bool {
        MIDIKitIO.getReceivesClock(of: coreMIDIObjectRef)
    }
    
    public var advanceScheduleTimeMuSec: String? {
        try? MIDIKitIO.getAdvanceScheduleTimeMuSec(of: coreMIDIObjectRef)
    }
    
    // MARK: Roles
    
    public var isMixer: Bool {
        MIDIKitIO.getIsMixer(of: coreMIDIObjectRef)
    }
    
    public var isSampler: Bool {
        MIDIKitIO.getIsSampler(of: coreMIDIObjectRef)
    }
    
    public var isEffectUnit: Bool {
        MIDIKitIO.getIsEffectUnit(of: coreMIDIObjectRef)
    }
    
    public var isDrumMachine: Bool {
        MIDIKitIO.getIsDrumMachine(of: coreMIDIObjectRef)
    }
    
    // MARK: Status
    
    public var isOffline: Bool {
        MIDIKitIO.getIsOffline(of: coreMIDIObjectRef)
    }
    
    public var isPrivate: Bool {
        MIDIKitIO.getIsPrivate(of: coreMIDIObjectRef)
    }
    
    // MARK: Drivers
    
    public var driverOwner: String? {
        try? MIDIKitIO.getDriverOwner(of: coreMIDIObjectRef)
    }
    
    public var driverVersion: Int32 {
        MIDIKitIO.getDriverVersion(of: coreMIDIObjectRef)
    }
    
    // MARK: Connections
    
    public var canRoute: Bool {
        MIDIKitIO.getCanRoute(of: coreMIDIObjectRef)
    }
    
    public var isBroadcast: Bool {
        MIDIKitIO.getIsBroadcast(of: coreMIDIObjectRef)
    }
    
    public var connectionUniqueID: MIDIIdentifier {
        MIDIKitIO.getConnectionUniqueID(of: coreMIDIObjectRef)
    }
    
    public var isEmbeddedEntity: Bool {
        MIDIKitIO.getIsEmbeddedEntity(of: coreMIDIObjectRef)
    }
    
    public var singleRealtimeEntity: Int32 {
        MIDIKitIO.getSingleRealtimeEntity(of: coreMIDIObjectRef)
    }
    
    // MARK: Channels
    
    public var receiveChannels: Int32 {
        MIDIKitIO.getReceiveChannels(of: coreMIDIObjectRef)
    }
    
    public var transmitChannels: Int32 {
        MIDIKitIO.getTransmitChannels(of: coreMIDIObjectRef)
    }
    
    public var maxReceiveChannels: Int32 {
        MIDIKitIO.getMaxReceiveChannels(of: coreMIDIObjectRef)
    }
    
    public var maxTransmitChannels: Int32 {
        MIDIKitIO.getMaxTransmitChannels(of: coreMIDIObjectRef)
    }
    
    // MARK: Banks
    
    public var receivesBankSelectLSB: Bool {
        MIDIKitIO.getReceivesBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    public var receivesBankSelectMSB: Bool {
        MIDIKitIO.getReceivesBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    public var transmitsBankSelectLSB: Bool {
        MIDIKitIO.getTransmitsBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    public var transmitsBankSelectMSB: Bool {
        MIDIKitIO.getTransmitsBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    // MARK: Notes
    
    public var receivesNotes: Bool {
        MIDIKitIO.getReceivesNotes(of: coreMIDIObjectRef)
    }
    
    public var transmitsNotes: Bool {
        MIDIKitIO.getTransmitsNotes(of: coreMIDIObjectRef)
    }
    
    // MARK: Program Changes
    
    public var receivesProgramChanges: Bool {
        MIDIKitIO.getReceivesProgramChanges(of: coreMIDIObjectRef)
    }
    
    public var transmitsProgramChanges: Bool {
        MIDIKitIO.getTransmitsProgramChanges(of: coreMIDIObjectRef)
    }
}

#endif
