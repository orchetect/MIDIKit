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
    // MARK: - Base Properties and Methods
    
    /// The MIDI I/O object type.
    var objectType: MIDIIOObjectType { get }
    
    /// The Core MIDI numerical object reference.
    var coreMIDIObjectRef: CoreMIDIObjectRef { get }
    
    /// Return as ``AnyMIDIIOObject``, a type-erased representation of a MIDIKit object conforming
    /// to ``MIDIIOObject``.
    func asAnyMIDIIOObject() -> AnyMIDIIOObject
    
    // MARK: - MIDIIOObject Comparison.swift
    
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
    
    // MARK: - MIDIIOObject Properties.swift
    
    // MARK: Identification
    
    /// User-visible name of the object.
    /// (`kMIDIPropertyName`)
    ///
    /// Devices, entities, and endpoints may all have names. Note that these names are
    /// not required to be unique. Using ``MIDIIOObject/displayName-7u7g1`` may provide a better description
    /// of the endpoint for user interface.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and
    /// external devices.
    var name: String { get }
    
    /// Model name.
    /// (`kMIDIPropertyModel`)
    ///
    /// Use this property in the following scenarios:
    /// - MIDI drivers should set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    var model: String? { get }
    
    /// Manufacturer name.
    /// (`kMIDIPropertyManufacturer`)
    ///
    /// Use this property in the following cases:
    /// - MIDI drivers set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    var manufacturer: String? { get }
    
    /// The unique ID for the Core MIDI object.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this
    /// property on their endpoints, though doing so may fail if the chosen ID is not unique.
    var uniqueID: MIDIIdentifier { get }
    
    /// The user-visible System Exclusive (SysEx) identifier of a device or entity.
    /// (`kMIDIPropertyDeviceID`)
    ///
    /// MIDI drivers can set this property on their devices or entities. Studio setup editors can
    /// allow the user to set this property on external devices.
    var deviceManufacturerID: Int32 { get }
    
    // MARK: Capabilities
    
    /// Boolean value that indicates whether the device or entity implements the MIDI Machine
    /// Control portion of the MIDI specification.
    /// (`kMIDIPropertySupportsMMC`)
    var supportsMMC: Bool { get }
    
    /// Boolean value that indicates whether the device or entity implements the General MIDI
    /// specification.
    /// (`kMIDIPropertySupportsGeneralMIDI`)
    var supportsGeneralMIDI: Bool { get }
    
    /// Boolean value that indicates whether the device implements the MIDI Show Control
    /// specification.
    /// (`kMIDIPropertySupportsShowControl`)
    var supportsShowControl: Bool { get }
    
    // MARK: Configuration
    
    /// The device’s current patch, note, and control name values in MIDINameDocument XML
    /// format.
    /// (`kMIDIPropertyNameConfigurationDictionary`)
    ///
    /// - Requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    var nameConfigurationDictionary: NSDictionary? { get }
    
    /// The maximum rate, in bytes per second, at which the system may reliably send System
    /// Exclusive (SysEx) messages to this object.
    /// (`kMIDIPropertyMaxSysExSpeed`)
    ///
    /// The owning driver may set an integer value for this property.
    var maxSysExSpeed: Int32 { get }
    
    /// Get the full path to an app on the system that configures driver-owned devices.
    /// (`kMIDIPropertyDriverDeviceEditorApp`)
    ///
    /// Only drivers may set this property on their owned devices.
    var driverDeviceEditorApp: URL? { get }
    
    // MARK: Presentation
    
    /// The full path to a device icon on the system.
    /// (`kMIDIPropertyImage`)
    ///
    /// An image stored in any standard graphic file format, such as JPEG, GIF, or PNG.
    /// The maximum size for this image is 128 by 128 pixels.
    ///
    /// A studio setup editor should allow the user to choose icons for external devices.
    var imageFileURL: URL? { get }
    
    #if canImport(AppKit) && os(macOS)
    /// Calls ``MIDIIOObject/imageFileURL-6ltjy`` and attempts to initialize a new `NSImage`.
    /// (`kMIDIPropertyImage`)
    var imageAsNSImage: NSImage? { get }
    #endif
    
    #if canImport(UIKit)
    /// Calls ``MIDIIOObject/imageFileURL-6ltjy`` and attempts to initialize a new `UIImage`.
    /// (`kMIDIPropertyImage`)
    var imageAsUIImage: UIImage? { get }
    #endif
    
    /// The user-visible name for an endpoint that combines the device and endpoint names.
    /// (Apple-recommended user-visible name)
    /// (`kMIDIPropertyDisplayName`)
    ///
    /// For objects other than endpoints, the display name is the same as its `kMIDIPropertyName`
    /// value.
    var displayName: String? { get }
    
    // MARK: Audio
    
    /// Boolean value that indicates whether the MIDI pan messages sent to the device or
    /// entity cause undesirable effects when playing stereo sounds.
    /// (`kMIDIPropertyPanDisruptsStereo`)
    var panDisruptsStereo: Bool { get }
    
    // MARK: Protocol
    
    /// The native protocol in which the endpoint communicates.
    /// (`kMIDIPropertyProtocolID`)
    ///
    /// The system sets this value on endpoints when it creates them. Drivers can dynamically change
    /// the endpoint’s protocol as a result of a MIDI-CI negotiation, by setting this property.
    ///
    /// Clients can observe changes to this property.
    ///
    /// - Requires: macOS 11.0, macCatalyst 14.0, iOS 14.0
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    var protocolID: MIDIProtocolVersion? { get }
    
    // MARK: Timing
    
    /// Boolean value that indicates whether the device or entity transmits MIDI Time Code
    /// messages.
    /// (`kMIDIPropertyTransmitsMTC`)
    var transmitsMTC: Bool { get }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Time Code
    /// messages.
    /// (`kMIDIPropertyReceivesMTC`)
    var receivesMTC: Bool { get }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI beat clock
    /// messages.
    /// (`kMIDIPropertyTransmitsClock`)
    var transmitsClock: Bool { get }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI beat clock
    /// messages.
    /// (`kMIDIPropertyReceivesClock`)
    var receivesClock: Bool { get }
    
    /// Recommended number of microseconds in advance that clients should schedule output.
    /// (`kMIDIPropertyAdvanceScheduleTimeMuSec`)
    ///
    /// Only the driver that owns the object may set this property.
    ///
    /// If this property value is nonzero, clients should treat the value as a minimum. For devices
    /// with a nonzero advance schedule time, drivers receive outgoing messages to the device at the
    /// time the client sends them using `MIDISend(_:_:_:)`. The driver is responsible for
    /// scheduling events to play at the right times, according to their timestamps.
    ///
    /// You can also set this property on any virtual destinations you create. When clients send
    /// messages to a virtual destination with an advance schedule time of 0, the destination
    /// receives the messages at the scheduled delivery time. If a virtual destination has a nonzero
    /// advance schedule time, it receives timestamped messages as soon as they’re sent, and must do
    /// its own internal scheduling of events it receives.
    var advanceScheduleTimeMuSec: String? { get }
    
    // MARK: Roles
    
    /// Boolean value that indicates whether the device or entity mixes external audio
    /// signals.
    /// (`kMIDIPropertyIsMixer`)
    var isMixer: Bool { get }
    
    /// Boolean value that indicates whether the device or entity plays audio samples in
    /// response to MIDI note messages.
    /// (`kMIDIPropertyIsSampler`)
    var isSampler: Bool { get }
    
    /// Boolean value that indicates whether the device or entity primarily acts as a
    /// MIDI-controlled audio effect.
    /// (`kMIDIPropertyIsEffectUnit`)
    var isEffectUnit: Bool { get }
    
    /// Boolean value that indicates whether the device or entity’s samples aren’t
    /// transposable, as with a drum kit.
    /// (`kMIDIPropertyIsDrumMachine`)
    var isDrumMachine: Bool { get }
    
    // MARK: Status
    
    /// Boolean value that indicates whether the object is offline.
    /// (`kMIDIPropertyOffline`)
    ///
    /// - `true` indicates the device is temporarily absent and offline.
    /// - `false` indicates the object is present.
    var isOffline: Bool { get }
    
    /// Boolean value that indicates whether the system hides an endpoint from other clients.
    /// (`kMIDIPropertyPrivate`)
    ///
    /// You can set this property on a device or entity, but it still appears in the API; the system
    /// only hides the object’s owned endpoints.
    var isPrivate: Bool { get }
    
    // MARK: Drivers
    
    /// Name of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverOwner`)
    ///
    /// Set by the owning driver, on the device; should not be touched by other clients. Property is
    /// inherited by entities and endpoints from their owning device.
    var driverOwner: String? { get }
    
    /// Version of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverVersion`)
    var driverVersion: Int32 { get }
    
    // MARK: Connections
    
    /// Boolean value that indicates whether the device or entity can route messages to or
    /// from external MIDI devices.
    /// (`kMIDIPropertyCanRoute`)
    ///
    /// Don’t set this property value on driver-owned devices.
    var canRoute: Bool { get }
    
    /// Boolean value that indicates whether the endpoint broadcasts messages to all of the
    /// other endpoints in the device.
    /// (`kMIDIPropertyIsBroadcast`)
    ///
    /// Only the owning driver may set this property.
    var isBroadcast: Bool { get }
    
    /// Unique identifier of an external device attached to this connection.
    /// (`kMIDIPropertyConnectionUniqueID`)
    ///
    /// The value provided may be an integer. To indicate that a driver connects to multiple
    /// external objects, pass the array of big-endian SInt32 values as a CFData object.
    ///
    /// The property is nonexistent or 0 if there’s no connection.
    var connectionUniqueID: MIDIIdentifier { get }
    
    /// Boolean value that indicates whether this entity or endpoint has external MIDI
    /// connections.
    /// (`kMIDIPropertyIsEmbeddedEntity`)
    var isEmbeddedEntity: Bool { get }
    
    /// 0-based index of the entity on which incoming real-time messages from the device
    /// appear to have originated.
    /// (`kMIDIPropertySingleRealtimeEntity`)
    var singleRealtimeEntity: Int32 { get }
    
    // MARK: Channels
    
    /// Bitmap of channels on which the object receives messages.
    /// (`kMIDIPropertyReceiveChannels`)
    ///
    /// You can use this property in the following scenarios:
    /// - Drivers can set this property on their entities and endpoints.
    /// - Studio setup editors can allow the user to set this property on external endpoints.
    /// - Virtual destinations can set this property on their endpoints.
    var receiveChannels: Int32 { get }
    
    /// Bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyTransmitChannels`)
    var transmitChannels: Int32 { get }
    
    /// Bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyMaxReceiveChannels`)
    var maxReceiveChannels: Int32 { get }
    
    /// Maximum number of MIDI channels on which a device may simultaneously transmit
    /// channel messages.
    /// (`kMIDIPropertyMaxTransmitChannels`)
    ///
    /// Common values are 0, 1, or 16.
    var maxTransmitChannels: Int32 { get }
    
    // MARK: Banks
    
    /// Boolean value that indicates whether the device or entity responds to MIDI bank select
    /// LSB messages.
    /// (`kMIDIPropertyReceivesBankSelectLSB`)
    var receivesBankSelectLSB: Bool { get }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI bank select
    /// MSB messages.
    /// (`kMIDIPropertyReceivesBankSelectMSB`)
    var receivesBankSelectMSB: Bool { get }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI bank select
    /// LSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectLSB`)
    var transmitsBankSelectLSB: Bool { get }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI bank select
    /// MSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectMSB`)
    var transmitsBankSelectMSB: Bool { get }
    
    // MARK: Notes
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Note On
    /// messages.
    /// (`kMIDIPropertyReceivesNotes`)
    var receivesNotes: Bool { get }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI note
    /// messages.
    /// (`kMIDIPropertyTransmitsNotes`)
    var transmitsNotes: Bool { get }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Program
    /// Change messages.
    /// (`kMIDIPropertyReceivesProgramChanges`)
    var receivesProgramChanges: Bool { get }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI Program
    /// Change messages.
    /// (`kMIDIPropertyTransmitsProgramChanges`)
    var transmitsProgramChanges: Bool { get }
    
    // MARK: - MIDIIOObject Properties Dictionary.swift
    
    /// Get all properties as a key/value pair array, formatted as human-readable strings.
    /// Useful for displaying in a user interface or outputting to console for debugging.
    func propertiesAsStrings(
        onlyIncludeRelevant: Bool
    ) -> [(key: String, value: String)]
}

#endif
