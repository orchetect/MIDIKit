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
    
    public var model: MIDIIOObjectProperty.Value<String> {
        wrapValue(try MIDIKitIO.getModel(of: coreMIDIObjectRef))
    }
    
    public var manufacturer: MIDIIOObjectProperty.Value<String> {
        wrapValue(try MIDIKitIO.getManufacturer(of: coreMIDIObjectRef))
    }
    
    // NOTE: `uniqueID` is a cached property and is managed by the object instance.
    // public var uniqueID: MIDIIdentifier
    
    public var deviceManufacturerID: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getDeviceManufacturerID(of: coreMIDIObjectRef))
    }
    
    // MARK: Capabilities
    
    public var supportsMMC: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getSupportsMMC(of: coreMIDIObjectRef))
    }
    
    public var supportsGeneralMIDI: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getSupportsGeneralMIDI(of: coreMIDIObjectRef))
    }
    
    public var supportsShowControl: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getSupportsShowControl(of: coreMIDIObjectRef))
    }
    
    // MARK: Configuration
    
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public var nameConfigurationDictionary: MIDIIOObjectProperty.Value<NSDictionary> {
        wrapValue(try MIDIKitIO.getNameConfigurationDictionary(of: coreMIDIObjectRef))
    }
    
    public var maxSysExSpeed: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getMaxSysExSpeed(of: coreMIDIObjectRef))
    }
    
    public var driverDeviceEditorApp: MIDIIOObjectProperty.Value<URL> {
        wrapValue(try MIDIKitIO.getDriverDeviceEditorApp(of: coreMIDIObjectRef))
    }
    
    // MARK: Presentation
    
    #if canImport(SwiftUI)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public var image: MIDIIOObjectProperty.Value<Image> {
        #if os(macOS)
        return imageAsNSImage.convertValue { Image(nsImage: $0) }
        #elseif os(iOS)
        return imageAsUIImage.convertValue { Image(uiImage: $0) }
        #else
        return .error(.notSupported("Not yet supported on this platform."))
        #endif
    }
    #endif
    
    public var imageFileURL: MIDIIOObjectProperty.Value<URL> {
        wrapValue(try MIDIKitIO.getImage(of: coreMIDIObjectRef))
    }
    
    #if canImport(AppKit) && os(macOS)
    public var imageAsNSImage: MIDIIOObjectProperty.Value<NSImage> {
        imageFileURL.convertValue { NSImage(contentsOf: $0) }
    }
    #endif
    
    #if canImport(UIKit)
    public var imageAsUIImage: MIDIIOObjectProperty.Value<UIImage> {
        imageFileURL.convertValue { url throws(MIDIIOError) in
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch {
                throw .malformed("Failed to read MIDI object image data.")
            }
        }
    }
    #endif
    
    // NOTE: `displayName` is a cached property and is managed by the object instance.
    // public var name: String
    
    // MARK: Audio
    
    public var panDisruptsStereo: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getPanDisruptsStereo(of: coreMIDIObjectRef))
    }
    
    // MARK: Protocol
    
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public var protocolID: MIDIIOObjectProperty.Value<MIDIProtocolVersion> {
        wrapValue(try MIDIKitIO.getProtocolID(of: coreMIDIObjectRef))
            .convertValue { MIDIProtocolVersion($0) }
    }
    
    // MARK: Timing
    
    public var transmitsMTC: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsMTC(of: coreMIDIObjectRef))
    }
    
    public var receivesMTC: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesMTC(of: coreMIDIObjectRef))
    }
    
    public var transmitsClock: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsClock(of: coreMIDIObjectRef))
    }
    
    public var receivesClock: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesClock(of: coreMIDIObjectRef))
    }
    
    public var advanceScheduleTimeMuSec: MIDIIOObjectProperty.Value<String> {
        wrapValue(try MIDIKitIO.getAdvanceScheduleTimeMuSec(of: coreMIDIObjectRef))
    }
    
    // MARK: Roles
    
    public var isMixer: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsMixer(of: coreMIDIObjectRef))
    }
    
    public var isSampler: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsSampler(of: coreMIDIObjectRef))
    }
    
    public var isEffectUnit: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsEffectUnit(of: coreMIDIObjectRef))
    }
    
    public var isDrumMachine: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsDrumMachine(of: coreMIDIObjectRef))
    }
    
    // MARK: Status
    
    public var isOffline: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsOffline(of: coreMIDIObjectRef))
    }
    
    public var isPrivate: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsPrivate(of: coreMIDIObjectRef))
    }
    
    // MARK: Drivers
    
    public var driverOwner: MIDIIOObjectProperty.Value<String> {
        wrapValue(try MIDIKitIO.getDriverOwner(of: coreMIDIObjectRef))
    }
    
    public var driverVersion: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getDriverVersion(of: coreMIDIObjectRef))
    }
    
    // MARK: Connections
    
    public var canRoute: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getCanRoute(of: coreMIDIObjectRef))
    }
    
    public var isBroadcast: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsBroadcast(of: coreMIDIObjectRef))
    }
    
    public var connectionUniqueID: MIDIIOObjectProperty.Value<MIDIIdentifier> {
        wrapValue(try MIDIKitIO.getConnectionUniqueID(of: coreMIDIObjectRef))
    }
    
    public var isEmbeddedEntity: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getIsEmbeddedEntity(of: coreMIDIObjectRef))
    }
    
    public var singleRealtimeEntity: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getSingleRealtimeEntity(of: coreMIDIObjectRef))
    }
    
    // MARK: Channels
    
    public var receiveChannels: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getReceiveChannels(of: coreMIDIObjectRef))
    }
    
    public var transmitChannels: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getTransmitChannels(of: coreMIDIObjectRef))
    }
    
    public var maxReceiveChannels: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getMaxReceiveChannels(of: coreMIDIObjectRef))
    }
    
    public var maxTransmitChannels: MIDIIOObjectProperty.Value<Int32> {
        wrapValue(try MIDIKitIO.getMaxTransmitChannels(of: coreMIDIObjectRef))
    }
    
    // MARK: Banks
    
    public var receivesBankSelectLSB: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesBankSelectLSB(of: coreMIDIObjectRef))
    }
    
    public var receivesBankSelectMSB: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesBankSelectMSB(of: coreMIDIObjectRef))
    }
    
    public var transmitsBankSelectLSB: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsBankSelectLSB(of: coreMIDIObjectRef))
    }
    
    public var transmitsBankSelectMSB: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsBankSelectMSB(of: coreMIDIObjectRef))
    }
    
    // MARK: Notes
    
    public var receivesNotes: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesNotes(of: coreMIDIObjectRef))
    }
    
    public var transmitsNotes: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsNotes(of: coreMIDIObjectRef))
    }
    
    // MARK: Program Changes
    
    public var receivesProgramChanges: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getReceivesProgramChanges(of: coreMIDIObjectRef))
    }
    
    public var transmitsProgramChanges: MIDIIOObjectProperty.Value<Bool> {
        wrapValue(try MIDIKitIO.getTransmitsProgramChanges(of: coreMIDIObjectRef))
    }
}

// MARK: - Helpers

func wrapValue<T>(_ block: @autoclosure () throws(MIDIIOError) -> T?) -> MIDIIOObjectProperty.Value<T> {
    do {
        guard let value = try block() else {
            // interpret nil as property not being set
            return .notSet
        }
        return .value(value)
    } catch {
        switch error {
        case .osStatus(.unknownProperty): return .notSet
        default: return .error(error)
        }
    }
}

#endif
