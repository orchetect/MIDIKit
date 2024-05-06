//
//  Core MIDI Properties Get.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

// MARK: - Property Readers
    
/// Internal:
/// Retrieves the entire properties dictionary as the Core MIDI-native `CFPropertyList`.
///
/// - Parameters:
///   - ref: Core MIDI object ref (`MIDIObjectRef`)
///   - deep: Returns nested results for all children if `true`.
///
/// - Throws: ``MIDIIOError``
func getProperties(
    of ref: CoreMIDI.MIDIObjectRef,
    deep: Bool = false
) throws -> CFPropertyList {
    var props: Unmanaged<CFPropertyList>?
    let result = MIDIObjectGetProperties(ref, &props, deep)
    
    guard result == noErr else {
        throw MIDIIOError.osStatus(result)
    }
    
    guard let unwrappedProps = props?.takeRetainedValue() else {
        throw MIDIIOError.readError(
            "Got nil while reading MIDIEndpointRef property list."
        )
    }
    
    // "takeRetainedValue() is the right choice here because it is the caller's responsibility to
    // release the string.
    // This is different from the usual Core Foundation memory management rules, but documented in
    // the MIDI Services Reference."
    // -- https://stackoverflow.com/a/27171498/2805570
    
    return unwrappedProps
}
    
/// Internal:
/// Returns dictionary data for the given property.
///
/// - Parameters:
///   - forProperty: a `CoreMIDI.Property` constant
///   - ref: Core MIDI object ref (`MIDIObjectRef`)
///
/// - Throws: ``MIDIIOError``
func getDictionary(
    forProperty property: CFString,
    of ref: CoreMIDI.MIDIObjectRef
) throws -> NSDictionary {
    var dict: Unmanaged<CFDictionary>?
    let result = MIDIObjectGetDictionaryProperty(ref, property, &dict)
    
    guard result == noErr else {
        throw MIDIIOError.osStatus(result)
    }
    
    guard let unwrappedDict = dict?.takeRetainedValue() else {
        throw MIDIIOError.readError(
            "Got nil while reading MIDIEndpointRef property list."
        )
    }
    
    // "takeRetainedValue() is the right choice here because it is the caller's responsibility to
    // release the string.
    // This is different from the usual Core Foundation memory management rules, but documented in
    // the MIDI Services Reference."
    // -- https://stackoverflow.com/a/27171498/2805570
    
    return unwrappedDict as NSDictionary
}
    
/// Internal:
/// Get a string value from a `MIDIObjectRef` property key.
///
/// - Parameters:
///   - forProperty: a `CoreMIDI.Property` constant
///   - ref: Core MIDI object ref (`MIDIObjectRef`)
///
/// - Throws: ``MIDIIOError``
func getString(
    forProperty property: CFString,
    of ref: CoreMIDI.MIDIObjectRef
) throws -> String {
    var val: Unmanaged<CFString>?
    let result = MIDIObjectGetStringProperty(ref, property, &val)
    
    guard result == noErr else {
        throw MIDIIOError.osStatus(result)
    }
    
    guard let unwrappedVal = val?.takeRetainedValue() else {
        throw MIDIIOError.readError(
            "Got nil while reading MIDIEndpointRef property value \((property as String).quoted)"
        )
    }
    
    // "takeRetainedValue() is the right choice here because it is the caller's responsibility to
    // release the string.
    // This is different from the usual Core Foundation memory management rules, but documented in
    // the MIDI Services Reference."
    // -- https://stackoverflow.com/a/27171498/2805570
    
    return unwrappedVal as String
}
    
/// Internal:
/// Get an integer value from a `MIDIObjectRef` property key.
///
/// - Parameter forProperty: a `CoreMIDI.Property` constant
func getInteger(
    forProperty property: CFString,
    of ref: CoreMIDI.MIDIObjectRef
) -> Int32 {
    var val: Int32 = 0
    // TODO: handle OSStatus errors?
    _ = MIDIObjectGetIntegerProperty(ref, property, &val)
    return val
}

// MARK: - Property Getters

// MARK: Identification
    
/// Get user-visible endpoint name.
/// (`kMIDIPropertyName`)
///
/// Devices, entities, and endpoints may all have names. The standard way to display an endpoint’s
/// name is to ask it for its name and display it only if unique. If not, prepend the device name.
///
/// A studio setup editor may allow the user to set the names of both driver-owned and external
/// devices.
///
/// - Throws: ``MIDIIOError``
func getName(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyName, of: ref)
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
func getModel(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyModel, of: ref)
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
func getManufacturer(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyManufacturer, of: ref)
}
    
/// Get unique ID.
/// (`kMIDIPropertyUniqueID`)
///
/// The system assigns unique IDs to all objects. Creators of virtual endpoints may set this
/// property on their endpoints, though doing so may fail if the chosen ID is not unique.
func getUniqueID(of ref: CoreMIDI.MIDIObjectRef) -> MIDIUniqueID {
    getInteger(forProperty: kMIDIPropertyUniqueID, of: ref)
}
    
/// Get the user-visible System Exclusive (SysEx) identifier of a device or entity.
/// (`kMIDIPropertyDeviceID`)
///
/// MIDI drivers can set this property on their devices or entities. Studio setup editors can allow
/// the user to set this property on external devices.
func getDeviceManufacturerID(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyDeviceID, of: ref)
}
    
// MARK: Capabilities
    
/// Get a Boolean value that indicates whether the device or entity implements the MIDI Machine
/// Control portion of the MIDI specification.
/// (`kMIDIPropertySupportsMMC`)
func getSupportsMMC(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertySupportsMMC, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity implements the General MIDI
/// specification.
/// (`kMIDIPropertySupportsGeneralMIDI`)
func getSupportsGeneralMIDI(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertySupportsGeneralMIDI, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device implements the MIDI Show Control
/// specification.
/// (`kMIDIPropertySupportsShowControl`)
func getSupportsShowControl(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertySupportsShowControl, of: ref) == 1
}
    
// MARK: Configuration
    
/// Get the device’s current patch, note, and control name values in MIDINameDocument XML format.
/// (`kMIDIPropertyNameConfigurationDictionary`)
///
/// - Requires: macOS 10.15, macCatalyst 13.0, iOS 13.0
@available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
func getNameConfigurationDictionary(
    of ref: CoreMIDI.MIDIObjectRef
) throws -> NSDictionary {
    try getDictionary(forProperty: kMIDIPropertyNameConfigurationDictionary, of: ref)
}
    
/// Get the maximum rate, in bytes per second, at which the system may reliably send System
/// Exclusive (SysEx) messages to this object.
/// (`kMIDIPropertyMaxSysExSpeed`)
///
/// The owning driver may set an integer value for this property.
func getMaxSysExSpeed(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyMaxSysExSpeed, of: ref)
}
    
/// Get the full path to an app on the system that configures driver-owned devices.
/// (`kMIDIPropertyDriverDeviceEditorApp`)
///
/// Only drivers may set this property on their owned devices.
///
/// - Throws: ``MIDIIOError``
func getDriverDeviceEditorApp(of ref: CoreMIDI.MIDIObjectRef) throws -> URL {
    let posixPath = try getString(forProperty: kMIDIPropertyDriverDeviceEditorApp, of: ref)
    return URL(fileURLWithPath: posixPath)
}
    
// MARK: Presentation
    
/// Get the full path to a device icon on the system.
/// (`kMIDIPropertyImage`)
///
/// You can provide an image stored in any standard graphic file format, such as JPEG, GIF, or PNG.
/// The maximum size for this image is 128 by 128 pixels.
///
/// A studio setup editor should allow the user to choose icons for external devices.
///
/// - Throws: ``MIDIIOError``
func getImage(of ref: CoreMIDI.MIDIObjectRef) throws -> URL {
    let posixPath = try getString(forProperty: kMIDIPropertyImage, of: ref)
    return URL(fileURLWithPath: posixPath)
}
    
/// Get The user-visible name for an endpoint that combines the device and endpoint names.
/// (Apple-recommended user-visible name)
/// (`kMIDIPropertyDisplayName`)
///
/// For objects other than endpoints, the display name is (sometimes) the same as its
/// `kMIDIPropertyName` value.
///
/// - Throws: ``MIDIIOError``
func getDisplayName(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyDisplayName, of: ref)
}
    
// MARK: Audio
    
/// Get a Boolean value that indicates whether the MIDI pan messages sent to the device or entity
/// cause undesirable effects when playing stereo sounds.
/// (`kMIDIPropertyPanDisruptsStereo`)
func getPanDisruptsStereo(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyPanDisruptsStereo, of: ref) == 1
}
    
// MARK: Protocols
    
/// Get the native protocol in which the endpoint communicates.
/// (`kMIDIPropertyProtocolID`)
///
/// The system sets this value on endpoints when it creates them. Drivers can dynamically change the
/// endpoint’s protocol as a result of a MIDI-CI negotiation, by setting this property.
///
/// Clients can observe changes to this property.
///
/// - Requires: macOS 11.0, macCatalyst 14.0, iOS 14.0
@available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
func getProtocolID(of ref: CoreMIDI.MIDIObjectRef) -> CoreMIDI.MIDIProtocolID? {
    CoreMIDI.MIDIProtocolID(
        rawValue: getInteger(forProperty: kMIDIPropertyProtocolID, of: ref)
    )
}
    
// MARK: Timing
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI Time Code
/// messages.
/// (`kMIDIPropertyTransmitsMTC`)
func getTransmitsMTC(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsMTC, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI Time Code
/// messages.
/// (`kMIDIPropertyReceivesMTC`)
func getReceivesMTC(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesMTC, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI beat clock
/// messages.
/// (`kMIDIPropertyTransmitsClock`)
func getTransmitsClock(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsClock, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI beat clock
/// messages.
/// (`kMIDIPropertyReceivesClock`)
func getReceivesClock(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesClock, of: ref) == 1
}
    
/// Get the recommended number of microseconds in advance that clients should schedule output.
/// (`kMIDIPropertyAdvanceScheduleTimeMuSec`)
///
/// Only the driver that owns the object may set this property.
///
/// If this property value is nonzero, clients should treat the value as a minimum. For devices with
/// a nonzero advance schedule time, drivers receive outgoing messages to the device at the time the
/// client sends them using `MIDISend(_:_:_:)`. The driver is responsible for scheduling events to
/// play at the right times, according to their timestamps.
///
/// You can also set this property on any virtual destinations you create. When clients send
/// messages to a virtual destination with an advance schedule time of 0, the destination receives
/// the messages at the scheduled delivery time. If a virtual destination has a nonzero advance
/// schedule time, it receives timestamped messages as soon as they’re sent, and must do its own
/// internal scheduling of events it receives.
///
/// - Throws: ``MIDIIOError``
func getAdvanceScheduleTimeMuSec(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyAdvanceScheduleTimeMuSec, of: ref)
}
    
// MARK: Roles
    
/// Get a Boolean value that indicates whether the device or entity mixes external audio signals.
/// (`kMIDIPropertyIsMixer`)
func getIsMixer(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsMixer, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity plays audio samples in response
/// to MIDI note messages.
/// (`kMIDIPropertyIsSampler`)
func getIsSampler(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsSampler, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity primarily acts as a
/// MIDI-controlled audio effect.
/// (`kMIDIPropertyIsEffectUnit`)
func getIsEffectUnit(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsEffectUnit, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity’s samples aren’t transposable,
/// as with a drum kit.
/// (`kMIDIPropertyIsDrumMachine`)
func getIsDrumMachine(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsDrumMachine, of: ref) == 1
}
    
// MARK: Status
    
/// Get a Boolean value that indicates whether the object is offline.
///
/// `true` indicates the device is temporarily absent and offline.
/// `false` indicates the object is present.
///
/// (`kMIDIPropertyOffline`)
func getIsOffline(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyOffline, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the system hides an endpoint from other clients.
///
/// You can set this property on a device or entity, but it still appears in the API; the system
/// only hides the object’s owned endpoints.
///
/// (`kMIDIPropertyPrivate`)
func getIsPrivate(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyPrivate, of: ref) == 1
}
    
// MARK: Drivers
    
/// Get name of the driver that owns a device, entity, or endpoint.
/// (`kMIDIPropertyDriverOwner`)
///
/// Set by the owning driver, on the device; should not be touched by other clients. Property is
/// inherited from the device by its entities and endpoints.
///
/// - Throws: ``MIDIIOError``
func getDriverOwner(of ref: CoreMIDI.MIDIObjectRef) throws -> String {
    try getString(forProperty: kMIDIPropertyDriverOwner, of: ref)
}
    
/// Get the version of the driver that owns a device, entity, or endpoint.
/// (`kMIDIPropertyDriverVersion`)
func getDriverVersion(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyDriverVersion, of: ref)
}
    
// MARK: Connections
    
/// Get a Boolean value that indicates whether the device or entity can route messages to or from
/// external MIDI devices.
/// (`kMIDIPropertyCanRoute`)
///
/// Don’t set this property value on driver-owned devices.
func getCanRoute(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyCanRoute, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the endpoint broadcasts messages to all of the other
/// endpoints in the device.
/// (`kMIDIPropertyIsBroadcast`)
///
/// Only the owning driver may set this property.
func getIsBroadcast(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsBroadcast, of: ref) == 1
}
    
/// Get the unique identifier of an external device attached to this connection.
/// (`kMIDIPropertyConnectionUniqueID`)
///
/// The value provided may be an integer. To indicate that a driver connects to multiple external
/// objects, pass the array of big-endian SInt32 values as a CFData object.
///
/// The property is nonexistent or 0 if there’s no connection.
func getConnectionUniqueID(of ref: CoreMIDI.MIDIObjectRef) -> CoreMIDI.MIDIUniqueID {
    getInteger(forProperty: kMIDIPropertyConnectionUniqueID, of: ref)
}
    
/// Get a Boolean value that indicates whether this entity or endpoint has external MIDI
/// connections.
/// (`kMIDIPropertyIsEmbeddedEntity`)
func getIsEmbeddedEntity(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyIsEmbeddedEntity, of: ref) == 1
}
    
/// Get the 0-based index of the entity on which incoming real-time messages from the device appear
/// to have originated.
/// (`kMIDIPropertySingleRealtimeEntity`)
func getSingleRealtimeEntity(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertySingleRealtimeEntity, of: ref)
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
func getReceiveChannels(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyReceiveChannels, of: ref)
}
    
/// Get the bitmap of channels on which the object transmits messages.
/// (`kMIDIPropertyTransmitChannels`)
func getTransmitChannels(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyTransmitChannels, of: ref)
}
    
/// Get the bitmap of channels on which the object transmits messages.
/// (`kMIDIPropertyMaxReceiveChannels`)
func getMaxReceiveChannels(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyMaxReceiveChannels, of: ref)
}
    
/// Get the maximum number of MIDI channels on which a device may simultaneously transmit channel
/// messages.
/// (`kMIDIPropertyMaxTransmitChannels`)
///
/// Common values are 0, 1, or 16.
func getMaxTransmitChannels(of ref: CoreMIDI.MIDIObjectRef) -> Int32 {
    getInteger(forProperty: kMIDIPropertyMaxTransmitChannels, of: ref)
}
    
// MARK: Banks
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select LSB
/// messages.
/// (`kMIDIPropertyReceivesBankSelectLSB`)
func getReceivesBankSelectLSB(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesBankSelectLSB, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI bank select MSB
/// messages.
/// (`kMIDIPropertyReceivesBankSelectMSB`)
func getReceivesBankSelectMSB(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesBankSelectMSB, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select LSB
/// messages.
/// (`kMIDIPropertyTransmitsBankSelectLSB`)
func getTransmitsBankSelectLSB(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsBankSelectLSB, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI bank select MSB
/// messages.
/// (`kMIDIPropertyTransmitsBankSelectMSB`)
func getTransmitsBankSelectMSB(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsBankSelectMSB, of: ref) == 1
}
    
// MARK: Notes
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI Note On
/// messages.
/// (`kMIDIPropertyReceivesNotes`)
func getReceivesNotes(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesNotes, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI note messages.
/// (`kMIDIPropertyTransmitsNotes`)
func getTransmitsNotes(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsNotes, of: ref) == 1
}
    
// MARK: Program Changes
    
/// Get a Boolean value that indicates whether the device or entity responds to MIDI Program Change
/// messages.
/// (`kMIDIPropertyReceivesProgramChanges`)
func getReceivesProgramChanges(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyReceivesProgramChanges, of: ref) == 1
}
    
/// Get a Boolean value that indicates whether the device or entity transmits MIDI Program Change
/// messages.
/// (`kMIDIPropertyTransmitsProgramChanges`)
func getTransmitsProgramChanges(of ref: CoreMIDI.MIDIObjectRef) -> Bool {
    getInteger(forProperty: kMIDIPropertyTransmitsProgramChanges, of: ref) == 1
}
    
// MARK: - Full Property List
    
// For full details:
// https://developer.apple.com/documentation/coremidi/midi_services/midi_object_properties
//
//
//      Implemented in MIDIKit
//     / Device
//    / / Entity
//   / / / Endpoint
//  / / / /
// *|D|E|E|   Core MIDI Constant                       value type
// -|-|-|-|------------------------------------------- ----------
//  | | | | Identification:
// *|•|•|•|   kMIDIPropertyName                        string
// *|•| |•|   kMIDIPropertyModel                       string
// *|•| |•|   kMIDIPropertyManufacturer                string
// *|•|•|•|   kMIDIPropertyUniqueID                    int32
// *|•|•| |   kMIDIPropertyDeviceID                    int32
// --------------------------------------------------------------
//  | | | | Capabilities:
// *|•|•| |   kMIDIPropertySupportsMMC                 int32 0/1
// *|•|•| |   kMIDIPropertySupportsGeneralMIDI         int32 0/1
// *|•| | |   kMIDIPropertySupportsShowControl         int32 0/1
// --------------------------------------------------------------
//  | | | | Configuration:
// deprecated kMIDIPropertyNameConfiguration           CFDictionary
// *|•| | |   kMIDIPropertyNameConfigurationDictionary CFDictionary
// *|?|?|?|   kMIDIPropertyMaxSysExSpeed               int32
// *|•| | |   kMIDIPropertyDriverDeviceEditorApp       string (path to app to configure device)
// --------------------------------------------------------------
//  | | | | Presentation:
// *|•| | |   kMIDIPropertyImage                       string (POSIX path to image file)
// *| |?|•|   kMIDIPropertyDisplayName                 string
// --------------------------------------------------------------
//  | | | | Audio:
// *|•|•| |   kMIDIPropertyPanDisruptsStereo           int32 0/1
// --------------------------------------------------------------
//  | | | | Protocols:
// *| | |•|   kMIDIPropertyProtocolID                  ProtocolID (macOS 11.0 only)
// --------------------------------------------------------------
//  | | | | Timing:
// *|•|•| |   kMIDIPropertyTransmitsMTC                int32 0/1
// *|•|•| |   kMIDIPropertyReceivesMTC                 int32 0/1
// *|•|•| |   kMIDIPropertyTransmitsClock              int32 0/1
// *|•|•| |   kMIDIPropertyReceivesClock               int32 0/1
// *|?|?|?|   kMIDIPropertyAdvanceScheduleTimeMuSec    int32
// --------------------------------------------------------------
//  | | | | Roles:
// *|•|•| |   kMIDIPropertyIsMixer                     int32 0/1
// *|•|•| |   kMIDIPropertyIsSampler                   int32 0/1
// *|•|•| |   kMIDIPropertyIsEffectUnit                int32 0/1
// *|•|•| |   kMIDIPropertyIsDrumMachine               int32 0/1
// --------------------------------------------------------------
//  | | | | Status:
// *|•|•|•|   kMIDIPropertyOffline                     int32 0/1
// *| | |•|   kMIDIPropertyPrivate                     int32 0/1
// --------------------------------------------------------------
//  | | | | Drivers:
// *|•|•|•|   kMIDIPropertyDriverOwner                 string
// *|•|•|•|   kMIDIPropertyDriverVersion               int32
// --------------------------------------------------------------
//  | | | | Connections:
// *|•|•| |   kMIDIPropertyCanRoute                    int32 0/1
// *| | |•|   kMIDIPropertyIsBroadcast                 int32 0/1
// *| | |?|   kMIDIPropertyConnectionUniqueID          int32 or CFDataRef
// *| |•|•|   kMIDIPropertyIsEmbeddedEntity            int32 0/1
// *|?| |?|   kMIDIPropertySingleRealtimeEntity        int32
// --------------------------------------------------------------
//  | | | | Channels:
// *|?|?|?|   kMIDIPropertyReceiveChannels             int32 (bitmap)
// *|?|?|?|   kMIDIPropertyTransmitChannels            int32 (bitmap)
// *|•| | |   kMIDIPropertyMaxReceiveChannels          int32 0-16
// *|•| | |   kMIDIPropertyMaxTransmitChannels         int32 0/1
// --------------------------------------------------------------
//  | | | | Banks:
// *|•|•| |   kMIDIPropertyReceivesBankSelectLSB       int32 0/1
// *|•|•| |   kMIDIPropertyReceivesBankSelectMSB       int32 0/1
// *|•|•| |   kMIDIPropertyTransmitsBankSelectLSB      int32 0/1
// *|•|•| |   kMIDIPropertyTransmitsBankSelectMSB      int32 0/1
// --------------------------------------------------------------
//  | | | | Notes:
// *|•|•| |   kMIDIPropertyReceivesNotes               int32 0/1
// *|•|•| |   kMIDIPropertyTransmitsNotes              int32 0/1
// --------------------------------------------------------------
//  | | | | Program Changes:
// *|•|•| |   kMIDIPropertyReceivesProgramChanges      int32 0/1
// *|•|•| |   kMIDIPropertyTransmitsProgramChanges     int32 0/1

#endif
