//
//  MIDIIOObjectProtocol Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

// MARK: - Properties (Computed)

extension MIDIIOObject {
    // MARK: Identification
    
    /// Get user-visible endpoint name.
    /// (`kMIDIPropertyName`)
    ///
    /// Devices, entities, and endpoints may all have names. The standard way to display an endpoint’s name is to ask it for its name and display it only if unique. If not, prepend the device name.
    ///
    /// A studio setup editor may allow the user to set the names of both driver-owned and external devices.
    ///
    /// - Throws: ``MIDIIOError``
    public func getName() -> String? {
        try? MIDIKitIO.getName(of: coreMIDIObjectRef)
    }
    
    /// Get model name.
    /// (`kMIDIPropertyModel`)
    ///
    /// Use this property in the following scenarios:
    /// - MIDI drivers should set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    public func getModel() -> String? {
        try? MIDIKitIO.getModel(of: coreMIDIObjectRef)
    }
    
    /// Get manufacturer name.
    /// (`kMIDIPropertyManufacturer`)
    ///
    /// Use this property in the following cases:
    /// - MIDI drivers set this property on their devices.
    /// - Studio setup editors may allow the user to set this property on external devices.
    /// - Creators of virtual endpoints may set this property on their endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    public func getManufacturer() -> String? {
        try? MIDIKitIO.getManufacturer(of: coreMIDIObjectRef)
    }
    
    /// Get unique ID.
    /// (`kMIDIPropertyUniqueID`)
    ///
    /// The system assigns unique IDs to all objects.  Creators of virtual endpoints may set this property on their endpoints, though doing so may fail if the chosen ID is not unique.
    public func getUniqueID() -> MIDIIdentifier {
        MIDIIdentifier(MIDIKitIO.getUniqueID(of: coreMIDIObjectRef))
    }
    
    /// Get the user-visible System Exclusive (SysEx) identifier of a device or entity.
    /// (`kMIDIPropertyDeviceID`)
    ///
    /// MIDI drivers can set this property on their devices or entities. Studio setup editors can allow the user to set this property on external devices.
    public func getDeviceManufacturerID() -> Int32 {
        MIDIKitIO.getDeviceManufacturerID(of: coreMIDIObjectRef)
    }
    
    // MARK: Capabilities
    
    /// Get a Boolean value that indicates whether the device or entity implements the MIDI Machine Control portion of the MIDI specification.
    /// (`kMIDIPropertySupportsMMC`)
    public func getSupportsMMC() -> Bool {
        MIDIKitIO.getSupportsMMC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity implements the General MIDI specification.
    /// (`kMIDIPropertySupportsGeneralMIDI`)
    public func getSupportsGeneralMIDI() -> Bool {
        MIDIKitIO.getSupportsGeneralMIDI(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device implements the MIDI Show Control specification.
    /// (`kMIDIPropertySupportsShowControl`)
    public func getSupportsShowControl() -> Bool {
        MIDIKitIO.getSupportsShowControl(of: coreMIDIObjectRef)
    }
    
    // MARK: Configuration
    
    /// Get the device’s current patch, note, and control name values in MIDINameDocument XML format.
    /// (`kMIDIPropertyNameConfigurationDictionary`)
    ///
    /// - Requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    public func getNameConfigurationDictionary() -> NSDictionary? {
        try? MIDIKitIO.getNameConfigurationDictionary(of: coreMIDIObjectRef)
    }
    
    /// Get the maximum rate, in bytes per second, at which the system may reliably send System Exclusive (SysEx) messages to this object.
    /// (`kMIDIPropertyMaxSysExSpeed`)
    ///
    /// The owning driver may set an integer value for this property.
    public func getMaxSysExSpeed() -> Int32 {
        MIDIKitIO.getMaxSysExSpeed(of: coreMIDIObjectRef)
    }
    
    /// Get the full path to an app on the system that configures driver-owned devices.
    /// (`kMIDIPropertyDriverDeviceEditorApp`)
    ///
    /// Only drivers may set this property on their owned devices.
    ///
    /// - Throws: ``MIDIIOError``
    public func getDriverDeviceEditorApp() -> URL? {
        try? MIDIKitIO.getDriverDeviceEditorApp(of: coreMIDIObjectRef)
    }
    
    // MARK: Presentation
    
    /// Get the full path to a device icon on the system.
    /// (`kMIDIPropertyImage`)
    ///
    /// You can provide an image stored in any standard graphic file format, such as JPEG, GIF, or PNG. The maximum size for this image is 128 by 128 pixels.
    ///
    /// A studio setup editor should allow the user to choose icons for external devices.
    ///
    /// - Throws: ``MIDIIOError``
    public func getImageFileURL() -> URL? {
        try? MIDIKitIO.getImage(of: coreMIDIObjectRef)
    }
    
    #if canImport(AppKit) && os(macOS)
    /// Calls `getImageFileURL` and attempts to initialize a new `NSImage`.
    public func getImageAsNSImage() -> NSImage? {
        guard let url = getImageFileURL() else { return nil }
        return NSImage(contentsOf: url)
    }
    #endif
    
    #if canImport(UIKit)
    /// Calls `getImageFileURL` and attempts to initialize a new `UIImage`.
    public func getImageAsUIImage() -> UIImage? {
        guard let url = getImageFileURL(),
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
    /// - Throws: ``MIDIIOError``
    public func getDisplayName() -> String? {
        try? MIDIKitIO.getDisplayName(of: coreMIDIObjectRef)
    }
    
    // MARK: Audio
    
    /// Get a Boolean value that indicates whether the MIDI pan messages sent to the device or entity cause undesirable effects when playing stereo sounds.
    /// (`kMIDIPropertyPanDisruptsStereo`)
    public func getPanDisruptsStereo() -> Bool {
        MIDIKitIO.getPanDisruptsStereo(of: coreMIDIObjectRef)
    }
    
    // MARK: Protocols
    
    /// Get the native protocol in which the endpoint communicates.
    /// (`kMIDIPropertyProtocolID`)
    ///
    /// The system sets this value on endpoints when it creates them. Drivers can dynamically change the endpoint’s protocol as a result of a MIDI-CI negotiation, by setting this property.
    ///
    /// Clients can observe changes to this property.
    ///
    /// - Requires: macOS 11.0, macCatalyst 14.0, iOS 14.0
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    public func getProtocolID() -> MIDIProtocolVersion? {
        guard let proto = MIDIKitIO.getProtocolID(of: coreMIDIObjectRef) else { return nil }
        return .init(proto)
    }
    
    // MARK: Timing
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Time Code messages.
    /// (`kMIDIPropertyTransmitsMTC`)
    public func getTransmitsMTC() -> Bool {
        MIDIKitIO.getTransmitsMTC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Time Code messages.
    /// (`kMIDIPropertyReceivesMTC`)
    public func getReceivesMTC() -> Bool {
        MIDIKitIO.getReceivesMTC(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI beat clock messages.
    /// (`kMIDIPropertyTransmitsClock`)
    public func getTransmitsClock() -> Bool {
        MIDIKitIO.getTransmitsClock(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI beat clock messages.
    /// (`kMIDIPropertyReceivesClock`)
    public func getReceivesClock() -> Bool {
        MIDIKitIO.getReceivesClock(of: coreMIDIObjectRef)
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
    /// - Throws: ``MIDIIOError``
    public func getAdvanceScheduleTimeMuSec() -> String? {
        try? MIDIKitIO.getAdvanceScheduleTimeMuSec(of: coreMIDIObjectRef)
    }
    
    // MARK: Roles
    
    /// Get a Boolean value that indicates whether the device or entity mixes external audio signals.
    /// (`kMIDIPropertyIsMixer`)
    public func getIsMixer() -> Bool {
        MIDIKitIO.getIsMixer(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity plays audio samples in response to MIDI note messages.
    /// (`kMIDIPropertyIsSampler`)
    public func getIsSampler() -> Bool {
        MIDIKitIO.getIsSampler(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity primarily acts as a MIDI-controlled audio effect.
    /// (`kMIDIPropertyIsEffectUnit`)
    public func getIsEffectUnit() -> Bool {
        MIDIKitIO.getIsEffectUnit(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity’s samples aren’t transposable, as with a drum kit.
    /// (`kMIDIPropertyIsDrumMachine`)
    public func getIsDrumMachine() -> Bool {
        MIDIKitIO.getIsDrumMachine(of: coreMIDIObjectRef)
    }
    
    // MARK: Status
    
    /// Get a Boolean value that indicates whether the object is offline.
    ///
    /// `true` indicates the device is temporarily absent and offline.
    /// `false` indicates the object is present.
    ///
    /// (`kMIDIPropertyOffline`)
    public func getIsOffline() -> Bool {
        MIDIKitIO.getIsOffline(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the system hides an endpoint from other clients.
    ///
    /// You can set this property on a device or entity, but it still appears in the API; the system only hides the object’s owned endpoints.
    ///
    /// (`kMIDIPropertyPrivate`)
    public func getIsPrivate() -> Bool {
        MIDIKitIO.getIsPrivate(of: coreMIDIObjectRef)
    }
    
    // MARK: Drivers
    
    /// Get name of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverOwner`)
    ///
    /// Set by the owning driver, on the device; should not be touched by other clients. Property is inherited from the device by its entities and endpoints.
    ///
    /// - Throws: ``MIDIIOError``
    public func getDriverOwner() -> String? {
        try? MIDIKitIO.getDriverOwner(of: coreMIDIObjectRef)
    }
    
    /// Get the version of the driver that owns a device, entity, or endpoint.
    /// (`kMIDIPropertyDriverVersion`)
    public func getDriverVersion() -> Int32 {
        MIDIKitIO.getDriverVersion(of: coreMIDIObjectRef)
    }
    
    // MARK: Connections
    
    /// Get a Boolean value that indicates whether the device or entity can route messages to or from external MIDI devices.
    /// (`kMIDIPropertyCanRoute`)
    ///
    /// Don’t set this property value on driver-owned devices.
    public func getCanRoute() -> Bool {
        MIDIKitIO.getCanRoute(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the endpoint broadcasts messages to all of the other endpoints in the device.
    /// (`kMIDIPropertyIsBroadcast`)
    ///
    /// Only the owning driver may set this property.
    public func getIsBroadcast() -> Bool {
        MIDIKitIO.getIsBroadcast(of: coreMIDIObjectRef)
    }
    
    /// Get the unique identifier of an external device attached to this connection.
    /// (`kMIDIPropertyConnectionUniqueID`)
    ///
    /// The value provided may be an integer. To indicate that a driver connects to multiple external objects, pass the array of big-endian SInt32 values as a CFData object.
    ///
    /// The property is nonexistent or 0 if there’s no connection.
    public func getConnectionUniqueID() -> MIDIIdentifier {
        MIDIKitIO.getConnectionUniqueID(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether this entity or endpoint has external MIDI connections.
    /// (`kMIDIPropertyIsEmbeddedEntity`)
    public func getIsEmbeddedEntity() -> Bool {
        MIDIKitIO.getIsEmbeddedEntity(of: coreMIDIObjectRef)
    }
    
    /// Get the 0-based index of the entity on which incoming real-time messages from the device appear to have originated.
    /// (`kMIDIPropertySingleRealtimeEntity`)
    public func getSingleRealtimeEntity() -> Int32 {
        MIDIKitIO.getSingleRealtimeEntity(of: coreMIDIObjectRef)
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
    public func getReceiveChannels() -> Int32 {
        MIDIKitIO.getReceiveChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyTransmitChannels`)
    public func getTransmitChannels() -> Int32 {
        MIDIKitIO.getTransmitChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the bitmap of channels on which the object transmits messages.
    /// (`kMIDIPropertyMaxReceiveChannels`)
    public func getMaxReceiveChannels() -> Int32 {
        MIDIKitIO.getMaxReceiveChannels(of: coreMIDIObjectRef)
    }
    
    /// Get the maximum number of MIDI channels on which a device may simultaneously transmit channel messages.
    /// (`kMIDIPropertyMaxTransmitChannels`)
    ///
    /// Common values are 0, 1, or 16.
    public func getMaxTransmitChannels() -> Int32 {
        MIDIKitIO.getMaxTransmitChannels(of: coreMIDIObjectRef)
    }
    
    // MARK: Banks
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select LSB messages.
    /// (`kMIDIPropertyReceivesBankSelectLSB`)
    public func getReceivesBankSelectLSB() -> Bool {
        MIDIKitIO.getReceivesBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select MSB messages.
    /// (`kMIDIPropertyReceivesBankSelectMSB`)
    public func getReceivesBankSelectMSB() -> Bool {
        MIDIKitIO.getReceivesBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select LSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectLSB`)
    public func getTransmitsBankSelectLSB() -> Bool {
        MIDIKitIO.getTransmitsBankSelectLSB(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select MSB messages.
    /// (`kMIDIPropertyTransmitsBankSelectMSB`)
    public func getTransmitsBankSelectMSB() -> Bool {
        MIDIKitIO.getTransmitsBankSelectMSB(of: coreMIDIObjectRef)
    }
    
    // MARK: Notes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Note On messages.
    /// (`kMIDIPropertyReceivesNotes`)
    public func getReceivesNotes() -> Bool {
        MIDIKitIO.getReceivesNotes(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI note messages.
    /// (`kMIDIPropertyTransmitsNotes`)
    public func getTransmitsNotes() -> Bool {
        MIDIKitIO.getTransmitsNotes(of: coreMIDIObjectRef)
    }
    
    // MARK: Program Changes
    
    /// Get a Boolean value that indicates whether the device or entity responds to MIDI Program Change messages.
    /// (`kMIDIPropertyReceivesProgramChanges`)
    public func getReceivesProgramChanges() -> Bool {
        MIDIKitIO.getReceivesProgramChanges(of: coreMIDIObjectRef)
    }
    
    /// Get a Boolean value that indicates whether the device or entity transmits MIDI Program Change messages.
    /// (`kMIDIPropertyTransmitsProgramChanges`)
    public func getTransmitsProgramChanges() -> Bool {
        MIDIKitIO.getTransmitsProgramChanges(of: coreMIDIObjectRef)
    }
}

#endif
