//
//  MIDIIOObjectProtocol Properties.swift
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

// MARK: - Properties (Computed)

extension MIDIIOObjectProtocol {
    
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
        try? MIDI.IO.getName(of: coreMIDIObjectRef)
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
        try? MIDI.IO.getModel(of: coreMIDIObjectRef)
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
        try? MIDI.IO.getManufacturer(of: coreMIDIObjectRef)
    }
    
    /// Get unique ID.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
    public var getUniqueID: UniqueID {
        UniqueID(MIDI.IO.getUniqueID(of: coreMIDIObjectRef))
    }
    
    /// Get the user-visible System Exclusive (SysEx) identifier of a device or entity.
    /// (`kMIDIPropertyDeviceID`)
    ///
    /// MIDI drivers can set this property on their devices or entities. Studio setup editors can allow the user to set this property on external devices.
    public var getDeviceManufacturerID: Int32 {
        MIDI.IO.getDeviceManufacturerID(of: coreMIDIObjectRef)
    }
    
    // MARK: Capabilities
    
    /// Get a Boolean value that indicates whether the device or entity implements the MIDI Machine Control portion of the MIDI specification.
    /// (`kMIDIPropertySupportsMMC`)
    public var getSupportsMMC: Bool {
        MIDI.IO.getSupportsMMC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity implements the General MIDI specification.
    /// (`kMIDIPropertySupportsGeneralMIDI`)
    public var getSupportsGeneralMIDI: Bool {
        MIDI.IO.getSupportsGeneralMIDI(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device implements the MIDI Show Control specification.
    /// (`kMIDIPropertySupportsShowControl`)
    public var getSupportsShowControl: Bool {
        MIDI.IO.getSupportsShowControl(of: coreMIDIObjectRef)
    }
    
    // MARK: Configuration
    
    /// Get the device’s current patch, note, and control name values in MIDINameDocument XML format.
    /// (`kMIDIPropertyNameConfigurationDictionary`)
    ///
    /// - requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public var getNameConfigurationDictionary: NSDictionary? {
        try? MIDI.IO.getNameConfigurationDictionary(of: coreMIDIObjectRef)
    }
    
    /// Get the maximum rate, in bytes per second, at which the system may reliably send System Exclusive (SysEx) messages to this object.
    /// (`kMIDIPropertyMaxSysExSpeed`)
    ///
    /// The owning driver may set an integer value for this property.
    public var getMaxSysExSpeed: Int32 {
        MIDI.IO.getMaxSysExSpeed(of: coreMIDIObjectRef)
    }
    
    /// Get the full path to an app on the system that configures driver-owned devices.
    /// (`kMIDIPropertyDriverDeviceEditorApp`)
    ///
    /// Only drivers may set this property on their owned devices.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getDriverDeviceEditorApp: URL? {
        try? MIDI.IO.getDriverDeviceEditorApp(of: coreMIDIObjectRef)
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
        try? MIDI.IO.getImage(of: coreMIDIObjectRef)
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
        try? MIDI.IO.getDisplayName(of: coreMIDIObjectRef)
    }
    
    // MARK: Audio
    
    /// Get a Boolean value that indicates whether the MIDI pan messages sent to the device or entity cause undesirable effects when playing stereo sounds.
    /// (`kMIDIPropertyPanDisruptsStereo`)
    public var getPanDisruptsStereo: Bool {
        MIDI.IO.getPanDisruptsStereo(of: coreMIDIObjectRef)
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
        MIDI.IO.getProtocolID(of: coreMIDIObjectRef)
    }
    
    // MARK: Timing
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Time Code messages.
    /// (`kMIDIPropertyTransmitsMTC`)
    public var getTransmitsMTC: Bool {
        MIDI.IO.getTransmitsMTC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Time Code messages.
    /// (`kMIDIPropertyReceivesMTC`)
    public var getReceivesMTC: Bool {
        MIDI.IO.getReceivesMTC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI beat clock messages.
    /// (`kMIDIPropertyTransmitsClock`)
    public var getTransmitsClock: Bool {
        MIDI.IO.getTransmitsClock(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI beat clock messages.
    /// (`kMIDIPropertyReceivesClock`)
    public var getReceivesClock: Bool {
        MIDI.IO.getReceivesClock(of: coreMIDIObjectRef)
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
        try? MIDI.IO.getAdvanceScheduleTimeMuSec(of: coreMIDIObjectRef)
    }
    
    // MARK: Roles
    
    /// Get a Boolean value that indicates whether the device or entity mixes external audio signals.
    /// (`kMIDIPropertyIsMixer`)
    public var getIsMixer: Bool {
        MIDI.IO.getIsMixer(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity plays audio samples in response to MIDI note messages.
    /// (`kMIDIPropertyIsSampler`)
    public var getIsSampler: Bool {
        MIDI.IO.getIsSampler(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity primarily acts as a MIDI-controlled audio effect.
    /// (`kMIDIPropertyIsEffectUnit`)
    public var getIsEffectUnit: Bool {
        MIDI.IO.getIsEffectUnit(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity’s samples aren’t transposable, as with a drum kit.
    /// (`kMIDIPropertyIsDrumMachine`)
    public var getIsDrumMachine: Bool {
        MIDI.IO.getIsDrumMachine(of: coreMIDIObjectRef)
    }
    
    // MARK: Status
    
    /// Get a Boolean value that indicates whether the object is offline.
    ///
    /// `True` indicates the device is temporarily absent and offline.
    /// `False` indicates the object is present.
    ///
    /// (`kMIDIPropertyOffline`)
    public var getIsOffline: Bool {
        MIDI.IO.getIsOffline(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the system hides an endpoint from other clients.
    ///
    /// You can set this property on a device or entity, but it still appears in the API; the system only hides the object’s owned endpoints.
    ///
    /// (`kMIDIPropertyPrivate`)
    public var getIsPrivate: Bool {
        MIDI.IO.getIsPrivate(of: coreMIDIObjectRef)
    }
    
    // MARK: Drivers
    
    /// Get name of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverOwner`)
    ///
    /// Set by the owning driver, on the device; should not be touched by other clients. Property is inherited from the device by its entities and endpoints.
    ///
    /// - Throws: `MIDI.IO.MIDIError`
    public var getDriverOwner: String? {
        try? MIDI.IO.getDriverOwner(of: coreMIDIObjectRef)
    }
    
    /// Get the version of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverVersion`)
    public var getDriverVersion: Int32 {
        MIDI.IO.getDriverVersion(of: coreMIDIObjectRef)
    }
    
    // MARK: Connections
    
    /// Get a Boolean value that indicates whether the device or entity can route messages to or from external MIDI devices.
    /// (`kMIDIPropertyCanRoute`)
    ///
    /// Don’t set this property value on driver-owned devices.
    public var getCanRoute: Bool {
        MIDI.IO.getCanRoute(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the endpoint broadcasts messages to all of the other endpoints in the device.
    /// (`kMIDIPropertyIsBroadcast`)
    ///
    /// Only the owning driver may set this property.
    public var getIsBroadcast: Bool {
        MIDI.IO.getIsBroadcast(of: coreMIDIObjectRef)
    }
    
    /// Get the unique identifier of an external device attached to this connection.
    /// (`kMIDIPropertyConnectionUniqueID`)
    ///
    /// The value provided may be an integer. To indicate that a driver connects to multiple external objects, pass the array of big-endian SInt32 values as a CFData object.
    ///
    /// The property is nonexistent or 0 if there’s no connection.
    public var getConnectionUniqueID: MIDIUniqueID {
        MIDI.IO.getConnectionUniqueID(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether this entity or endpoint has external MIDI connections.
    /// (`kMIDIPropertyIsEmbeddedEntity`)
    public var getIsEmbeddedEntity: Bool {
        MIDI.IO.getIsEmbeddedEntity(of: coreMIDIObjectRef)
    }
    
    /// Get the 0-based index of the entity on which incoming real-time messages from the device appear to have originated.
    /// (`kMIDIPropertySingleRealtimeEntity`)
    public var getSingleRealtimeEntity: Int32 {
        MIDI.IO.getSingleRealtimeEntity(of: coreMIDIObjectRef)
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
        MIDI.IO.getReceiveChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyTransmitChannels`)
    public var getTransmitChannels: Int32 {
        MIDI.IO.getTransmitChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyMaxReceiveChannels`)
    public var getMaxReceiveChannels: Int32 {
        MIDI.IO.getMaxReceiveChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the maximum number of MIDI channels on which a device may simultaneously transmit channel messages.
    /// (`kMIDIPropertyMaxTransmitChannels`)
    ///
    /// Common values are 0, 1, or 16.
    public var getMaxTransmitChannels: Int32 {
        MIDI.IO.getMaxTransmitChannels(of: coreMIDIObjectRef)
    }
    
    // MARK: Banks
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select LSB messages.
    /// (`kMIDIPropertyReceivesBankSelectLSB`)
    public var getReceivesBankSelectLSB: Bool {
        MIDI.IO.getReceivesBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select MSB messages.
    /// (`kMIDIPropertyReceivesBankSelectMSB`)
    public var getReceivesBankSelectMSB: Bool {
        MIDI.IO.getReceivesBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select LSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectLSB`)
    public var getTransmitsBankSelectLSB: Bool {
        MIDI.IO.getTransmitsBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select MSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectMSB`)
    public var getTransmitsBankSelectMSB: Bool {
        MIDI.IO.getTransmitsBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    // MARK: Notes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Note On messages.
    /// (`kMIDIPropertyReceivesNotes`)
    public var getReceivesNotes: Bool {
        MIDI.IO.getReceivesNotes(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI note messages.
    /// (`kMIDIPropertyTransmitsNotes`)
    public var getTransmitsNotes: Bool {
        MIDI.IO.getTransmitsNotes(of: coreMIDIObjectRef)
    }
    
    // MARK: Program Changes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Program Change messages.
    /// (`kMIDIPropertyReceivesProgramChanges`)
    public var getReceivesProgramChanges: Bool {
        MIDI.IO.getReceivesProgramChanges(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Program Change messages.
    /// (`kMIDIPropertyTransmitsProgramChanges`)
    public var getTransmitsProgramChanges: Bool {
        MIDI.IO.getTransmitsProgramChanges(of: coreMIDIObjectRef)
    }
    
}
