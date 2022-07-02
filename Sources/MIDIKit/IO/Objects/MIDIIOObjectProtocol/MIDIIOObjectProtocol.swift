//
//  MIDIIOObjectProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

    import Foundation

    #if canImport(AppKit)
    import AppKit
    #endif

    #if canImport(UIKit)
    import UIKit
    #endif

public protocol MIDIIOObjectProtocol {
    
    /// Enum describing the abstracted object type.
    var objectType: MIDI.IO.ObjectType { get }
    
    /// Name of the object.
    var name: String { get }
    
    /// The unique ID for the Core MIDI object.
    var uniqueID: MIDI.IO.UniqueID { get }
    
    /// The Core MIDI object reference.
    var coreMIDIObjectRef: MIDI.IO.ObjectRef { get }
    
    // MARK: - MIDIIOObjectProtocol Comparison.swift
    
    static func == (lhs: Self, rhs: Self) -> Bool
    func hash(into hasher: inout Hasher)
    
    
    // MARK: - MIDIIOObjectProtocol Properties.swift
    
    // Identification
    func getName() -> String?
    func getModel() -> String?
    func getManufacturer() -> String?
    func getUniqueID() -> MIDI.IO.UniqueID
    func getDeviceManufacturerID() -> Int32
    
    // Capabilities
    func getSupportsMMC() -> Bool
    func getSupportsGeneralMIDI() -> Bool
    func getSupportsShowControl() -> Bool
    
    // Configuration
    @available(macOS 10.15, macCatalyst 13.0, iOS 13.0, *)
    func getNameConfigurationDictionary() -> NSDictionary?
    func getMaxSysExSpeed() -> Int32
    func getDriverDeviceEditorApp() -> URL?
    
    // Presentation
    func getImageFileURL() -> URL?
    #if canImport(AppKit) && os(macOS)
    func getImageAsNSImage() -> NSImage?
    #endif
    #if canImport(UIKit)
    func getImageAsUIImage() -> UIImage?
    #endif
    func getDisplayName() -> String?
    
    // Audio
    func getPanDisruptsStereo() -> Bool
    
    // Protocols
    @available(macOS 11.0, macCatalyst 14.0, iOS 14.0, *)
    func getProtocolID() -> MIDI.IO.ProtocolVersion?
    
    // Timing
    func getTransmitsMTC() -> Bool
    func getReceivesMTC() -> Bool
    func getTransmitsClock() -> Bool
    func getReceivesClock() -> Bool
    func getAdvanceScheduleTimeMuSec() -> String?
    
    // Roles
    func getIsMixer() -> Bool
    func getIsSampler() -> Bool
    func getIsEffectUnit() -> Bool
    func getIsDrumMachine() -> Bool
    
    // Status
    func getIsOffline() -> Bool
    func getIsPrivate() -> Bool
    
    // Drivers
    func getDriverOwner() -> String?
    func getDriverVersion() -> Int32
    
    // Connections
    func getCanRoute() -> Bool
    func getIsBroadcast() -> Bool
    func getConnectionUniqueID() -> MIDI.IO.UniqueID
    func getIsEmbeddedEntity() -> Bool
    func getSingleRealtimeEntity() -> Int32
    
    // Channels
    func getReceiveChannels() -> Int32
    func getTransmitChannels() -> Int32
    func getMaxReceiveChannels() -> Int32
    func getMaxTransmitChannels() -> Int32
    
    // Banks
    func getReceivesBankSelectLSB() -> Bool
    func getReceivesBankSelectMSB() -> Bool
    func getTransmitsBankSelectLSB() -> Bool
    func getTransmitsBankSelectMSB() -> Bool
    
    // Notes
    func getReceivesNotes() -> Bool
    func getTransmitsNotes() -> Bool
    func getReceivesProgramChanges() -> Bool
    func getTransmitsProgramChanges() -> Bool
    
    
    // MARK: - MIDIIOObjectProtocol Properties Dictionary.swift
    
    func getPropertiesAsStrings(
        onlyIncludeRelevant: Bool
    ) -> [(key: String, value: String)]
    
    
    // MARK: - AnyMIDIIOObject.swift
    
    func asAnyMIDIIOObject() -> MIDI.IO.AnyMIDIIOObject
    
}

#endif
