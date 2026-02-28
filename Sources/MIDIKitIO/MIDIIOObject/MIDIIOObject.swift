//
//  MIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

public protocol MIDIIOObject: Sendable {
    // MARK: - Base Properties and Methods
    
    /// The MIDI I/O object type.
    var objectType: MIDIIOObjectType { get } // cached by the concrete object
    
    /// The Core MIDI numerical object reference.
    var coreMIDIObjectRef: CoreMIDIObjectRef { get } // cached by the concrete object
    
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
    /// not required to be unique. Using ``MIDIIOObject/displayName-7u7g1`` may provide a better
    /// description
    /// of the endpoint for user interface.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and
    /// external devices.
    var name: String { get } // cached by the concrete object
    
    /// Model name.
    /// (`kMIDIPropertyModel`)
    ///
    /// Use this property in the following scenarios:
    /// - MIDI drivers should set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    var model: String { get throws }
    
    /// Manufacturer name.
    /// (`kMIDIPropertyManufacturer`)
    ///
    /// Use this property in the following cases:
    /// - MIDI drivers set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    var manufacturer: String { get throws }
    
    /// The unique ID for the Core MIDI object.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this
    /// property on their endpoints, though doing so may fail if the chosen ID is not unique.
    var uniqueID: MIDIIdentifier { get } // cached by the concrete object
    
    /// The user-visible System Exclusive (SysEx) identifier of a device or entity.
    /// (`kMIDIPropertyDeviceID`)
    ///
    /// MIDI drivers can set this property on their devices or entities. Studio setup editors can
    /// allow the user to set this property on external devices.
    ///
    /// - Throws: ``MIDIIOError``
    var deviceManufacturerID: Int32 { get throws }
    
    // MARK: Capabilities
    
    /// Boolean value that indicates whether the device or entity implements the MIDI Machine
    /// Control portion of the MIDI specification.
    /// (`kMIDIPropertySupportsMMC`)
    ///
    /// - Throws: ``MIDIIOError``
    var supportsMMC: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity implements the General MIDI
    /// specification.
    /// (`kMIDIPropertySupportsGeneralMIDI`)
    ///
    /// - Throws: ``MIDIIOError``
    var supportsGeneralMIDI: Bool { get throws }
    
    /// Boolean value that indicates whether the device implements the MIDI Show Control
    /// specification.
    /// (`kMIDIPropertySupportsShowControl`)
    ///
    /// - Throws: ``MIDIIOError``
    var supportsShowControl: Bool { get throws }
    
    // MARK: Configuration
    
    /// The device’s current patch, note, and control name values in MIDINameDocument XML
    /// format.
    /// (`kMIDIPropertyNameConfigurationDictionary`)
    ///
    /// - Requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
    ///
    /// - Throws: ``MIDIIOError``
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    var nameConfigurationDictionary: NSDictionary { get throws }
    
    /// The maximum rate, in bytes per second, at which the system may reliably send System
    /// Exclusive (SysEx) messages to this object.
    /// (`kMIDIPropertyMaxSysExSpeed`)
    ///
    /// The owning driver may set an integer value for this property.
    ///
    /// - Throws: ``MIDIIOError``
    var maxSysExSpeed: Int32 { get throws }
    
    /// Get the full path to an app on the system that configures driver-owned devices.
    /// (`kMIDIPropertyDriverDeviceEditorApp`)
    ///
    /// Only drivers may set this property on their owned devices.
    ///
    /// - Throws: ``MIDIIOError``
    var driverDeviceEditorApp: URL { get throws }
    
    // MARK: Presentation
    
    /// The full path to a device icon on the system.
    /// (`kMIDIPropertyImage`)
    ///
    /// An image stored in any standard graphic file format, such as JPEG, GIF, or PNG.
    /// The maximum size for this image is 128 by 128 pixels.
    ///
    /// A studio setup editor should allow the user to choose icons for external devices.
    ///
    /// - Throws: ``MIDIIOError``
    var imageFileURL: URL { get throws }
    
    #if canImport(SwiftUI)
    /// Calls ``MIDIIOObject/imageFileURL-6ltjy`` and attempts to initialize a new `Image`.
    /// (`kMIDIPropertyImage`)
    ///
    /// - Throws: ``MIDIIOError``
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    var image: Image? { get throws }
    #endif
    
    #if canImport(AppKit) && os(macOS)
    /// Calls ``MIDIIOObject/imageFileURL-6ltjy`` and attempts to initialize a new `NSImage`.
    /// (`kMIDIPropertyImage`)
    ///
    /// - Throws: ``MIDIIOError``
    var imageAsNSImage: NSImage? { get throws }
    #endif
    
    #if canImport(UIKit)
    /// Calls ``MIDIIOObject/imageFileURL-6ltjy`` and attempts to initialize a new `UIImage`.
    /// (`kMIDIPropertyImage`)
    ///
    /// - Throws: ``MIDIIOError``
    var imageAsUIImage: UIImage? { get throws }
    #endif
    
    /// The user-visible name for an endpoint that combines the device and endpoint names.
    /// (Apple-recommended user-visible name)
    /// (`kMIDIPropertyDisplayName`)
    ///
    /// For objects other than endpoints, the display name is the same as its `kMIDIPropertyName`
    /// value.
    ///
    /// - Throws: ``MIDIIOError``
    var displayName: String { get } // cached by the concrete object
    
    // MARK: Audio
    
    /// Boolean value that indicates whether the MIDI pan messages sent to the device or
    /// entity cause undesirable effects when playing stereo sounds.
    /// (`kMIDIPropertyPanDisruptsStereo`)
    ///
    /// - Throws: ``MIDIIOError``
    var panDisruptsStereo: Bool { get throws }
    
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
    ///
    /// - Throws: ``MIDIIOError``
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    var protocolID: MIDIProtocolVersion? { get throws }
    
    // MARK: Timing
    
    /// Boolean value that indicates whether the device or entity transmits MIDI Time Code
    /// messages.
    /// (`kMIDIPropertyTransmitsMTC`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsMTC: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Time Code
    /// messages.
    /// (`kMIDIPropertyReceivesMTC`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesMTC: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI beat clock
    /// messages.
    /// (`kMIDIPropertyTransmitsClock`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsClock: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI beat clock
    /// messages.
    /// (`kMIDIPropertyReceivesClock`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesClock: Bool { get throws }
    
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
    ///
    /// - Throws: ``MIDIIOError``
    var advanceScheduleTimeMuSec: String { get throws }
    
    // MARK: Roles
    
    /// Boolean value that indicates whether the device or entity mixes external audio
    /// signals.
    /// (`kMIDIPropertyIsMixer`)
    ///
    /// - Throws: ``MIDIIOError``
    var isMixer: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity plays audio samples in
    /// response to MIDI note messages.
    /// (`kMIDIPropertyIsSampler`)
    ///
    /// - Throws: ``MIDIIOError``
    var isSampler: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity primarily acts as a
    /// MIDI-controlled audio effect.
    /// (`kMIDIPropertyIsEffectUnit`)
    var isEffectUnit: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity’s samples aren’t
    /// transposable, as with a drum kit.
    /// (`kMIDIPropertyIsDrumMachine`)
    ///
    /// - Throws: ``MIDIIOError``
    var isDrumMachine: Bool { get throws }
    
    // MARK: Status
    
    /// Boolean value that indicates whether the object is offline.
    /// (`kMIDIPropertyOffline`)
    ///
    /// - `true` indicates the device is temporarily absent and offline.
    /// - `false` indicates the object is present.
    ///
    /// - Throws: ``MIDIIOError``
    var isOffline: Bool { get throws }
    
    /// Boolean value that indicates whether the system hides an endpoint from other clients.
    /// (`kMIDIPropertyPrivate`)
    ///
    /// You can set this property on a device or entity, but it still appears in the API; the system
    /// only hides the object’s owned endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    var isPrivate: Bool { get throws }
    
    // MARK: Drivers
    
    /// Name of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverOwner`)
    ///
    /// Set by the owning driver, on the device; should not be touched by other clients. Property is
    /// inherited by entities and endpoints from their owning device.
    ///
    /// - Throws: ``MIDIIOError``
    var driverOwner: String { get throws }
    
    /// Version of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverVersion`)
    ///
    /// - Throws: ``MIDIIOError``
    var driverVersion: Int32 { get throws }
    
    // MARK: Connections
    
    /// Boolean value that indicates whether the device or entity can route messages to or
    /// from external MIDI devices.
    /// (`kMIDIPropertyCanRoute`)
    ///
    /// Don’t set this property value on driver-owned devices.
    ///
    /// - Throws: ``MIDIIOError``
    var canRoute: Bool { get throws }
    
    /// Boolean value that indicates whether the endpoint broadcasts messages to all of the
    /// other endpoints in the device.
    /// (`kMIDIPropertyIsBroadcast`)
    ///
    /// Only the owning driver may set this property.
    ///
    /// - Throws: ``MIDIIOError``
    var isBroadcast: Bool { get throws }
    
    /// Unique identifier of an external device attached to this connection.
    /// (`kMIDIPropertyConnectionUniqueID`)
    ///
    /// The value provided may be an integer. To indicate that a driver connects to multiple
    /// external objects, pass the array of big-endian SInt32 values as a CFData object.
    ///
    /// The property is nonexistent or 0 if there’s no connection.
    ///
    /// - Throws: ``MIDIIOError``
    var connectionUniqueID: MIDIIdentifier { get throws }
    
    /// Boolean value that indicates whether this entity or endpoint has external MIDI
    /// connections.
    /// (`kMIDIPropertyIsEmbeddedEntity`)
    ///
    /// - Throws: ``MIDIIOError``
    var isEmbeddedEntity: Bool { get throws }
    
    /// 0-based index of the entity on which incoming real-time messages from the device
    /// appear to have originated.
    /// (`kMIDIPropertySingleRealtimeEntity`)
    ///
    /// - Throws: ``MIDIIOError``
    var singleRealtimeEntity: Int32 { get throws }
    
    // MARK: Channels
    
    /// Bitmap of channels on which the object receives messages.
    /// (`kMIDIPropertyReceiveChannels`)
    ///
    /// You can use this property in the following scenarios:
    /// - Drivers can set this property on their entities and endpoints.
    /// - Studio setup editors can allow the user to set this property on external endpoints.
    /// - Virtual destinations can set this property on their endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    var receiveChannels: Int32 { get throws }
    
    /// Bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyTransmitChannels`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitChannels: Int32 { get throws }
    
    /// Bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyMaxReceiveChannels`)
    ///
    /// - Throws: ``MIDIIOError``
    var maxReceiveChannels: Int32 { get throws }
    
    /// Maximum number of MIDI channels on which a device may simultaneously transmit
    /// channel messages.
    /// (`kMIDIPropertyMaxTransmitChannels`)
    ///
    /// Common values are 0, 1, or 16.
    ///
    /// - Throws: ``MIDIIOError``
    var maxTransmitChannels: Int32 { get throws }
    
    // MARK: Banks
    
    /// Boolean value that indicates whether the device or entity responds to MIDI bank select
    /// LSB messages.
    /// (`kMIDIPropertyReceivesBankSelectLSB`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesBankSelectLSB: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI bank select
    /// MSB messages.
    /// (`kMIDIPropertyReceivesBankSelectMSB`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesBankSelectMSB: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI bank select
    /// LSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectLSB`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsBankSelectLSB: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI bank select
    /// MSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectMSB`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsBankSelectMSB: Bool { get throws }
    
    // MARK: Notes
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Note On
    /// messages.
    /// (`kMIDIPropertyReceivesNotes`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesNotes: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI note
    /// messages.
    /// (`kMIDIPropertyTransmitsNotes`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsNotes: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity responds to MIDI Program
    /// Change messages.
    /// (`kMIDIPropertyReceivesProgramChanges`)
    ///
    /// - Throws: ``MIDIIOError``
    var receivesProgramChanges: Bool { get throws }
    
    /// Boolean value that indicates whether the device or entity transmits MIDI Program
    /// Change messages.
    /// (`kMIDIPropertyTransmitsProgramChanges`)
    ///
    /// - Throws: ``MIDIIOError``
    var transmitsProgramChanges: Bool { get throws }
    
    // MARK: - MIDIIOObject Properties Dictionary.swift
    
    /// Get all properties as a key/value pair array, formatted as human-readable strings.
    /// Useful for displaying in a user interface or outputting to console for debugging.
    /// The return value is an array of tuples (not a dictionary) to maintain ordering.
    /// Not recommended for production code. Instead, use strongly-typed properties on this object.
    func propertyStringValues(
        relevantOnly: Bool
    ) -> [(key: String, value: String)]
    
    /// Get a property value formatted as a human-readable string.
    /// Useful for displaying in a user interface or outputting to console for debugging.
    /// Not recommended for production code. Instead, use strongly-typed properties on this object.
    ///
    /// - Throws: ``MIDIIOError``
    func propertyStringValue(
        for property: AnyMIDIIOObject.Property
    ) throws -> String
}

#endif
