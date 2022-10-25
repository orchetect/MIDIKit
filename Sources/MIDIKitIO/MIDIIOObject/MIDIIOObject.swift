//
//  MIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public protocol MIDIIOObject {
    /// The MIDI I/O object type.
    var objectType: MIDIIOObjectType { get }
    
    // MARK: - Cached Properties
    
    /// User-visible name of the object.
    /// (`kMIDIPropertyName`)
    ///
    /// Devices, entities, and endpoints may all have names. Note that these names are
    /// not required to be unique. Using ``displayName-7u7g1`` may provide a better description
    /// of the endpoint for user interface.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and
    /// external devices.
    var name: String { get }
    
    /// The unique ID for the Core MIDI object.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this
    /// property on their endpoints, though doing so may fail if the chosen ID is not unique.
    var uniqueID: MIDIIdentifier { get }
    
    /// The Core MIDI object reference.
    var coreMIDIObjectRef: CoreMIDIObjectRef { get }
    
    /// Return as ``AnyMIDIIOObject``, a type-erased representation of a MIDIKit object conforming
    /// to ``MIDIIOObject``.
    func asAnyMIDIIOObject() -> AnyMIDIIOObject
    
    // MARK: - MIDIIOObject Comparison.swift
    
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
    
    // MARK: - MIDIIOObject Properties.swift
    
    // MARK: Identification
    // var name - cached property, declared above
    var model: String? { get }
    var manufacturer: String? { get }
    // var uniqueID - cached property, declared above
    var deviceManufacturerID: Int32 { get }
    
    // MARK: Capabilities
    var supportsMMC: Bool { get }
    var supportsGeneralMIDI: Bool { get }
    var supportsShowControl: Bool { get }
    
    // MARK: Configuration
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    var nameConfigurationDictionary: NSDictionary? { get }
    var maxSysExSpeed: Int32 { get }
    var driverDeviceEditorApp: URL? { get }
    
    // MARK: Presentation
    var imageFileURL: URL? { get }
    #if canImport(AppKit) && os(macOS)
    var imageAsNSImage: NSImage? { get }
    #endif
    #if canImport(UIKit)
    var imageAsUIImage: UIImage? { get }
    #endif
    var displayName: String? { get }
    
    // MARK: Audio
    var panDisruptsStereo: Bool { get }
    
    // MARK: Protocols
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    var protocolID: MIDIProtocolVersion? { get }
    
    // MARK: Timing
    var transmitsMTC: Bool { get }
    var receivesMTC: Bool { get }
    var transmitsClock: Bool { get }
    var receivesClock: Bool { get }
    var advanceScheduleTimeMuSec: String? { get }
    
    // MARK: Roles
    var isMixer: Bool { get }
    var isSampler: Bool { get }
    var isEffectUnit: Bool { get }
    var isDrumMachine: Bool { get }
    
    // MARK: Status
    var isOffline: Bool { get }
    var isPrivate: Bool { get }
    
    // MARK: Drivers
    var driverOwner: String? { get }
    var driverVersion: Int32 { get }
    
    // MARK: Connections
    var canRoute: Bool { get }
    var isBroadcast: Bool { get }
    var connectionUniqueID: MIDIIdentifier { get }
    var isEmbeddedEntity: Bool { get }
    var singleRealtimeEntity: Int32 { get }
    
    // MARK: Channels
    var receiveChannels: Int32 { get }
    var transmitChannels: Int32 { get }
    var maxReceiveChannels: Int32 { get }
    var maxTransmitChannels: Int32 { get }
    
    // MARK: Banks
    var receivesBankSelectLSB: Bool { get }
    var receivesBankSelectMSB: Bool { get }
    var transmitsBankSelectLSB: Bool { get }
    var transmitsBankSelectMSB: Bool { get }
    
    // MARK: Notes
    var receivesNotes: Bool { get }
    var transmitsNotes: Bool { get }
    var receivesProgramChanges: Bool { get }
    var transmitsProgramChanges: Bool { get }
    
    // MARK: - MIDIIOObject Properties Dictionary.swift
    
    func propertiesAsStrings(
        onlyIncludeRelevant: Bool
    ) -> [(key: String, value: String)]
}

#endif
