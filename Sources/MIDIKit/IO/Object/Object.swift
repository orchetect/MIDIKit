//
//  Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: - MIDIIOObjectRefProtocol (aka MIDI.IO.ObjectRef)

public protocol MIDIIOObjectRefProtocol {
    
    /// Enum describing the abstracted object type.
    static var objectType: MIDI.IO.ObjectType { get }
    
    /// The CoreMIDI object reference (integer)
    var ref: MIDIObjectRef { get }
    
    /// Name of the object
    var name: String { get }
    
    /// The unique ID for the CoreMIDI object
    var uniqueID: MIDI.IO.UniqueID { get }
    
}

extension MIDI.IO {
    
    public typealias ObjectRef = MIDIIOObjectRefProtocol
    
}

// MARK: - MIDIIOObject (aka MIDI.IO.Object)

public protocol MIDIIOObjectProtocol: Hashable {
    
}

extension MIDI.IO {
    
    public typealias Object = MIDIIOObjectProtocol
    
}



// MARK: - Equatable

extension MIDI.IO.Object where Self : MIDI.IO.ObjectRef {
    
    static public func == (lhs: Self, rhs: Self) -> Bool {
        lhs.ref == rhs.ref
    }
    
}

// MARK: - Hashable

extension MIDI.IO.Object where Self : MIDI.IO.ObjectRef {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ref)
    }
    
}

// MARK: - Collection methods

extension Collection where Element : MIDI.IO.ObjectRef {
    
    /// Returns the array sorted alphabetically by name.
    public func sortedByName() -> [Element] {
        
        self.sorted(by: {
            $0.name
                .localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        })
        
    }
    
}

extension Collection where Element : MIDI.IO.ObjectRef {
    
    /// Returns the element where uniqueID matches if found.
    public func filterBy(uniqueID: MIDI.IO.UniqueID) -> Element? {
        
        first(where: { $0.uniqueID == uniqueID })
        
    }
    
    /// Returns all elements matching the given name.
    public func filterBy(name: String) -> [Element] {
        
        filter { $0.name == name }
        
    }
    
    /// Returns all elements matching all supplied parameters.
    public func filterBy(displayName: String) -> [Element] {
        
        filter { $0.getDisplayName == displayName }
        
    }
    
}

// MARK: - Properties (Computed)

extension MIDI.IO.ObjectRef {
    
    // MARK: Identification
    
    /// Get user-visible endpoint name.
    /// (`kMIDIPropertyName`)
    ///
    /// Devices, entities, and endpoints may all have names. The standard way to display an endpoint’s name is to ask it for its name and display it only if unique. If not, prepend the device name.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and external devices.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getName: String? {
        try? MIDI.IO.getName(of: ref)
    }
    
    /// Get model name.
    /// (`kMIDIPropertyModel`)
    ///
    /// Use this property in the following scenarios:
    /// - MIDI drivers should set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getModel: String? {
        try? MIDI.IO.getModel(of: ref)
    }
    
    /// Get manufacturer name.
    /// (`kMIDIPropertyManufacturer`)
    ///
    /// Use this property in the following cases:
    /// - MIDI drivers set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getManufacturer: String? {
        try? MIDI.IO.getManufacturer(of: ref)
    }
    
    /// Get unique ID.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
    public var getUniqueID: MIDI.IO.UniqueID {
        MIDI.IO.getUniqueID(of: ref)
    }
    
    /// Get the user-visible System Exclusive (SysEx) identifier of a device or entity.
    /// (`kMIDIPropertyDeviceID`)
    ///
    /// MIDI drivers can set this property on their devices or entities. Studio setup editors can allow the user to set this property on external devices.
    public var getDeviceID: Int32 {
        MIDI.IO.getDeviceID(of: ref)
    }
    
    // MARK: Capabilities
    
    /// Get a Boolean value that indicates whether the device or entity implements the MIDI Machine Control portion of the MIDI specification.
    /// (`kMIDIPropertySupportsMMC`)
    public var getSupportsMMC: Bool {
        MIDI.IO.getSupportsMMC(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity implements the General MIDI specification.
    /// (`kMIDIPropertySupportsGeneralMIDI`)
    public var getSupportsGeneralMIDI: Bool {
        MIDI.IO.getSupportsGeneralMIDI(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device implements the MIDI Show Control specification.
    /// (`kMIDIPropertySupportsShowControl`)
    public var getSupportsShowControl: Bool {
        MIDI.IO.getSupportsShowControl(of: ref)
    }
    
    // MARK: Configuration
    
    /// Get the device’s current patch, note, and control name values in MIDINameDocument XML format.
    /// (`kMIDIPropertyNameConfigurationDictionary`)
    ///
    /// - requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public var getNameConfigurationDictionary: NSDictionary? {
        try? MIDI.IO.getNameConfigurationDictionary(of: ref)
    }
    
    /// Get the maximum rate, in bytes per second, at which the system may reliably send System Exclusive (SysEx) messages to this object.
    /// (`kMIDIPropertyMaxSysExSpeed`)
    ///
    /// The owning driver may set an integer value for this property.
    public var getMaxSysExSpeed: Int32 {
        MIDI.IO.getMaxSysExSpeed(of: ref)
    }
    
    /// Get the full path to an app on the system that configures driver-owned devices.
    /// (`kMIDIPropertyDriverDeviceEditorApp`)
    ///
    /// Only drivers may set this property on their owned devices.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getDriverDeviceEditorApp: URL? {
        try? MIDI.IO.getDriverDeviceEditorApp(of: ref)
    }
    
    // MARK: Presentation
    
    /// Get the full path to a device icon on the system.
    /// (`kMIDIPropertyImage`)
    ///
    /// You can provide an image stored in any standard graphic file format, such as JPEG, GIF, or PNG. The maximum size for this image is 128 by 128 pixels.
    ///
    /// A studio setup editor should allow the user to choose icons for external devices.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getImageFileURL: URL? {
        try? MIDI.IO.getImage(of: ref)
    }
    
    #if canImport(AppKit) && os(macOS)
    /// Calls `getImageFileURL` and attempts to initialize a new `NSImage`.
    public var getImageAsNSImage: NSImage? {
        guard let url = getImageFileURL else { return nil }
        return NSImage(contentsOf: url)
    }
    #endif
    
    #if canImport(UIKit)
    /// Calls `getImageFileURL` and attempts to initialize a new `UIImage`.
    public var getImageAsUIImage: UIImage? {
        guard let url = getImageFileURL,
              let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    #endif
    
    /// Get The user-visible name for an endpoint that combines the device and endpoint names.
    /// (Apple-recommended user-visible name)
    /// (`kMIDIPropertyDisplayName`)
    ///
    /// For objects other than endpoints, the display name is the same as its `kMIDIPropertyName` value.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getDisplayName: String? {
        try? MIDI.IO.getDisplayName(of: ref)
    }
    
    // MARK: Audio
    
    /// Get a Boolean value that indicates whether the MIDI pan messages sent to the device or entity cause undesirable effects when playing stereo sounds.
    /// (`kMIDIPropertyPanDisruptsStereo`)
    public var getPanDisruptsStereo: Bool {
        MIDI.IO.getPanDisruptsStereo(of: ref)
    }
    
    // MARK: Protocols
    
    /// Get the native protocol in which the endpoint communicates.
    /// (`kMIDIPropertyProtocolID`)
    ///
    /// The system sets this value on endpoints when it creates them. Drivers can dynamically change the endpoint’s protocol as a result of a MIDI-CI negotiation, by setting this property.
    ///
    /// Clients can observe changes to this property.
    ///
    /// - requires: macOS 11.0, macCatalyst 14.0, iOS 14.0
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public var getProtocolID: MIDIProtocolID? {
        MIDI.IO.getProtocolID(of: ref)
    }
    
    // MARK: Timing
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Time Code messages.
    /// (`kMIDIPropertyTransmitsMTC`)
    public var getTransmitsMTC: Bool {
        MIDI.IO.getTransmitsMTC(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Time Code messages.
    /// (`kMIDIPropertyReceivesMTC`)
    public var getReceivesMTC: Bool {
        MIDI.IO.getReceivesMTC(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI beat clock messages.
    /// (`kMIDIPropertyTransmitsClock`)
    public var getTransmitsClock: Bool {
        MIDI.IO.getTransmitsClock(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI beat clock messages.
    /// (`kMIDIPropertyReceivesClock`)
    public var getReceivesClock: Bool {
        MIDI.IO.getReceivesClock(of: ref)
    }
    
    /// Get the recommended number of microseconds in advance that clients should schedule output.
    /// (`kMIDIPropertyAdvanceScheduleTimeMuSec`)
    ///
    /// Only the driver that owns the object may set this property.
    ///
    /// If this property value is nonzero, clients should treat the value as a minimum. For devices with a nonzero advance schedule time, drivers receive outgoing messages to the device at the time the client sends them using `MIDISend(_:_:_:)`. The driver is responsible for scheduling events to play at the right times, according to their timestamps.
    ///
    /// You can also set this property on any virtual destinations you create. When clients send messages to a virtual destination with an advance schedule time of 0, the destination receives the messages at the scheduled delivery time. If a virtual destination has a nonzero advance schedule time, it receives timestamped messages as soon as they’re sent, and must do its own internal scheduling of events it receives.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getAdvanceScheduleTimeMuSec: String? {
        try? MIDI.IO.getAdvanceScheduleTimeMuSec(of: ref)
    }
    
    // MARK: Roles
    
    /// Get a Boolean value that indicates whether the device or entity mixes external audio signals.
    /// (`kMIDIPropertyIsMixer`)
    public var getIsMixer: Bool {
        MIDI.IO.getIsMixer(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity plays audio samples in response to MIDI note messages.
    /// (`kMIDIPropertyIsSampler`)
    public var getIsSampler: Bool {
        MIDI.IO.getIsSampler(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity primarily acts as a MIDI-controlled audio effect.
    /// (`kMIDIPropertyIsEffectUnit`)
    public var getIsEffectUnit: Bool {
        MIDI.IO.getIsEffectUnit(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity’s samples aren’t transposable, as with a drum kit.
    /// (`kMIDIPropertyIsDrumMachine`)
    public var getIsDrumMachine: Bool {
        MIDI.IO.getIsDrumMachine(of: ref)
    }
    
    // MARK: Status
    
    /// Get a Boolean value that indicates whether the object is offline.
    ///
    /// `True` indicates the device is temporarily absent and offline.
    /// `False` indicates the object is present.
    ///
    /// (`kMIDIPropertyOffline`)
    public var getIsOffline: Bool {
        MIDI.IO.getIsOffline(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the system hides an endpoint from other clients.
    ///
    /// You can set this property on a device or entity, but it still appears in the API; the system only hides the object’s owned endpoints.
    ///
    /// (`kMIDIPropertyPrivate`)
    public var getIsPrivate: Bool {
        MIDI.IO.getIsPrivate(of: ref)
    }
    
    // MARK: Drivers
    
    /// Get name of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverOwner`)
    ///
    /// Set by the owning driver, on the device; should not be touched by other clients. Property is inherited from the device by its entities and endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getDriverOwner: String? {
        try? MIDI.IO.getDriverOwner(of: ref)
    }
    
    /// Get the version of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverVersion`)
    public var getDriverVersion: Int32 {
        MIDI.IO.getDriverVersion(of: ref)
    }
    
    // MARK: Connections
    
    /// Get a Boolean value that indicates whether the device or entity can route messages to or from external MIDI devices.
    /// (`kMIDIPropertyCanRoute`)
    ///
    /// Don’t set this property value on driver-owned devices.
    public var getCanRoute: Bool {
        MIDI.IO.getCanRoute(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the endpoint broadcasts messages to all of the other endpoints in the device.
    /// (`kMIDIPropertyIsBroadcast`)
    ///
    /// Only the owning driver may set this property.
    public var getIsBroadcast: Bool {
        MIDI.IO.getIsBroadcast(of: ref)
    }
    
    /// Get the unique identifier of an external device attached to this connection.
    /// (`kMIDIPropertyConnectionUniqueID`)
    ///
    /// The value provided may be an integer. To indicate that a driver connects to multiple external objects, pass the array of big-endian SInt32 values as a CFData object.
    ///
    /// The property is nonexistent or 0 if there’s no connection.
    public var getConnectionUniqueID: Int32 {
        MIDI.IO.getConnectionUniqueID(of: ref)
    }
    
    /// Get a Boolean value that indicates whether this entity or endpoint has external MIDI connections.
    /// (`kMIDIPropertyIsEmbeddedEntity`)
    public var getIsEmbeddedEntity: Bool {
        MIDI.IO.getIsEmbeddedEntity(of: ref)
    }
    
    /// Get the 0-based index of the entity on which incoming real-time messages from the device appear to have originated.
    /// (`kMIDIPropertySingleRealtimeEntity`)
    public var getSingleRealtimeEntity: Int32 {
        MIDI.IO.getSingleRealtimeEntity(of: ref)
    }
    
    // MARK: Channels
    
    /// Get the bitmap of channels on which the object receives messages.
    /// (`kMIDIPropertyReceiveChannels`)
    ///
    /// You can use this property in the following scenarios:
    /// - Drivers can set this property on their entities and endpoints.
    /// - Studio setup editors can allow the user to set this property on external endpoints.
    /// - Virtual destinations can set this property on their endpoints.
    ///
    public var getReceiveChannels: Int32 {
        MIDI.IO.getReceiveChannels(of: ref)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyTransmitChannels`)
    public var getTransmitChannels: Int32 {
        MIDI.IO.getTransmitChannels(of: ref)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyMaxReceiveChannels`)
    public var getMaxReceiveChannels: Int32 {
        MIDI.IO.getMaxReceiveChannels(of: ref)
    }
    
    /// Get the maximum number of MIDI channels on which a device may simultaneously transmit channel messages.
    /// (`kMIDIPropertyMaxTransmitChannels`)
    ///
    /// Common values are 0, 1, or 16.
    public var getMaxTransmitChannels: Int32 {
        MIDI.IO.getMaxTransmitChannels(of: ref)
    }
    
    // MARK: Banks
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select LSB messages.
    /// (`kMIDIPropertyReceivesBankSelectLSB`)
    public var getReceivesBankSelectLSB: Bool {
        MIDI.IO.getReceivesBankSelectLSB(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select MSB messages.
    /// (`kMIDIPropertyReceivesBankSelectMSB`)
    public var getReceivesBankSelectMSB: Bool {
        MIDI.IO.getReceivesBankSelectMSB(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select LSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectLSB`)
    public var getTransmitsBankSelectLSB: Bool {
        MIDI.IO.getTransmitsBankSelectLSB(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select MSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectMSB`)
    public var getTransmitsBankSelectMSB: Bool {
        MIDI.IO.getTransmitsBankSelectMSB(of: ref)
    }
    
    // MARK: Notes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Note On messages.
    /// (`kMIDIPropertyReceivesNotes`)
    public var getReceivesNotes: Bool {
        MIDI.IO.getReceivesNotes(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI note messages.
    /// (`kMIDIPropertyTransmitsNotes`)
    public var getTransmitsNotes: Bool {
        MIDI.IO.getTransmitsNotes(of: ref)
    }
    
    // MARK: Program Changes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Program Change messages.
    /// (`kMIDIPropertyReceivesProgramChanges`)
    public var getReceivesProgramChanges: Bool {
        MIDI.IO.getReceivesProgramChanges(of: ref)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Program Change messages.
    /// (`kMIDIPropertyTransmitsProgramChanges`)
    public var getTransmitsProgramChanges: Bool {
        MIDI.IO.getTransmitsProgramChanges(of: ref)
    }
    
}

extension MIDI.IO.ObjectRef {
    
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

extension MIDI.IO.ObjectRef {
    
    internal func getPropertyKeyValuePairAsStrings(of property: MIDI.IO.kMIDIProperty) -> (key: String, value: String) {
        
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
                    value: "\(getDeviceID)")
            
            
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
            if #available(macOS 11.0, macCatalyst 14, iOS 14, *) {
                valueString = "\(getProtocolID?.rawValue, ifNil: "-")"
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

